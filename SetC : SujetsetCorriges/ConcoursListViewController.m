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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [listeSection_.allKeys objectAtIndex:section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float headerHeight = 20;
    UIView *viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    viewSection.backgroundColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    viewSection.backgroundColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    
    CAGradientLayer *shadowSection = [CAGradientLayer layer];
    shadowSection.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.40 alpha:1.0].CGColor,(id)[UIColor colorWithWhite:0.45 alpha:1.0].CGColor,nil];
    CGRect frameShadow = viewSection.frame;
    frameShadow.size.height = headerHeight-5;
    shadowSection.frame = frameShadow;
    shadowSection.startPoint = CGPointMake(0.5, 0);
    shadowSection.endPoint = CGPointMake(0.5,1);
    //[viewSection.layer addSublayer:shadowSection];
    
    CALayer *lineTop = [CALayer layer];
    lineTop.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    lineTop.frame = CGRectMake(0, 0, 320, 1);
    //[viewSection.layer addSublayer:lineTop];
    
    CALayer *lineBottom = [CALayer layer];
    lineBottom.backgroundColor = [UIColor colorWithWhite:0.30 alpha:1.0].CGColor;
    lineBottom.frame = CGRectMake(0, headerHeight-1, 320, 1);
    //[viewSection.layer addSublayer:lineBottom];
    
    UILabel *labelSection = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, headerHeight)];
    labelSection.backgroundColor = [UIColor clearColor];
    labelSection.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    labelSection.font = [UIFont fontWithName:@"Helvetica" size:13];
    labelSection.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    //labelSection.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    //labelSection.shadowColor = [UIColor blackColor];
    //labelSection.shadowOffset = CGSizeMake(0, 1);
    labelSection.text = [listeSection_.allKeys objectAtIndex:section];
    [viewSection addSubview:labelSection];
    
    return viewSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[listeSection_ objectForKey:[listeSection_.allKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConcoursCell";
    ConcoursCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ConcoursCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.concoursLabel.text = [[listeSection_ objectForKey:[listeSection_.allKeys objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    /*PageSujetViewController *pageVC = [[PageSujetViewController alloc] initWithNibName:@"PageSujetViewController" bundle:nil];
    pageVC.concours = cell.textLabel.text;
    
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:pageVC];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];*/
    
    VariableStore *obj = [VariableStore getInstance];
    obj.concours = [[listeSection_ objectForKey:[listeSection_.allKeys objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    obj.filiere = @"MP";
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sujetsCorrigesNavigation"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end