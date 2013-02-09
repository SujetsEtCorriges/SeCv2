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

@synthesize isLocalFile = isLocalFile_;
@synthesize lienString = lienString_;
@synthesize titleFile = titleFile_;
@synthesize subtitleFile = subtitleFile_;
@synthesize activityView = activityView_;
@synthesize viewerWebView = viewerWebView_;
@synthesize navBar = navBar_;
@synthesize closeButton = closeButton_;
@synthesize actionButton = actionButton_;
@synthesize toolBar = toolBar_;
@synthesize goBackButton = goBackButton_;
@synthesize goForwardButton = goForwardButton_;
@synthesize refreshButton = refreshButton_;
@synthesize saveButton = saveButton_;

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
    
    NSURL *urlAddress;
    
    if(isLocalFile_)
    {
        saveButton_.enabled = NO;
        goBackButton_.enabled = NO;
        goForwardButton_.enabled = NO;
        actionButton_.enabled = NO;
        urlAddress = [NSURL fileURLWithPath:lienString_];
        
        [self changeSaveButtonIntoSaved];
    }
    else
    {
        urlAddress = [NSURL URLWithString: lienString_];
        pdfFile = [[NSMutableData alloc] init];
        
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [paths objectAtIndex:0];
        filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@.pdf",titleFile_,subtitleFile_ ]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            [self changeSaveButtonIntoSaved];
        }
    }
    
    savingHUD = [[MBProgressHUD alloc] initWithView:self.view];
    savingHUD.delegate = self;
    savingHUD.mode = MBProgressHUDModeAnnularDeterminate;
    savingHUD.labelText = @"Enregistrement...";
    [self.view addSubview:savingHUD];
    
//    errorHUD = [[MBProgressHUD alloc] initWithView:self.view];
//    errorHUD.delegate = self;
//    errorHUD.mode = MBProgressHUDModeCustomView;
//    errorHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    errorHUD.mode = MBProgressHUDModeCustomView;
//    errorHUD.labelText = @"Fichier déjà enregistré";
//    [self.view addSubview:errorHUD];
    
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
    
    //activityView_ = [[UIActivityIndicatorView alloc] init];
    //activityView_.hidesWhenStopped = YES;
    
    viewerWebView_.delegate = self;
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    [self setActivityView:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //refreshButton_.customView = activityView_;
    [activityView_ startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //refreshButton_ setStyle:UIBarButtonSystemItemRefresh
    [activityView_ stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityView_ stopAnimating];
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

- (IBAction)openInSafari:(id)sender
{
    UIActionSheet *chgtApp = [[UIActionSheet alloc]
                              initWithTitle:@"Ouvrir la page actuelle dans Safari ?"
                              delegate:self
                              cancelButtonTitle:@"Annuler"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
    chgtApp.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [chgtApp showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:viewerWebView_.request.URL];
    }
}

- (IBAction)saveFile:(id)sender
{
    //[NSThread detachNewThreadSelector:@selector(showHUD) toTarget:self withObject:nil];
    
    [savingHUD show:YES];
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentPath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *errorDirectory;
    //NSError *errorData;

    //You must check if this directory exist every time
    if (! [[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir] && isDir   == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:&errorDirectory];
    }
    
    //NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@.pdf",titleFile_,subtitleFile_ ]];
    //webView.request.URL contains current URL of UIWebView, don't forget to set outlet for it
    //NSData *pdfFile = [NSData dataWithContentsOfURL:[NSURL URLWithString:lienString_]];
    //[pdfFile writeToFile:filePath options:NSDataWritingAtomic error:&errorData];
    //NSLog(@"File saved");
    
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:lienString_]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	[urlConnection start];
	//[urlConnection release];

    //pdfFile = [urlConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
//    NSError *errorData;
//    [pdfFile writeToFile:filePath options:NSDataWritingAtomic error:&errorData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [pdfFile setLength:0];
    expectedLength = [response expectedContentLength];
	currentLength = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [pdfFile appendData:data];
    currentLength += [data length];
	savingHUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentPath = [paths objectAtIndex:0];
    //NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@.pdf",titleFile_,subtitleFile_ ]];
    NSError *errorData;
    [pdfFile writeToFile:filePath options:NSDataWritingAtomic error:&errorData];
    
    [self changeSaveButtonIntoSaved];
    
    savingHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	savingHUD.mode = MBProgressHUDModeCustomView;
    savingHUD.labelText = @"Réussi";
	[savingHUD hide:YES afterDelay:2];
    NSLog(@"File saved");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    savingHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	savingHUD.mode = MBProgressHUDModeCustomView;
    savingHUD.labelText = @"Erreur";
	[savingHUD hide:YES afterDelay:2];
}

- (void)changeSaveButtonIntoSaved
{
    saveButton_.title = @"Saved";
    saveButton_.enabled = NO;
}

//- (void)showHUD
//{
//    @autoreleasepool
//    {
//        [savingHUD show:YES];
//    }
//}

@end
