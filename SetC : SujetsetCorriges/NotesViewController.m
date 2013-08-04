//
//  NotesViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Hedi Mestiri on 04/08/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "NotesViewController.h"

#define PATH_MATIERES [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",_concours]]

@interface NotesViewController ()
{
    UITextField *activeField;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *concours;
@property (strong, nonatomic) NSString *filiere;
@property (assign, nonatomic) BOOL redoublant;
@property (strong, nonatomic) NSMutableArray *matieres;

@end

@implementation NotesViewController

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
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)concoursCPGE:(NSString *)concours filiere:(NSString *)filiere redoublant:(BOOL)redoublant
{
    _concours = concours;
    _filiere = filiere;
    _redoublant = redoublant;

    NSDictionary *jsonConcours = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:PATH_MATIERES] options:0 error:nil];
    _matieres = [[jsonConcours objectForKey:_filiere] objectForKey:@"matieres"];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return [_matieres count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"headerNotesCell"];
        
        UIImageView *concoursLogo = (UIImageView*)[cell viewWithTag:100];
        [concoursLogo setImage:[UIImage imageNamed:_concours]];
        
        UILabel *labelConcours = (UILabel*)[cell viewWithTag:101];
        [labelConcours setText:_concours];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell"];
        
        UILabel *matiereLabel = (UILabel*)[cell viewWithTag:100];
        [matiereLabel setText:[[_matieres objectAtIndex:indexPath.row] objectForKey:@"nom"]];
        
        UITextField *textField = (UITextField*)[cell viewWithTag:101];
        [textField setDelegate:self];
    }
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 80;
    else
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [activeField resignFirstResponder];
}


#pragma mark - Keyboard displaying/hiding notification
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - kbSize.height);
        [_tableView setContentOffset:scrollPoint animated:YES];
    }    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[textField text] floatValue] < 0 || [[textField text] floatValue] > 20)
        [textField setText:@""];
    
    activeField = nil;
}

@end
