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
    
    int heightView = self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height;
    NSLog(@"height : %i",heightView);
    
    CALayer *lineTop = [CALayer layer];
    lineTop.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1].CGColor;
    lineTop.frame = CGRectMake(0, heightView/5, 320, 1);
    [self.view.layer addSublayer:lineTop];
    
    CALayer *lineBottom = [CALayer layer];
    lineBottom.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    lineBottom.frame = CGRectMake(0, lineTop.frame.origin.y+1, 320, 1);
    [self.view.layer addSublayer:lineBottom];
    
    CALayer *lineTop2 = [CALayer layer];
    lineTop2.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1].CGColor;
    lineTop2.frame = CGRectMake(0, 2*heightView/5, 320, 1);
    [self.view.layer addSublayer:lineTop2];
    
    CALayer *lineBottom2 = [CALayer layer];
    lineBottom2.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    lineBottom2.frame = CGRectMake(0, lineTop2.frame.origin.y+1, 320, 1);
    [self.view.layer addSublayer:lineBottom2];
    
    CALayer *lineTop3 = [CALayer layer];
    lineTop3.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1].CGColor;
    lineTop3.frame = CGRectMake(0, 3*heightView/5, 320, 1);
    [self.view.layer addSublayer:lineTop3];
    
    CALayer *lineBottom3 = [CALayer layer];
    lineBottom3.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    lineBottom3.frame = CGRectMake(0, lineTop3.frame.origin.y+1, 320, 1);
    [self.view.layer addSublayer:lineBottom3];
    
    CALayer *lineTop4 = [CALayer layer];
    lineTop4.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1].CGColor;
    lineTop4.frame = CGRectMake(0, 4*heightView/5, 320, 1);
    [self.view.layer addSublayer:lineTop4];
    
    CALayer *lineBottom4 = [CALayer layer];
    lineBottom4.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    lineBottom4.frame = CGRectMake(0, lineTop4.frame.origin.y+1, 320, 1);
    [self.view.layer addSublayer:lineBottom4];
    
    //Ombres sur les boutons
    buttonComments.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonComments.layer.shadowOpacity = 0.6;
    buttonComments.layer.shadowRadius = 1;
    buttonComments.layer.shadowOffset = CGSizeMake(0, 1);
    buttonFacebook.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonFacebook.layer.shadowOpacity = 0.6;
    buttonFacebook.layer.shadowRadius = 1;
    buttonFacebook.layer.shadowOffset = CGSizeMake(0, 1);
    buttonTwitter.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonTwitter.layer.shadowOpacity = 0.6;
    buttonTwitter.layer.shadowRadius = 1;
    buttonTwitter.layer.shadowOffset = CGSizeMake(0, 1);
    buttonMail.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonMail.layer.shadowOpacity = 0.6;
    buttonMail.layer.shadowRadius = 1;
    buttonMail.layer.shadowOffset = CGSizeMake(0, 1);
    buttonSafari.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonSafari.layer.shadowOpacity = 0.6;
    buttonSafari.layer.shadowRadius = 1;
    buttonSafari.layer.shadowOffset = CGSizeMake(0, 1);
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
