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
@synthesize viewerWebView = viewerWebView_;
@synthesize closeButton = closeButton_;

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
    [self setCloseButton:nil];
    [super viewDidUnload];
}
- (IBAction)closeViewer:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
