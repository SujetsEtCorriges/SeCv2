//
//  ActuPartageViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "ActuPartageViewController.h"

#import "ActuVariableStore.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ActuPartageViewController ()

@end

@implementation ActuPartageViewController

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
    
    ActuVariableStore *obj=[ActuVariableStore getInstance];
    urlComments_ = obj.urlComments;
    idArticle_ = obj.idArticle;
    titreArticle_ = obj.titreArticle;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)boutonFacebookPushed:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        
    }
    else
    {
        SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebook addImage:[UIImage imageNamed:@"Icone117.png"]];
        [facebook addURL:[NSURL URLWithString:urlComments_]];
        [facebook setInitialText:titreArticle_];
        [self presentModalViewController:facebook animated:YES];
        
        facebook.completionHandler = ^(SLComposeViewControllerResult result)
        {
            NSString *title = @"Partage Facebook";
            NSString *msg;
            
            if (result == SLComposeViewControllerResultCancelled)
                msg = @"Annulation du partage sur Facebook";
            else if (result == SLComposeViewControllerResultDone)
                msg = @"L'article a été partagé sur Facebook";
            
            // Show alert to see how things went...
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            // Dismiss the controller
            [self dismissModalViewControllerAnimated:YES];
        };
    }
}


-(IBAction)boutonTwitterPushed:(id)sender
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter addImage:[UIImage imageNamed:@"Icone117.png"]];
    [twitter addURL:[NSURL URLWithString:urlComments_]];
    [twitter setInitialText:titreArticle_];
    [self presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
    {
        NSString *title = @"Partage Twitter";
        NSString *msg;
        
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"L'envoi du tweet a été annulé";
        else if (result == TWTweetComposeViewControllerResultDone)
            msg = @"Tweet envoyé";
        
        // Show alert to see how things went...
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
    };
    
    
}

@end
