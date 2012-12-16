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

@interface ActuListViewController ()

@end

@implementation ActuListViewController
{
    PullToRefreshView *pull;
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
    
    //notification de rafraichissement
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    //initialisation de la vue pull to refresh
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
    
    newsData_ = [[NSMutableArray alloc] init];
    
    //parsage des news
    parser_ = [[XMLParser alloc] init];
    parser_.delegate = self;
    
    NSString *rssURL = @"http://www.sujetsetcorriges.fr/rss";
    [self performSelectorInBackground:@selector(parseNews:) withObject:rssURL];
    
    
}

- (void) parseNews:(NSString*)theURL
{
    @autoreleasepool
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MBProgressHUD *chargementHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [chargementHUD setLabelText:@"Chargement"];
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
    static NSString *CellIdentifier = @"newsCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    //configuration de la cellulle titre
    cell.textLabel.text = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [self convertDate:[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
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
    [dateFormatter setDateFormat:@"dd/MM"];
    NSString *convertedStringDate = [dateFormatter stringFromDate:convertedDate];
    
    return convertedStringDate;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*ActuDetailViewController *actuDetailViewController = [[ActuDetailViewController alloc] init];
    
    actuDetailViewController.url = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"link"];
    actuDetailViewController.texte = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"summary"];
    actuDetailViewController.titre = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
    actuDetailViewController.auteur = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"author"];
    actuDetailViewController.date = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"];
    actuDetailViewController.idArticle = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    [self.navigationController pushViewController:actuDetailViewController animated:YES];*/
    
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


//méthode pour le pull to refresh

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
}

- (void) xmlParser:(XMLParser *)parser didFailWithError:(NSArray *)error
{
    
}

@end
