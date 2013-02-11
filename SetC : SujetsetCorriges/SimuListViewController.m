//
//  SimuListViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SimuListViewController.h"

@interface SimuListViewController ()

@end

@implementation SimuListViewController

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
    
    [self initTabs];
    
    CGFloat paperWidth = 320;
    CGFloat tailleIcone = 60;
    
    NSUInteger numberOfPapers = [concoursTab_ count];
    for (NSUInteger i = 0; i < numberOfPapers; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperWidth)*i + 130, 0, tailleIcone, tailleIcone)];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:[concoursTab_ objectAtIndex:i] ofType:@"png"];
        UIImage *imageTemp = [UIImage imageWithContentsOfFile:path];
        
        imageView.image = imageTemp;
        [scrollViewConcours_ addSubview:imageView];
    }
    
    CGSize contentSize = CGSizeMake((paperWidth)*numberOfPapers, scrollViewConcours_.bounds.size.height);
    scrollViewConcours_.contentSize = contentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabs
{
    concoursTab_ = [[NSArray alloc]
                    initWithObjects:@"Centrale-Supelec",@"Mines-Ponts",@"CCP",@"Banque PT",@"Baccalaureat",nil];
    
    filiereBacTab_ = [[NSArray alloc]
                      initWithObjects:@"ES", @"L", @"S", nil];
    
    filiereCPGETab_ = [[NSArray alloc]
                       initWithObjects:@"MP", @"PC", @"PSI", nil];
}

- (void)viewDidUnload {
    startButton = nil;
    [super viewDidUnload];
}
- (IBAction)startButtonPushed:(id)sender {
}
@end
