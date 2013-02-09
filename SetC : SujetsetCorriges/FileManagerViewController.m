//
//  FileManagerViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 09/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "FileManagerViewController.h"

@interface FileManagerViewController ()

@end

@implementation FileManagerViewController

@synthesize editButton = editButton_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //[self loadData];
}

- (void)loadData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    //You must check if this directory exist every time
    if (! [[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir] && isDir   == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    arrayDocuments = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:&error]];
    
    arraySize = [[NSMutableArray alloc] init];
    for (int i=0; i<[arrayDocuments count]; i+=1)
    {
        NSError *AttributesError;
        NSString *currentDocumentPath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:i] ];
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:currentDocumentPath error:&AttributesError];
        NSNumber *FileSizeNumber = [FileAttributes objectForKey:NSFileSize];
        long FileSize = [FileSizeNumber longValue];
        FileSizeNumber = [NSNumber numberWithLong:FileSize];
        
        //NSLog(@"File: %@, Size: %ld", URL, FileSize);
        [arraySize addObject:FileSizeNumber];
    }
    
    NSLog(@"Nombre de fichiers : %i",[arrayDocuments count]);
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayDocuments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [arrayDocuments objectAtIndex:[indexPath row]];
    float FileSize = [[arraySize objectAtIndex:[indexPath row]] floatValue];
    NSString *fileSizeString;
    if (FileSize < 1024)
    {
        fileSizeString = [NSString stringWithFormat:@"%f octets",FileSize];
    }
    else if (FileSize < 1024*1024)
    {
        fileSizeString = [NSString stringWithFormat:@"%@ Ko",[NSString stringWithFormat:@"%.02f", FileSize/1024]];
    }
    else
    {
        fileSizeString = [NSString stringWithFormat:@"%@ Mo",[NSString stringWithFormat:@"%.02f", (FileSize/1024)/1024]];
    }
    cell.detailTextLabel.text = fileSizeString;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSError *deleteError;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        NSString *documentToDeletePath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:[indexPath row]] ];
        [[NSFileManager defaultManager] removeItemAtPath:documentToDeletePath error:&deleteError];
        [arrayDocuments removeObjectAtIndex:[indexPath row]];
        [arraySize removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //[self performSegueWithIdentifier: @"modalToViewerFromFile" sender: self];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEditing] == YES)
    {
        
    }
    else {
        // Do Something else.
        [self performSegueWithIdentifier: @"modalToViewerFromFile" sender: self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalToViewerFromFile"])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *filePath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:[indexPath row]]];
        
        NSArray *arrayTitleFile = [[[arrayDocuments objectAtIndex:[indexPath row]] stringByDeletingPathExtension] componentsSeparatedByString:@" - "];
        NSString *titleFile = [arrayTitleFile objectAtIndex:0];
        NSString *subtitleFile = [arrayTitleFile objectAtIndex:1];
        
        ViewerViewController *destViewController = segue.destinationViewController;
        destViewController.isLocalFile = YES;
        destViewController.lienString = filePath;
        //destViewController.titleFile = @"TEST";
        destViewController.titleFile = titleFile;
        destViewController.subtitleFile = subtitleFile;
    }
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [super viewDidUnload];
}
- (IBAction)enterEditMode:(id)sender
{
    if ([self.tableView isEditing])
    {
        [self.tableView setAllowsMultipleSelectionDuringEditing:NO];
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        [editButton_ setTitle:@"Modifier"];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        [self.tableView setAllowsMultipleSelectionDuringEditing:YES];
        [editButton_ setTitle:@"Annuler"];
        [editButton_ setStyle:UIBarButtonItemStyleDone];
        
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Supprimer" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteDocuments)];
        deleteButton.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem = deleteButton;
        
        // Turn on edit mode
        
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)deleteDocuments
{
    NSError *deleteError;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        NSIndexPath *p = [NSIndexPath indexPathForRow:i inSection:0];
        if ([[self.tableView cellForRowAtIndexPath:p] isSelected])
        {
            [cellIndicesToBeDeleted addObject:p];
            
            NSString *documentToDeletePath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:i] ];
            [[NSFileManager defaultManager] removeItemAtPath:documentToDeletePath error:&deleteError];
            [arrayDocuments removeObjectAtIndex:i];
            [arraySize removeObjectAtIndex:i];
        }
    }
    
    [self.tableView deleteRowsAtIndexPaths:cellIndicesToBeDeleted
                     withRowAnimation:UITableViewRowAnimationLeft];
    [self enterEditMode:nil];
}

- (void)exitEditingMode
{
    [self.tableView setEditing:NO animated:YES];
}

@end
