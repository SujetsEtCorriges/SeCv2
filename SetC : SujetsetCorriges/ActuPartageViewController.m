//
//  ActuPartageViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "ActuPartageViewController.h"

#import "ActuVariableStore.h"
#import <Social/Social.h>

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToComments"])
    {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *nav = segue.destinationViewController;
        CommentsViewController *destViewController = (CommentsViewController *)[nav topViewController];
        destViewController.url = urlComments_;
        destViewController.idArticle = idArticle_;
    }
}


- (IBAction)boutonFacebookPushed:(id)sender
{
    SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebook addImage:[UIImage imageNamed:@"Icone114.png"]];
    [facebook addURL:[NSURL URLWithString:urlComments_]];
    [facebook setInitialText:titreArticle_];
    [self presentViewController:facebook animated:YES completion:nil];
    
    facebook.completionHandler = ^(SLComposeViewControllerResult result)
    {
        NSString *title = @"Partage Facebook";
        NSString *msg;
        
        if (result == SLComposeViewControllerResultDone)
        {
            msg = @"L'article a été partagé sur Facebook";
            // Show alert to see how things went...
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
            
        // Dismiss the controller
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}


-(IBAction)boutonTwitterPushed:(id)sender
{
    SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitter addImage:[UIImage imageNamed:@"Icone114.png"]];
    [twitter addURL:[NSURL URLWithString:urlComments_]];
    [twitter setInitialText:titreArticle_];
    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(SLComposeViewControllerResult result)
    {
        NSString *title = @"Partage Twitter";
        NSString *msg;
        
        if (result == SLComposeViewControllerResultDone)
        {
            msg = @"Tweet envoyé";
            // Show alert to see how things went...
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
            
        // Dismiss the controller
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

@end
