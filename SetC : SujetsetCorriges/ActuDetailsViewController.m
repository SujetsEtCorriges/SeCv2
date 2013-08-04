//
//  ActuDetailsViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "ActuDetailsViewController.h"

#import "ECSlidingViewController.h"
#import "ActuPartageViewController.h"
#import "ActuVariableStore.h"

#define kURL @"http://www.sujetsetcorriges.fr/api/get_post/?id="

@interface ActuDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *titreLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *auteurLabel;

@end

@implementation ActuDetailsViewController


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
    self.title = @"News";
    
    // Initialisation des champs du header
    self.titreLabel.text = _titre;
    self.dateLabel.text = _date;
    self.auteurLabel.text = _auteur;
    
    // Custom Back Bouton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"09-arrow-west.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.layer.shadowColor = [UIColor blackColor].CGColor;
    backButton.layer.shadowOpacity = 0.6;
    backButton.layer.shadowRadius = 1;
    backButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // Custom Partage Bouton
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [shareButton setImage:[UIImage imageNamed:@"Share.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(affichagePartage:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.showsTouchWhenHighlighted = YES;
    shareButton.layer.shadowColor = [UIColor blackColor].CGColor;
    shareButton.layer.shadowOpacity = 0.6;
    shareButton.layer.shadowRadius = 1;
    shareButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    // Ajout de la ligne sous le header
    CALayer *lineBottom = [CALayer layer];
    lineBottom.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
    lineBottom.frame = CGRectMake(10, _infoView.frame.size.height-10, 300, 1);
    [_infoView.layer addSublayer:lineBottom];
    
    // Initialisation de la webview
    [self.webView.scrollView setScrollEnabled:NO];
    [self.webView setDelegate:self];
    [self.webView loadHTMLString:[NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {color:#404040; font-family: \"%@\"; font-size: %@; text-shadow: none 0px 1px 0px;}\n"
                              "img {max-width: 298px; height:auto; margin-left:auto; margin-right:auto; display:block;}\n"
                              "iframe {max-width: 298px; height:auto; margin-left:auto; margin-right:auto; display:block;}\n"
                              "a {color:#0E9CFF; text-decoration: none;}"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@<br></body> \n"
                              "</html>", @"helvetica", [NSNumber numberWithInt:13],self.texte] baseURL:nil];
    
    // On met le background transaparent et on désactive les ombres de la webView
    [self.webView setBackgroundColor: [UIColor clearColor]];
    [self.webView setOpaque:NO];
    for (int i = 0; i < 10; i++)
        [[[[[self.webView subviews] objectAtIndex:0] subviews] objectAtIndex:i] setHidden:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ActuVariableStore *obj=[ActuVariableStore getInstance];
    obj.urlComments = _url;
    obj.idArticle = _idArticle;
    obj.titreArticle = _titre;
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[ActuPartageViewController class]])
        self.slidingViewController.underRightViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"partageSideView"];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorLeftRevealAmount:80.0f];
}


- (IBAction)affichagePartage:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


#pragma mark UIWebViewDelegate methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{		
    float h;
    
    h = webView.bounds.size.height + _infoView.bounds.size.height; // extra 70 pixels for UIButton at bottom and padding.

	// get bottom of text field
	[_scrollView setContentSize:CGSizeMake(320, h)];
}


@end
