//
//  ViewerViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 07/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewerViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString *lienString;
@property (strong, nonatomic) NSString *titleFile;
@property (strong, nonatomic) NSString *subtitleFile;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIWebView *viewerWebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goForwardButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


- (IBAction)closeViewer:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)openInSafari:(id)sender;

@end
