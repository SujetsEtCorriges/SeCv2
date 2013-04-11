//
//  SimuListViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SimuListViewController.h"

@interface SimuListViewController ()
{
    NSUInteger page;
    NSUInteger oldPage;
}

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
    
    oldPage = 1;
    page = 1;
    
    CGFloat paperWidth = 320;
    CGFloat tailleIcone = 60;
    
    //initialisation de la scrollView Concours
    for (NSUInteger i = 0; i < [concoursTab_ count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperWidth)*i + 130, 0, tailleIcone, tailleIcone)];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:[concoursTab_ objectAtIndex:i] ofType:@"png"];
        UIImage *imageTemp = [UIImage imageWithContentsOfFile:path];
        
        imageView.image = imageTemp;
        [scrollViewConcours_ addSubview:imageView];
    }
    CGSize contentSize = CGSizeMake((paperWidth)*[concoursTab_ count], scrollViewConcours_.bounds.size.height);
    scrollViewConcours_.contentSize = contentSize;
    scrollViewConcours_.delegate = self;
    
    
    [self fillFiliereScrollViewWithArray:filiereCPGETab_];
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

- (void)viewDidUnload
{
    startButton = nil;
    [super viewDidUnload];
}

- (IBAction)startButtonPushed:(id)sender
{
    
}

- (void)fillFiliereScrollViewWithArray:(NSArray *)array
{
    for (NSUInteger i=0; i<[array count]; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(320*i, 0,scrollViewFiliere_.frame.size.width, scrollViewFiliere_.frame.size.height)];
        label.text = [array objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        
        [scrollViewFiliere_ addSubview:label];
    }
    CGSize contentSize = CGSizeMake(320*[array count], scrollViewFiliere_.frame.size.height);
    scrollViewFiliere_.contentSize = contentSize;
    scrollViewFiliere_.delegate = self;
}



#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) //si l'utilisateur scroll les concours
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (oldPage != page) //si changement de concours
        {
            //on met à jour les filières
            if ([[concoursTab_ objectAtIndex:page] isEqualToString:@"Baccalaureat"])
                [self fillFiliereScrollViewWithArray:filiereBacTab_];
            else if ([[concoursTab_ objectAtIndex:page] isEqualToString:@"Banque PT"])
                [self fillFiliereScrollViewWithArray:[[NSArray alloc] initWithObjects:@"PT", nil]];
            else if (![[concoursTab_ objectAtIndex:page] isEqualToString:@"Baccalaureat"])
                [self fillFiliereScrollViewWithArray:filiereCPGETab_];
            
            CGRect frame = scrollView.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            [scrollViewFiliere_ scrollRectToVisible:frame animated:YES];
            oldPage = page;
        }
        
    }
}



@end
