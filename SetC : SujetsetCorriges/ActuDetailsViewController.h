//
//  ActuDetailsViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActuDetailsViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *texte;
@property (strong, nonatomic) NSString *titre;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *auteur;
@property (strong, nonatomic) NSString *idArticle;


- (IBAction)affichagePartage:(id)sender;


@end
