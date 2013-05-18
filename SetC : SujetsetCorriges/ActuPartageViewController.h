//
//  ActuPartageViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CommentsViewController.h"

@interface ActuPartageViewController : UIViewController
{
    NSString *urlComments_;
    NSString *idArticle_;
    NSString *titreArticle_;
    IBOutlet UIButton *buttonComments;
    IBOutlet UIButton *buttonFacebook;
    IBOutlet UIButton *buttonTwitter;
    IBOutlet UIButton *buttonMail;
    IBOutlet UIButton *buttonSafari;
}

- (IBAction)boutonFacebookPushed:(id)sender;
- (IBAction)boutonTwitterPushed:(id)sender;

@end
