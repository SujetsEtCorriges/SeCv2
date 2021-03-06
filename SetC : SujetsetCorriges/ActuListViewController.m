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

#define kURL @"http://www.sujetsetcorriges.fr/api/get_recent_posts/"
#define kStringRefresh @"Tirez pour rafraichir"
#define kStringLoading @"Chargement"

@interface ActuListViewController ()
{
    BOOL firstRefresh;
}

@property (nonatomic, copy) NSArray *newsData;

@end

@implementation ActuListViewController


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
        
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:kStringRefresh];
    [refreshString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:14.0] range:NSMakeRange(0, [kStringRefresh length])];
    refresh.attributedTitle = refreshString;
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tirez pour rafraîchir"];
    //refresh.tintColor = [UIColor colorWithRed:14/255.0f green:156/255.0f blue:255/255.0f alpha:1];
    [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}

- (void) parseNews:(id)sender
{    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (firstRefresh)
    {
        MBProgressHUD *chargementHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [chargementHUD setLabelText:@"Chargement"];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kURL]];
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *newsArray = [json objectForKey:@"posts"];
    _newsData = [[NSArray alloc] initWithArray:newsArray];
    
    [self performSelectorOnMainThread:@selector(newsLoaded) withObject:nil waitUntilDone:YES];
}

- (void)newsLoaded
{
    [self.tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:frLocale];
    [formatter setDateFormat:@"dd MMMM - HH:mm:ss"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Mis à jour le %@",
                             [formatter stringFromDate:[NSDate date]]];
    //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    NSMutableAttributedString *refreshedString = [[NSMutableAttributedString alloc] initWithString:lastUpdated];
    [refreshedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:11.0] range:NSMakeRange(0, [lastUpdated length])];
    self.refreshControl.attributedTitle = refreshedString;
    
    [self.refreshControl endRefreshing];
    firstRefresh = NO;
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
    return [_newsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.titleLabel.text = [self cleanString:[[_newsData objectAtIndex:indexPath.row] objectForKey:@"title"]];
    cell.dateLabel.text = [self convertDate:[[_newsData objectAtIndex:indexPath.row] objectForKey:@"date"]];
    int nbComments = [[[_newsData objectAtIndex:indexPath.row] objectForKey:@"comment_count"] integerValue];
    NSString *stringNbComments;
    if (nbComments == 0 || nbComments == 1)
        stringNbComments = [NSString stringWithFormat:@"%i commentaire",nbComments];
    else
        stringNbComments = [NSString stringWithFormat:@"%i commentaires",nbComments];

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
        
        destViewController.url = [[_newsData objectAtIndex:indexPath.row] objectForKey:@"url"];
        destViewController.texte = [[_newsData objectAtIndex:indexPath.row] objectForKey:@"content"];
        destViewController.titre = [self cleanString:[[_newsData objectAtIndex:indexPath.row] objectForKey:@"title"]];
        destViewController.auteur = [[[_newsData objectAtIndex:indexPath.row] objectForKey:@"author"] objectForKey:@"name"];
        destViewController.date = [self convertDate:[[_newsData objectAtIndex:indexPath.row] objectForKey:@"date"]];
        destViewController.idArticle = [[_newsData objectAtIndex:indexPath.row] objectForKey:@"id"];
    }
}


#pragma mark - UIRefreshControl action
-(void)refreshView:(UIRefreshControl *)refresh
{    
    NSMutableAttributedString *loadingString = [[NSMutableAttributedString alloc] initWithString:kStringLoading];
    [loadingString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:11.0] range:NSMakeRange(0, [kStringLoading length])];
    self.refreshControl.attributedTitle = loadingString;

    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}


#pragma mark - clean string method
- (NSString*)cleanString:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&#xe9;" withString:@"é"];
    string = [string stringByReplacingOccurrencesOfString:@"&#x2019;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&#xe0;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&#xe7;" withString:@"ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&#xea;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&#xef;" withString:@"ï"];
    
    return string;
}

@end
