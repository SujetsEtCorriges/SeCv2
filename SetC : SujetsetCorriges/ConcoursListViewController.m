//
//  ConcoursListViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "ConcoursListViewController.h"

#import "VariableStore.h"
#import "ECSlidingViewController.h"

@interface ConcoursListViewController ()

@end

@implementation ConcoursListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *tableauBac = [[NSArray alloc]
                           initWithObjects:@"S",@"ES",@"L",nil];
    NSArray *tableauCPGESup = [[NSArray alloc]
                               initWithObjects:@"Mines",@"ENAC EPL",nil];
    NSArray *tableauCPGESpe = [[NSArray alloc]
                               initWithObjects:@"Banque PT",@"Centrale-Supélec",@"CCP",@"E3A",@"ENS",@"ICNA",@"Mines-Ponts",@"Polytechnique",@"CNC",nil];
    listeSection_ = [[NSDictionary alloc]
                     initWithObjectsAndKeys:tableauBac,@"BAC",tableauCPGESup,@"CPGE Sup",tableauCPGESpe,@"CPGE Spé",nil];
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
    return [listeSection_.allKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //taille des cellules
    return 40;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [listeSection_.allKeys objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[listeSection_ objectForKey:[listeSection_.allKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[listeSection_ objectForKey:[listeSection_.allKeys objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    /*PageSujetViewController *pageVC = [[PageSujetViewController alloc] initWithNibName:@"PageSujetViewController" bundle:nil];
    pageVC.concours = cell.textLabel.text;
    
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:pageVC];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];*/
    
    VariableStore *obj=[VariableStore getInstance];
    obj.concours = cell.textLabel.text;
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sujetsCorrigesNavigation"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end