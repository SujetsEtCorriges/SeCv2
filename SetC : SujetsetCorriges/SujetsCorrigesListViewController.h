//
//  SujetsCorrigesListViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SujetsCorrigesListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *introLabel_;
    
    NSMutableDictionary *tabSujCorRangeParAnnee_;
    NSArray *tabAnneeOrdre_;
    
    NSArray *tabFiliere_;
}

@property (strong, nonatomic) UIView *introView;
@property (strong, nonatomic) IBOutlet UITableView *tableSuj;
@property (strong, nonatomic) NSMutableArray *listeSujCor;
@property (assign, nonatomic) BOOL intro;
@property (strong, nonatomic) NSString *concours;
@property (strong, nonatomic) NSString *filiere;

@end
