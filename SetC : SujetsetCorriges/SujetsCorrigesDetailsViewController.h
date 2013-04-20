//
//  SujetsCorrigesDetailsViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewerViewController.h"

@interface SujetsCorrigesDetailsViewController : UIViewController
{
    
}

// Données
@property (strong, nonatomic) NSString *lienSujet;
@property (strong, nonatomic) NSString *lienCorrige;
@property (nonatomic, assign) int corrigePartiel;
@property (strong, nonatomic) NSString *concours;
@property (strong, nonatomic) NSString *annee;
@property (strong, nonatomic) NSString *filiere;
@property (strong, nonatomic) NSString *epreuve;

// UILabel
@property (strong, nonatomic) IBOutlet UILabel *concoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *anneeLabel;
@property (strong, nonatomic) IBOutlet UILabel *filiereLabel;
@property (strong, nonatomic) IBOutlet UILabel *epreuveLabel;

// UIButton
@property (strong, nonatomic) IBOutlet UIButton *sujetButton;
@property (strong, nonatomic) IBOutlet UIButton *corrigeButton;

// UIImage
@property (strong, nonatomic) IBOutlet UIImageView *bannerConcours;
@property (strong, nonatomic) IBOutlet UIImageView *headerConcours;

@end
