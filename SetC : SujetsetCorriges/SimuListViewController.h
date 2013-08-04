//
//  SimuListViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGEView.h"
#import "BacView.h"

@interface SimuListViewController : UIViewController <UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, CPGEViewDelegate>
{
    NSMutableArray *itemArray_;

    
    NSMutableArray *filiereArray_;

    
    IBOutlet UIScrollView *scrollViewConcours_;
    IBOutlet UIBarButtonItem *startButton;
}

- (IBAction)startButtonPushed:(id)sender;

@end
