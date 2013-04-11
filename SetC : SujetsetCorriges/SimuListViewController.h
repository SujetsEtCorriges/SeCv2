//
//  SimuListViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimuListViewController : UIViewController <UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>
{
    NSMutableArray *itemArray_;
    NSArray *concoursTab_;
    
    NSMutableArray *filiereArray_;
    NSArray *filiereBacTab_;
    NSArray *filiereCPGETab_;
    
    IBOutlet UIScrollView *scrollViewConcours_;
    IBOutlet UIScrollView *scrollViewFiliere_;
    IBOutlet UIBarButtonItem *startButton;
}
- (IBAction)startButtonPushed:(id)sender;

@end
