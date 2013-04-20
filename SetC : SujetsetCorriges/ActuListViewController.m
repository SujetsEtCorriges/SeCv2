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
#define kURL @"http://www.sujetsetcorriges.fr/api/get_recent_posts/"

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
    
    //initialisation des variables
    firstRefresh = YES;
    newsData_ = [[NSMutableArray alloc] init];
    
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
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}

- (void) parseNews:(id)sender
{
    @autoreleasepool
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (firstRefresh)
        {
            MBProgressHUD *chargementHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [chargementHUD setLabelText:@"Chargement"];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kURL]];
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        newsData_ = [json objectForKey:@"posts"];
        [self.tableView reloadData];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [pull finishedLoading];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.refreshControl endRefreshing];
        
        firstRefresh = NO;
    }
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
    
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLabel.text = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.dateLabel.text = [self convertDate:[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"]];
    int nbComments = [[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"comment_count"] integerValue];
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

    return cell;
}


- (NSString*)convertDate:(NSString*)dateEN
{
    //définition des locales pour la date
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSLocale *usLocale = [[NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
    
    //conversion de la date en NSSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [dateFormatter dateFromString:dateEN];
    
    //conversion du NSDate en string FR
    [dateFormatter setLocale:frLocale];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
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
        
        destViewController.url = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"url"];
        destViewController.texte = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"content"];
        destViewController.titre = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
        destViewController.auteur = [[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"author"] objectForKey:@"name"];
        destViewController.date = [self convertDate:[[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"]];
        destViewController.idArticle = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"id"];
    }
}


//méthode pour le pull to refreshecho
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}


-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}



#pragma mark - UIRefreshControl Delegate
-(void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Chargement"];

    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
    
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:frLocale];
    [formatter setDateFormat:@"dd MMMM - HH:mm:ss"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Mis à jour le %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

@end
