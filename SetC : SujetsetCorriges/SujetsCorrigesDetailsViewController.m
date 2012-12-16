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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.concoursLabel.text = concours_;
    self.filiereLabel.text = filiere_;
    self.epreuveLabel.text = epreuve_;
    self.anneeLabel.text = annee_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
