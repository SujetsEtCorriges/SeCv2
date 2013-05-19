//
//  SujetsCorrigesDetailsViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SujetsCorrigesDetailsViewController.h"

@interface SujetsCorrigesDetailsViewController ()

@end

@implementation SujetsCorrigesDetailsViewController

@synthesize lienSujet = lienSujet_;
@synthesize lienCorrige = lienCorrige_;
@synthesize concours = concours_;
@synthesize annee = annee_;
@synthesize filiere = filiere_;
@synthesize epreuve = epreuve_;
@synthesize corrigePartiel = corrigePartiel_;

@synthesize sujetButton = sujetButton_;
@synthesize corrigeButton = corrigeButton_;
@synthesize bannerConcours = bannerConcours_;
@synthesize headerConcours = headerConcours_;
@synthesize viewDetails = viewDetails_;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.concoursLabel.text = concours_;
    self.filiereLabel.text = filiere_;
    self.epreuveLabel.text = epreuve_;
    self.anneeLabel.text = annee_;
    
    NSLog(@"Sujet : %@", lienSujet_);
    NSLog(@"Corrigé : %@", lienCorrige_);
    NSLog(@"Partiel : %i",corrigePartiel_);
    
    // Custom Back Bouton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"09-arrow-west.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.layer.shadowColor = [UIColor blackColor].CGColor;
    backButton.layer.shadowOpacity = 0.6;
    backButton.layer.shadowRadius = 1;
    backButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    CAGradientLayer *shadowConcours = [CAGradientLayer layer];
    shadowConcours.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:0.0].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.8].CGColor,nil];
    shadowConcours.frame = headerConcours_.frame;
    shadowConcours.startPoint = CGPointMake(0.5, 0);
    shadowConcours.endPoint = CGPointMake(0.5,1);
    [headerConcours_.layer addSublayer:shadowConcours];
    
    // Retouches sur la vue contenant les détails
    viewDetails_.layer.cornerRadius = 5;
    viewDetails_.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
    viewDetails_.layer.borderWidth = 0.5;
    
    // Ajout des lignes dans la vue "détails"
    CALayer *lineBottom = [CALayer layer];
    lineBottom.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    lineBottom.frame = CGRectMake(10, 55, 280, 1);
    [viewDetails_.layer addSublayer:lineBottom];
    
    CALayer *lineBottom2 = [CALayer layer];
    lineBottom2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    lineBottom2.frame = CGRectMake(10, 110, 280, 1);
    [viewDetails_.layer addSublayer:lineBottom2];
    
    if(corrigePartiel_ == 1)
        corrigeButton_.titleLabel.text = @"Corrigé partiel";
    
    if ([lienSujet_ isEqual: [NSNull null]])
        [sujetButton_ setEnabled:NO];
    
    if ([lienCorrige_ isEqual: [NSNull null]])
        [corrigeButton_ setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBannerConcours:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalToViewerSujet"])
    {
        ViewerViewController *destViewController = segue.destinationViewController;
        
        destViewController.type = @"Sujet";
        destViewController.concours = concours_;
        destViewController.filiere = filiere_;
        destViewController.annee = annee_;
        destViewController.epreuve = epreuve_;

        
        destViewController.lienString = lienSujet_;
        destViewController.isLocalFile = NO;
        //destViewController.titleFile = [NSString stringWithFormat:@"Sujet %@",concours_];
        //destViewController.subtitleFile = [NSString stringWithFormat:@"%@ %@ %@",epreuve_,filiere_,annee_];
    }
    else if ([segue.identifier isEqualToString:@"modalToViewerCorrige"])
    {
        ViewerViewController *destViewController = segue.destinationViewController;
        
        destViewController.type = @"Corrigé";
        destViewController.concours = concours_;
        destViewController.filiere = filiere_;
        destViewController.annee = annee_;
        destViewController.epreuve = epreuve_;
        
        destViewController.lienString = lienCorrige_;
        destViewController.isLocalFile = NO;
        //destViewController.titleFile = [NSString stringWithFormat:@"Corrigé %@",concours_];
        //destViewController.subtitleFile = [NSString stringWithFormat:@"%@ %@ %@",epreuve_,filiere_,annee_];
    }
}

@end
