//
//  TabBarController.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 11/09/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITabBarItem *item0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:2];
    
    [item0 setFinishedSelectedImage:[UIImage imageNamed:@"166-newspaper-inv.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"166-newspaper.png"]];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"16-line-chart-inv.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"16-line-chart.png"]];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"16-line-chart-inv.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"16-line-chart.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
