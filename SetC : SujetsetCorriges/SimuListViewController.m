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
 
@property (nonatomic, strong) IBOutlet UIView *scrollsView;
@property (nonatomic, strong) IBOutlet CPGEView *cpgeView;
@property (nonatomic, strong) IBOutlet BacView *bacView;

@end

@implementation SimuListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTabs];
    [self displayOptionsCPGE];
    
    oldPage = 1;
    page = 1;
    
    CGFloat paperWidth = 140;
    CGFloat tailleIcone = 60;
    
    //initialisation de la scrollView Concours
    for (NSUInteger i = 0; i < [concoursTab_ count]; i++)
    {
        if (i == 0)
            tailleIcone = 70;
        else
            tailleIcone = 60;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperWidth)*i + 40, 0, tailleIcone, tailleIcone)];
        
        //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130*(i+1), 0, tailleIcone, tailleIcone)];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:[concoursTab_ objectAtIndex:i] ofType:@"png"];
        UIImage *imageTemp = [UIImage imageWithContentsOfFile:path];
        
        imageView.image = imageTemp;
        imageView.tag = i;
        [scrollViewConcours_ addSubview:imageView];
    }
    CGSize contentSize = CGSizeMake((paperWidth)*[concoursTab_ count], scrollViewConcours_.bounds.size.height);
    scrollViewConcours_.contentSize = contentSize;
    scrollViewConcours_.delegate = self;
    
    
    [self fillFiliereScrollViewWithArray:filiereCPGETab_];
    UIButton *arrowL = (UIButton *)[self.view viewWithTag:600];
    arrowL.hidden = YES;
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scrollViewFiliere_.frame.size.width*i, 0,scrollViewFiliere_.frame.size.width, scrollViewFiliere_.frame.size.height)];
        label.text = [array objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        
        [scrollViewFiliere_ addSubview:label];
    }
    CGSize contentSize = CGSizeMake(scrollViewFiliere_.frame.size.width*[array count], scrollViewFiliere_.frame.size.height);
    scrollViewFiliere_.contentSize = contentSize;
    scrollViewFiliere_.delegate = self;
}



#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) //si l'utilisateur scroll les concours
    {
        //CGFloat pageWidth = scrollView.frame.size.width;
        CGFloat pageWidth = 140;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (oldPage != page && page<[concoursTab_ count]) //si changement de concours
        {
            NSLog(@"%d",page);
            
            //Zoom algorithm
            UIImageView *imageViewZoom = (UIImageView *)[scrollView viewWithTag:page];
            imageViewZoom.frame = CGRectMake(imageViewZoom.frame.origin.x, imageViewZoom.frame.origin.y, 70, 70);
            
            UIImageView *imageViewOld = (UIImageView *)[scrollView viewWithTag:oldPage];
            imageViewOld.frame = CGRectMake(imageViewOld.frame.origin.x, imageViewOld.frame.origin.y, 60, 60);
            
            
            [self removeOptionsFromView];
            
            //on met à jour les filières
            UIButton *arrowL = (UIButton *)[self.view viewWithTag:600];
            UIButton *arrowR = (UIButton *)[self.view viewWithTag:601];
            if ([[concoursTab_ objectAtIndex:page] isEqualToString:@"Baccalaureat"])
            {
                [self fillFiliereScrollViewWithArray:filiereBacTab_];
                arrowL.hidden = YES;
                arrowR.hidden = NO;
                
                [self displayOptionsBac];
            }
                
            else if ([[concoursTab_ objectAtIndex:page] isEqualToString:@"Banque PT"])
            {
                [self fillFiliereScrollViewWithArray:[[NSArray alloc] initWithObjects:@"PT", nil]];
                arrowL.hidden = YES;
                arrowR.hidden = YES;
                
                [self displayOptionsCPGE];
                
                
            } 
            else if (![[concoursTab_ objectAtIndex:page] isEqualToString:@"Baccalaureat"])
            {
                [self fillFiliereScrollViewWithArray:filiereCPGETab_];
                arrowL.hidden = YES;
                arrowR.hidden = NO;
                
                [self displayOptionsCPGE];
            }
                
            
            CGRect frame = scrollView.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            [scrollViewFiliere_ scrollRectToVisible:frame animated:YES];
            oldPage = page;
        }
    }
    else if (scrollView.tag == 101)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger filiere = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        UIButton *arrowL = (UIButton *)[self.view viewWithTag:600];
        UIButton *arrowR = (UIButton *)[self.view viewWithTag:601];
        
        if (filiere == 0)
        {
            arrowL.hidden = YES;
            arrowR.hidden = NO;
        }
        else if (filiere == 2)
        {
            arrowL.hidden = NO;
            arrowR.hidden = YES;
        }
        else
        {
            arrowL.hidden = NO;
            arrowR.hidden = NO;
        }
    }
    
}


#pragma mark - Display option of concours
- (void)displayOptionsCPGE
{
    //animmation sur la cellule
    _cpgeView = [[CPGEView alloc] initCPGEViewAtPosition:_scrollsView.bounds.size.height];
    _cpgeView.delegate = self;
    [self.view addSubview:_cpgeView];
}

- (void)displayOptionsBac
{
    [_cpgeView removeFromSuperview];
    
    _bacView = [[BacView alloc] initBacViewAtPosition:_scrollsView.bounds.size.height];
    [self.view addSubview:_bacView];
}

-(void)removeOptionsFromView
{
    [_cpgeView removeFromSuperview];
    [_bacView removeFromSuperview];
}


#pragma mark - CPGEViewDelegate
-(void)statutCPGEChanged:(NSString *)statut
{
    //NSLog(@"changed : %@", statut);
}


@end
