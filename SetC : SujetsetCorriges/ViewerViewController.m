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

@synthesize type = type_;
@synthesize concours = concours_;
@synthesize epreuve = epreuve_;
@synthesize filiere = filiere_;
@synthesize annee = annee_;

@synthesize lienString = lienString_;
@synthesize titleFile = titleFile_;
@synthesize subtitleFile = subtitleFile_;
@synthesize activityView = activityView_;
@synthesize viewerWebView = viewerWebView_;
@synthesize navBar = navBar_;
@synthesize navItem = navItem_;
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
    
    // Custom Close Bouton
    UIButton *closeButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton2 setImage:[UIImage imageNamed:@"Cancel.png"] forState:UIControlStateNormal];
    [closeButton2 addTarget:self action:@selector(closeViewer:) forControlEvents:UIControlEventTouchUpInside];
    closeButton2.showsTouchWhenHighlighted = YES;
    closeButton2.layer.shadowColor = [UIColor blackColor].CGColor;
    closeButton2.layer.shadowOpacity = 0.6;
    closeButton2.layer.shadowRadius = 1;
    closeButton2.layer.shadowOffset = CGSizeMake(0, 1);
    navItem_.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton2];
    
    // Custom Save Bouton
    UIButton *saveButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [saveButton2 setImage:[UIImage imageNamed:@"265-download.png"] forState:UIControlStateNormal];
    [saveButton2 setImage:[UIImage imageNamed:@"258-checkmark.png"] forState:UIControlStateDisabled];
    [saveButton2 addTarget:self action:@selector(saveFile:) forControlEvents:UIControlEventTouchUpInside];
    saveButton2.showsTouchWhenHighlighted = YES;
    saveButton2.layer.shadowColor = [UIColor blackColor].CGColor;
    saveButton2.layer.shadowOpacity = 0.6;
    saveButton2.layer.shadowRadius = 1;
    saveButton2.layer.shadowOffset = CGSizeMake(0, 1);
    navItem_.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton2];
    
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
        filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %@.pdf", type_, concours_, epreuve_, filiere_, annee_ ]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            [self changeSaveButtonIntoSaved];
        }
    }
    
    titleFile_ = [NSString stringWithFormat:@"%@ %@",type_,concours_];
    subtitleFile_ = [NSString stringWithFormat:@"%@ %@ %@",epreuve_,filiere_,annee_];
    
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
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.shadowColor = [UIColor blackColor];
    navTitleLabel.shadowOffset = CGSizeMake(0, -1);
    navTitleLabel.text = titleFile_;
    
    UILabel *navSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 14)];
    navSubtitleLabel.backgroundColor = [UIColor clearColor];
    navSubtitleLabel.textAlignment = NSTextAlignmentCenter;
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
    
    // Définition des fenêtres pour le mode plein écran
    frameNavBarVisible = navBar_.frame;
    frameNavBarHidden = frameNavBarVisible;
    frameNavBarHidden.origin.y -= (frameNavBarHidden.size.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    frameToolBarVisible = toolBar_.frame;
    frameToolBarHidden = frameToolBarVisible;
    frameToolBarHidden.origin.y += frameToolBarHidden.size.height;
    frameWebViewSmall = viewerWebView_.frame;
    frameWebViewLarge = frameWebViewSmall;
    frameWebViewLarge.origin.y -= (frameNavBarHidden.size.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    frameWebViewLarge.size.height += (frameNavBarHidden.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + frameToolBarHidden.size.height);
    
    // Détection du tap
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:nil];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    //tapGestureRecognizer.delegate = self;
    [viewerWebView_ addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(detectTap)];
    singleFingerTap.numberOfTapsRequired = 1;
    //singleFingerTap.delegate = self;
    [singleFingerTap requireGestureRecognizerToFail: doubleTapGestureRecognizer];
    [viewerWebView_ addGestureRecognizer:singleFingerTap];
    
    
    //activityView_ = [[UIActivityIndicatorView alloc] init];
    //activityView_.hidesWhenStopped = YES;
    
    viewerWebView_.delegate = self;
    viewerWebView_.scrollView.delegate = self;
    
	// Faire une requête sur cette URL
	NSURLRequest *requestObject = [NSURLRequest requestWithURL:urlAddress];

    // Charger la requête dans la UIWebView
	[viewerWebView_ loadRequest:requestObject];
    
    //Custom ToolBar
    [toolBar_ setBackgroundImage:[UIImage imageNamed:@"ToolBarViewer.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
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


#pragma mark - UIWebView Delegate
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [savingHUD show:YES];

    BOOL isDir = NO;
    NSError *errorDirectory;

    //You must check if this directory exist every time
    if (! [[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir] && isDir   == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:&errorDirectory];
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:lienString_]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	[urlConnection start];
}


#pragma mark - NSURLConnection Delegate
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
    NSError *errorData;
    [pdfFile writeToFile:filePath options:NSDataWritingAtomic error:&errorData];
    
    [self changeSaveButtonIntoSaved];
    
    savingHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"258-checkmark.png"]];
	savingHUD.mode = MBProgressHUDModeCustomView;
    savingHUD.labelText = @"Réussi";
	[savingHUD hide:YES afterDelay:2];
    NSLog(@"File saved");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    savingHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"60-x.png"]];
	savingHUD.mode = MBProgressHUDModeCustomView;
    savingHUD.labelText = @"Erreur";
	[savingHUD hide:YES afterDelay:2];
}

- (void)changeSaveButtonIntoSaved
{
    //saveButton_.title = @"Saved";
    //saveButton_.enabled = NO;
    [navItem_.leftBarButtonItem setEnabled:NO];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"Drag");
    if(![activityView_ isAnimating])
    {
        [self hideBars];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"Zoom");
    if(![activityView_ isAnimating])
    {
        [self hideBars];
    }
}

- (void)detectTap
{
    NSLog(@"Tap");
    if(![activityView_ isAnimating])
    {
        if (navBar_.frame.origin.y == frameNavBarHidden.origin.y)
        {
            [self displayBars];
        }
        else
        {
            [self hideBars];
        }
    }
}

- (void)displayBars
{
    [UIView beginAnimations:@"Display Bars" context:nil];
    [UIView setAnimationDuration:0.4];
    
    navBar_.frame = frameNavBarVisible;
    toolBar_.frame = frameToolBarVisible;
    viewerWebView_.frame = frameWebViewSmall;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIView commitAnimations];
}

- (void)hideBars
{
    [UIView beginAnimations:@"Hide Bars" context:nil];
    [UIView setAnimationDuration:0.4];
    
    navBar_.frame = frameNavBarHidden;
    toolBar_.frame = frameToolBarHidden;
    viewerWebView_.frame = frameWebViewLarge;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [UIView commitAnimations];
}

//#pragma mark Gesture recognizer delegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

@end
