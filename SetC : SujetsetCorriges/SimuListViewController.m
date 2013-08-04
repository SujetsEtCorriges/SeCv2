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
    
    NSArray *concoursTab;
    NSArray *filiereBacTab;
    NSArray *filiereCPGETab;
    
    
    NSString *filiere;
    NSString *concours;
}
 
@property (nonatomic, strong) IBOutlet UIView *scrollsView;
@property (nonatomic, strong) IBOutlet CPGEView *cpgeView;
@property (nonatomic, strong) IBOutlet BacView *bacView;
@property (weak, nonatomic) IBOutlet UIView *filiereView;

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
    for (NSUInteger i = 0; i < [concoursTab count]; i++)
    {
        if (i == 0)
            tailleIcone = 70;
        else
            tailleIcone = 60;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperWidth)*i + 40, 0, tailleIcone, tailleIcone)];
                
        NSString *path = [[NSBundle mainBundle] pathForResource:[concoursTab objectAtIndex:i] ofType:@"png"];
        UIImage *imageTemp = [UIImage imageWithContentsOfFile:path];
        
        imageView.image = imageTemp;
        imageView.tag = i;
        [scrollViewConcours_ addSubview:imageView];
    }
    CGSize contentSize = CGSizeMake((paperWidth)*[concoursTab count], scrollViewConcours_.bounds.size.height);
    scrollViewConcours_.contentSize = contentSize;
    scrollViewConcours_.delegate = self;
    
    
    [self fillFiliereScrollViewWithArray:filiereCPGETab];
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
    concoursTab = [[NSArray alloc]
                    initWithObjects:@"Centrale-Supelec",@"Mines-Ponts",@"CCP",@"Banque PT",@"Baccalaureat",nil];
    
    filiereBacTab = [[NSArray alloc]
                      initWithObjects:@"ES", @"L", @"S", nil];
    
    filiereCPGETab = [[NSArray alloc]
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
    for (UIView *view in [_filiereView subviews])
        [view removeFromSuperview];
    
    CGFloat widthCell = (self.view.bounds.size.width)/[array count];
    
    //adding cells in cellsView
    for (int i=0; i<[array count]; i++)
    {
        UIButton *filiereButton = [[UIButton alloc] initWithFrame:CGRectMake(widthCell*i, 0, widthCell, 30)];
        
        [filiereButton setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [filiereButton setTitleColor:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1.0] forState:UIControlStateNormal];
        [filiereButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        if (i == 0)
        {
            [filiereButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
            filiere = [array objectAtIndex:i];
        }
        else
            [filiereButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        
        [filiereButton setBackgroundColor:[UIColor clearColor]];
        
        [filiereButton addTarget:self action:@selector(filiereSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [_filiereView addSubview:filiereButton];
    }
}

#pragma mark - UIButton Action
- (void)filiereSelected:(UIButton*)button
{
    for (UIButton *filiereButton in [_filiereView subviews])
        [filiereButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    
    [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
    filiere = [button.titleLabel text];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) //si l'utilisateur scroll les concours
    {
        //CGFloat pageWidth = scrollView.frame.size.width;
        CGFloat pageWidth = 140;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (oldPage != page && page<[concoursTab count]) //si changement de concours
        {
            NSLog(@"%d",page);
            
            //Zoom algorithm
            UIImageView *imageViewZoom = (UIImageView *)[scrollView viewWithTag:page];
            imageViewZoom.frame = CGRectMake(imageViewZoom.frame.origin.x, imageViewZoom.frame.origin.y, 70, 70);
            
            UIImageView *imageViewOld = (UIImageView *)[scrollView viewWithTag:oldPage];
            imageViewOld.frame = CGRectMake(imageViewOld.frame.origin.x, imageViewOld.frame.origin.y, 60, 60);
            
            [self removeOptionsFromView];
            
            if ([[concoursTab objectAtIndex:page] isEqualToString:@"Baccalaureat"])
            {
                [self fillFiliereScrollViewWithArray:filiereBacTab];
                [self displayOptionsBac];
            }
            else if ([[concoursTab objectAtIndex:page] isEqualToString:@"Banque PT"])
            {
                [self fillFiliereScrollViewWithArray:[[NSArray alloc]initWithObjects:@"PT",nil]];
                [self displayOptionsCPGE];
            }
            else
            {
                [self fillFiliereScrollViewWithArray:filiereCPGETab];
                [self displayOptionsCPGE];
            }
                
            oldPage = page;
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
