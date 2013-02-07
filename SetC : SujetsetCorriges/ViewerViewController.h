//
//  ViewerViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 07/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewerViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *lienString;
@property (strong, nonatomic) IBOutlet UIWebView *viewerWebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
- (IBAction)closeViewer:(id)sender;

@end
