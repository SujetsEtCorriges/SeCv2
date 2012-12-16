//
//  SecondViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 15/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SujetsCorrigesViewController.h"

@interface SujetsCorrigesViewController ()

@end

@implementation SujetsCorrigesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sujetsCorrigesNavigation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
