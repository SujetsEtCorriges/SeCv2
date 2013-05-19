//
//  SujetsCorrigesPageViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SujetsCorrigesPageViewController.h"

#import "SujetsCorrigesListViewController.h"
#import "ECSlidingViewController.h"
#import "ConcoursListViewController.h"
#import "VariableStore.h"

//ASIHTTPRequest
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface SujetsCorrigesPageViewController ()

@end

@implementation SujetsCorrigesPageViewController

@synthesize pageController = pageController_;
@synthesize pageContent = pageContent_;
@synthesize concours = concours_;

@synthesize pageControl = pageControl_;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Custom Concours Bouton
    UIButton *concoursButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [concoursButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [concoursButton addTarget:self action:@selector(affichageConcours:) forControlEvents:UIControlEventTouchUpInside];
    concoursButton.showsTouchWhenHighlighted = YES;
    concoursButton.layer.shadowColor = [UIColor blackColor].CGColor;
    concoursButton.layer.shadowOpacity = 0.6;
    concoursButton.layer.shadowRadius = 1;
    concoursButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:concoursButton];
    
    UIView *viewShadowConcours = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    viewShadowConcours.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *shadowConcours = [CAGradientLayer layer];
    shadowConcours.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.8].CGColor,(id)[UIColor colorWithWhite:1 alpha:0.0].CGColor,nil];
    shadowConcours.frame = viewShadowConcours.frame;
    shadowConcours.startPoint = CGPointMake(0.5, 0);
    shadowConcours.endPoint = CGPointMake(0.5,1);
    [viewShadowConcours.layer addSublayer:shadowConcours];
    
    [self.view addSubview:viewShadowConcours];
    
    
    VariableStore *obj=[VariableStore getInstance];
    concours_ = obj.concours;
    filiere_ = obj.filiere;
    
    [self createContentPages];
    
    if (![concours_ isEqualToString:@"Banque PT"] && ![concours_ isEqualToString:@"aucun"])
    {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:filiere_ style:UIBarButtonItemStyleBordered target:self action:@selector(choixFiliere:)];
        
        // Custom Filière Bouton
        filiereButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [filiereButton setTitle:filiere_ forState:UIControlStateNormal];
        [filiereButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        [filiereButton addTarget:self action:@selector(choixFiliere:) forControlEvents:UIControlEventTouchUpInside];
        filiereButton.showsTouchWhenHighlighted = YES;
        filiereButton.layer.shadowColor = [UIColor blackColor].CGColor;
        filiereButton.layer.shadowOpacity = 0.6;
        filiereButton.layer.shadowRadius = 1;
        filiereButton.layer.shadowOffset = CGSizeMake(0, 1);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filiereButton];
    }
    else if ([concours_ isEqualToString:@"Banque PT"])
    {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:filiere_ style:UIBarButtonItemStyleBordered target:self action:nil];
//        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        // Custom Filière Bouton
        filiereButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [filiereButton setTitle:filiere_ forState:UIControlStateNormal];
        [filiereButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        [filiereButton addTarget:self action:@selector(choixFiliere:) forControlEvents:UIControlEventTouchUpInside];
        filiereButton.showsTouchWhenHighlighted = YES;
        filiereButton.layer.shadowColor = [UIColor blackColor].CGColor;
        filiereButton.layer.shadowOpacity = 0.6;
        filiereButton.layer.shadowRadius = 1;
        filiereButton.layer.shadowOffset = CGSizeMake(0, 1);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filiereButton];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
        
    [self createPageViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//SLIDER
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[ConcoursListViewController class]])
    {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"concoursListSideView"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    
    if ([concours_ isEqualToString:@"aucun"])
    {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
    
}

- (IBAction)affichageConcours:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}




#pragma mark - UIPageViewControllerDelegate
- (void)createPageViewController
{
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    
    pageController_.dataSource = self;
    [[pageController_ view] setFrame:[[self view] bounds]];
    
    SujetsCorrigesListViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController_ setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageController_];
    [[self view] addSubview:[pageController_ view]];
    
    [self.view addSubview:pageControl_];
    
    [pageController_ didMoveToParentViewController:self];
}

- (SujetsCorrigesListViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count]))
    {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    SujetsCorrigesListViewController *dataViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sujetsListView"];

    dataViewController.listeSujCor = [self.pageContent objectAtIndex:index];
    return dataViewController;
    
}

- (NSUInteger)indexOfViewController:(SujetsCorrigesListViewController *)viewController
{
    pageControl_.currentPage = [self.pageContent indexOfObject:viewController.listeSujCor];
    return [self.pageContent indexOfObject:viewController.listeSujCor];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SujetsCorrigesListViewController *)viewController];
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SujetsCorrigesListViewController *)viewController];
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    
    if (index == [self.pageContent count])
    {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}




#pragma mark - PickerViewDelegate
- (void) choixFiliere:(id)sender
{
    tabFiliere_ = [[NSArray alloc] initWithObjects:@"MP", @"PC", @"PSI", nil];
    
    menu_ = [[UIActionSheet alloc] initWithTitle:@"Choix de la filiere"
                                        delegate:self
                               cancelButtonTitle:nil
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil];
    
    [menu_ setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [pickerView selectRow:filiereRow_ inComponent:0 animated:YES];
    
    [menu_ addSubview:pickerView];
    
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"OK"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(changeFiliere:) forControlEvents:UIControlEventValueChanged];
    [menu_ addSubview:closeButton];
    
    [menu_ showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [menu_ setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void) changeFiliere:(id)sender
{
    [menu_ dismissWithClickedButtonIndex:0 animated:YES];
    
    VariableStore *obj = [VariableStore getInstance];
    obj.filiere = filiere_;
    
    [self createContentPages];
    
    //self.navigationItem.rightBarButtonItem.title = filiere_;
    
    [filiereButton setTitle:filiere_ forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filiereButton];
    
    SujetsCorrigesListViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController_ setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [tabFiliere_ objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    filiereRow_ = row;
    filiere_ = [tabFiliere_ objectAtIndex:row];
}




#pragma mark - create content pages algorithm
- (void) createContentPages
{
    if ([concours_ isEqualToString:@"aucun"])
    {
        NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
        NSString *temp = @"intro";
        [pageStrings addObject:temp];
        pageContent_ = [[NSArray alloc] initWithArray:pageStrings];
    }
    else
    {
        if ([concours_ isEqualToString:@"Banque PT"])
            filiere_ = @"PT";
        else if ([concours_ isEqualToString:@"ENAC EPL"])
            filiere_ = @"NC";
        
        NSURL *url = [NSURL URLWithString:@"http://www.sujetsetcorriges.fr/gestionXML/extractJSON"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:concours_ forKey:@"concours"];
        [request setPostValue:filiere_ forKey:@"filiere"];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error)
        {
            NSData *response = [request responseData];
            NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
            
            //initialisation des variables temporaire
            NSDictionary *tempSujCor = [[NSDictionary alloc] init];
            NSString *tempMatiere = [[NSString alloc] init];
            
            //tableau des matières du concours
            NSMutableArray *tabMatiere = [[NSMutableArray alloc] init];
            
            //booléen pour savoir si la matière a déjà été rencontré
            BOOL found = NO;
            
            //dictionnaire avec clé le nom de matière et pour valeur un tableau contenant les éléments correspondant à la matière
            NSMutableDictionary *tabSujCor = [[NSMutableDictionary alloc] init];
            
            for (int i=0; i<[json count]; i++)
            {
                //on prend l'entrée et on enregistre la matière
                tempSujCor = [json objectAtIndex:i];
                tempMatiere= [tempSujCor objectForKey:kMatiere];
                
                //on recherche si la matière est dans le tableau
                for (NSString *mat in tabMatiere)
                {
                    if ([mat isEqualToString:tempMatiere])
                    {
                        found = YES;
                        break;
                    }
                }
                
                //si la matière n'a pas été trouvé
                if (!found)
                {
                    //on ajoute la matière dans le tableau
                    [tabMatiere addObject:tempMatiere];
                    
                    //on créé un tableau qui contiendra les éléments XML correspondant à une matière particulière
                    NSMutableArray *tabElement = [[NSMutableArray alloc] init];
                    
                    //on ajoute l'élément XML actuel dans le tableau d'ID
                    [tabElement addObject:tempSujCor];
                    
                    //on ajoute dans le dictionnaire le tableau d'élément avec pour clé le nom de la matière
                    [tabSujCor setObject:tabElement forKey:tempMatiere];
                    
                    found = NO;
                }
                else
                {
                    //la matière existe, dans un tableau d'élément existe pour cette matière, on l'enregistre
                    NSMutableArray *tabElement = [tabSujCor objectForKey:tempMatiere];
                    
                    //on rajoute à ce tableau l'élément actuel
                    [tabElement addObject:tempSujCor];
                    
                    //on remplace l'ancien tableau d'élément par le nouveau dans le dictionnaire
                    [tabSujCor setObject:tabElement forKey:tempMatiere];
                    
                    found = NO;
                }
            }
            
            //Organisation du tableau matière par ordre alphabétique
            NSArray *matiereOrdreAlphabetique = [tabMatiere sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
            for (NSString *mat in matiereOrdreAlphabetique)
            {
                NSMutableArray *temp = [tabSujCor objectForKey:mat];
                [pageStrings addObject:temp];
            }
            
            pageContent_ = [[NSArray alloc] initWithArray:pageStrings];
        }
    }
    
    pageControl_.numberOfPages = [self.pageContent count];
    
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [super viewDidUnload];
}
@end
