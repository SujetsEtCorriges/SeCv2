//
//  ActuPartageViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActuPartageViewController : UIViewController
{
    NSString *urlComments_;
    NSString *idArticle_;
    NSString *titreArticle_;
}

- (IBAction)boutonFacebookPushed:(id)sender;
- (IBAction)boutonTwitterPushed:(id)sender;

@end
