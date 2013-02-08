//
//  ViewerViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 07/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "ViewerViewController.h"

@interface ViewerViewController ()

@end

@implementation ViewerViewController

@synthesize lienString = lienString_;
@synthesize titleFile = titleFile_;
@synthesize subtitleFile = subtitleFile_;
@synthesize viewerWebView = viewerWebView_;
@synthesize navBar = navBar_;
@synthesize closeButton = closeButton_;
@synthesize actionButton = actionButton_;
@synthesize toolBar = toolBar_;
@synthesize goBackButton = goBackButton_;
@synthesize goForwardButton = goForwardButton_;
@synthesize refreshButton = refreshButton_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [titleButton_ setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                          //[UIColor colorWithRed:220.0/255.0 green:104.0/255.0 blue:1.0/255.0 alpha:1.0], UITextAttributeTextColor,
//                                          //[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
//                                          //[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
//                                          [UIFont fontWithName:@"Helvetica" size:10.0], UITextAttributeFont,
//                                          nil]
//                                forState:UIControlStateNormal];
    //titleButton_.title = titleFile_;
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 18)];
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.textAlignment = UITextAlignmentCenter;
    navTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.shadowColor = [UIColor blackColor];
    navTitleLabel.shadowOffset = CGSizeMake(0, -1);
    navTitleLabel.text = titleFile_;
    
    UILabel *navSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 14)];
    navSubtitleLabel.backgroundColor = [UIColor clearColor];
    navSubtitleLabel.textAlignment = UITextAlignmentCenter;
    navSubtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    navSubtitleLabel.textColor = [UIColor whiteColor];
    navSubtitleLabel.shadowColor = [UIColor blackColor];
    navSubtitleLabel.shadowOffset = CGSizeMake(0, -1);
    navSubtitleLabel.text = subtitleFile_;
    
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    viewTitle.backgroundColor = [UIColor clearColor];
    
    [viewTitle addSubview:navTitleLabel];
    [viewTitle addSubview:navSubtitleLabel];
    
    [navBar_.topItem setTitleView:viewTitle];
    
    //navBar_.topItem. title = titleFile_;
    
    viewerWebView_.delegate = self;
    NSURL *urlAddress = [NSURL URLWithString: lienString_];
    
	// Faire une requête sur cette URL
	NSURLRequest *requestObject = [NSURLRequest requestWithURL:urlAddress];
    
	// Charger la requête dans la UIWebView
	[viewerWebView_ loadRequest:requestObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setViewerWebView:nil];
    [self setNavBar:nil];
    [self setCloseButton:nil];
    [self setActionButton:nil];
    [self setToolBar:nil];
    [self setGoBackButton:nil];
    [self setGoForwardButton:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
}
- (IBAction)closeViewer:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)goBack:(id)sender
{
    [viewerWebView_ goBack];
}

- (IBAction)goForward:(id)sender
{
    [viewerWebView_ goForward];
}

- (IBAction)refresh:(id)sender
{
    [viewerWebView_ reload];
}

@end
