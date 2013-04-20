//
//  CommentsViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 17/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "CommentsViewController.h"
#import "MBProgressHUD.h"

#define kURL @"http://www.sujetsetcorriges.fr/api/get_post/?id="

@interface CommentsViewController ()

@property (nonatomic, copy) NSArray *comments;

@end

@implementation CommentsViewController
{
    
    BOOL firstRefresh;
}



@synthesize url = url_;
@synthesize idArticle = idArticle_;

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
        
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tirez pour rafraîchir"];
    [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}

- (void) parseNews:(id)sender
{
    if (firstRefresh)
    {
        MBProgressHUD *chargementHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [chargementHUD setLabelText:@"Chargement"];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURL, idArticle_]]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *commentArray = [[json objectForKey:@"post"] objectForKey:@"comments"];
    _comments = [[NSArray alloc] initWithArray:commentArray];
    
    [self performSelectorOnMainThread:@selector(commentLoaded) withObject:nil waitUntilDone:YES];
}


- (void)commentLoaded
{
    [self.tableView reloadData];
    
    if (firstRefresh)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    firstRefresh = NO;
    
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:frLocale];
    [formatter setDateFormat:@"dd MMMM - HH:mm:ss"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Mis à jour le %@",
                             [formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
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
    return [_comments count];
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
    cell.textLabel.text = [[_comments objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [self convertDate:[[_comments objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    //renvoie de la cellule
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
    //[self performSegueWithIdentifier: @"pushToNewsDetails" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"pushToNewsDetails"])
//    {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        ActuDetailsViewController *destViewController = segue.destinationViewController;
//        
//        destViewController.url = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"link"];
//        destViewController.texte = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"summary"];
//        destViewController.titre = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"title"];
//        destViewController.auteur = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"author"];
//        destViewController.date = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"date"];
//        destViewController.idArticle = [[newsData_ objectAtIndex:indexPath.row] objectForKey:@"id"];
//    }
}

- (IBAction)closeComments:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)writeComment:(id)sender
{
    
}

#pragma mark - UIRefreshControl action
-(void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Chargement"];
    
    [self performSelectorInBackground:@selector(parseNews:) withObject:nil];
}



@end
