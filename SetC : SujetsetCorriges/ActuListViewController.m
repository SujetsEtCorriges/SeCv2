//
//  ActuListViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "ActuListViewController.h"

#import "MBProgressHUD.h"
#import "ActuDetailsViewController.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ActuListViewController ()

@end

@implementation ActuListViewController
{
    PullToRefreshView *pull;
    BOOL firstRefresh;
}




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    firstRefresh = YES;
    
    newsData_ = [[NSMutableArray alloc] init];
    
    //parsage des news
    parser_ = [[XMLParser alloc] init];
    parser_.delegate = self;
    NSString *rssURL = @"http://www.sujetsetcorriges.fr/rss";
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        //notification de rafraichissement
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(foregroundRefresh:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        //initialisation de la vue pull to refresh
        pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
        [pull setDelegate:self];
        [self.tableView addSubview:pull];
    }
    else
    {
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tirez pour rafraîchir"];
        [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
    }
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:rssURL];
    
    
    
}

- (void) parseNews:(NSString*)theURL
{
    @autoreleasepool
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (firstRefresh)
        {
            MBProgressHUD *chargementHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [chargementHUD setLabelText:@"Chargement"];
        }
        [parser_ parseXMLFileAtURL:theURL];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsData_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    
//    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLabel.text = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.dateLabel.text = [self convertDate:[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"]];
    int nbComments = [[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"nbcomments"] integerValue];
    NSString *stringNbComments;
    if (nbComments == 0 || nbComments == 1)
    {
        stringNbComments = [NSString stringWithFormat:@"%i commentaire",nbComments];
    }
    else
    {
        stringNbComments = [NSString stringWithFormat:@"%i commentaires",nbComments];
    }
    cell.nbcommentsLabel.text = stringNbComments;
    //configuration de la cellulle titre
    //cell.textLabel.text = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
    //cell.detailTextLabel.text = [self convertDate:[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    //renvoie de la cellule
    return cell;
}


- (NSString*)convertDate:(NSString*)dateEN
{
    //configuation de la cellule date
    //définition des locales pour la date
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSLocale *usLocale = [[NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
    
    //conversion de la date en NSSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss '+0000'"];
    NSDate *convertedDate = [dateFormatter dateFromString:dateEN];
    [dateFormatter setLocale:frLocale];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *convertedStringDate = [dateFormatter stringFromDate:convertedDate];
    
    return convertedStringDate;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"pushToNewsDetails" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToNewsDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ActuDetailsViewController *destViewController = segue.destinationViewController;
        
        destViewController.url = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"link"];
        destViewController.texte = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"summary"];
        destViewController.titre = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
        destViewController.auteur = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"author"];
        destViewController.date = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"];
        destViewController.idArticle = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"id"];
    }
}


//méthode pour le pull to refreshecho
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    NSString *rssURL = @"http://www.sujetsetcorriges.fr/rss";
    [self performSelectorInBackground:@selector(parseNews:) withObject:rssURL];
}


-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    NSString *rssURL = @"http://www.sujetsetcorriges.fr/rss";
    [self performSelectorInBackground:@selector(parseNews:) withObject:rssURL];
}


#pragma mark - XMLParserDelegate
- (void) xmlParser:(XMLParser *)parser didFinishParsing:(NSArray *)array
{
    newsData_ = parser_.XMLData;
    [self.tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [pull finishedLoading];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.refreshControl endRefreshing];
    
    firstRefresh = NO;
}

- (void) xmlParser:(XMLParser *)parser didFailWithError:(NSArray *)error
{
    
}

-(void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Chargement"];
    // custom refresh logic would be placed here...
    NSString *rssURL = @"http://www.sujetsetcorriges.fr/rss";
    //[self performSelectorInBackground:@selector(parseNews:) withObject:rssURL];
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:rssURL];
    //[parser_ parseXMLFileAtURL:rssURL];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM - h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Mis à jour le %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    //[refresh endRefreshing];
    
}



- (IBAction)refreshNews:(id)sender
{
    
}
@end
