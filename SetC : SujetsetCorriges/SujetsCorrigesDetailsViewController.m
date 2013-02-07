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
    
    if(corrigePartiel_ == 1)
    {
        corrigeButton_.titleLabel.text = @"Corrigé partiel";
    }
    
    if ([lienSujet_ isEqualToString:@""])
    {
        //sujetButton_.titleLabel.text = @"Aucun sujet";
        [sujetButton_ setEnabled:NO];
        
    }
    if ([lienCorrige_ isEqualToString:@""])
    {
        //corrigeButton_ setTitl.titleLabel.text = @"Aucun corrigé";
        [corrigeButton_ setEnabled:NO];
    }
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
@end
