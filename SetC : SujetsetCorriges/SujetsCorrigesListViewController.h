//
//  SujetsCorrigesListViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EpreuveCell.h"

//sujets et corriges
#define kItem @"item"
#define kMatiere @"matiere"
#define kAnnee @"annee"
#define kEpreuve @"epreuve"
#define kSujet @"sujet"
#define kCorrige @"corrige"
#define kCorrigePartiel @"corrigePartiel"
#define kNom @"nom"

@interface SujetsCorrigesListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *introLabel_;
    
    NSMutableDictionary *tabSujCorRangeParAnnee_;
    NSArray *tabAnneeOrdre_;
    
    NSArray *tabFiliere_;
    
    NSString *concours_;
    NSString *filiere_;
    
}

@property (strong, nonatomic) UIView *introView;
@property (strong, nonatomic) IBOutlet UITableView *tableSuj;
@property (strong, nonatomic) NSMutableArray *listeSujCor;

@end
