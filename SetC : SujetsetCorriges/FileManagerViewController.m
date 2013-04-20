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
    
//    arraySize = [[NSMutableArray alloc] init];
//    for (int i=0; i<[arrayDocuments count]; i+=1)
//    {
//        NSError *AttributesError;
//        NSString *currentDocumentPath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:i] ];
//        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:currentDocumentPath error:&AttributesError];
//        NSNumber *FileSizeNumber = [FileAttributes objectForKey:NSFileSize];
//        long FileSize = [FileSizeNumber longValue];
//        FileSizeNumber = [NSNumber numberWithLong:FileSize];
//        
//        //NSLog(@"File: %@, Size: %ld", URL, FileSize);
//        [arraySize addObject:FileSizeNumber];
//    }
    
    NSLog(@"Nombre de fichiers : %i",[arrayDocuments count]);
//    for (int i=0; i<[arrayDocuments count]; i+=1) {
//        NSLog(@"éléments arrayDocuments: %@", [arrayDocuments objectAtIndex:i]);
//    }
    
    
    
    dictionaryDocuments = [[NSMutableDictionary alloc] init];
    dictionaryCurrentDocument = [[NSMutableDictionary alloc] init];
    dictionaryCurrentConcours = [[NSMutableDictionary alloc] init];
    
    arrayCurrentConcours = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[arrayDocuments count]; i+=1)
    {
        [dictionaryCurrentDocument removeAllObjects];
        NSError *AttributesError;
        NSString *currentDocumentPath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:i]];
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:currentDocumentPath error:&AttributesError];
        NSNumber *FileSizeNumber = [FileAttributes objectForKey:NSFileSize];
        long FileSize = [FileSizeNumber longValue];
        FileSizeNumber = [NSNumber numberWithLong:FileSize];
        
        //NSLog(@"File: %@, Size: %ld", URL, FileSize);
        //[arraySize addObject:FileSizeNumber];
        
        NSArray *arrayTitleFile = [[[arrayDocuments objectAtIndex:i] stringByDeletingPathExtension] componentsSeparatedByString:@" - "];
        NSString *currentType = [arrayTitleFile objectAtIndex:0];
        NSString *currentConcours = [arrayTitleFile objectAtIndex:1];
        NSString *currentEpreuve = [arrayTitleFile objectAtIndex:2];
        NSString *currentFiliere = [arrayTitleFile objectAtIndex:3];
        NSString *currentAnnee = [arrayTitleFile objectAtIndex:4];
        
        [dictionaryCurrentDocument setObject:[arrayDocuments objectAtIndex:i] forKey:@"name"];
        [dictionaryCurrentDocument setObject:currentDocumentPath forKey:@"path"];
        [dictionaryCurrentDocument setObject:currentType forKey:@"type"];
        [dictionaryCurrentDocument setObject:currentConcours forKey:@"concours"];
        [dictionaryCurrentDocument setObject:currentEpreuve forKey:@"epreuve"];
        [dictionaryCurrentDocument setObject:currentFiliere forKey:@"filiere"];
        [dictionaryCurrentDocument setObject:currentAnnee forKey:@"annee"];
        [dictionaryCurrentDocument setObject:FileSizeNumber forKey:@"size"];
        
//        for (NSString *key in dictionaryCurrentDocument) {
//            NSString *chaine = [dictionaryCurrentDocument objectForKey:key];
//            NSLog(@"éléments %i : %@ = %@", i+1,key,chaine);
//        }
        
        //[dictionaryDocuments setObject:[dictionaryCurrentDocument copy] forKey:[arrayDocuments objectAtIndex:i]];
        
        
        if([dictionaryDocuments objectForKey:currentConcours] == nil)
        {
            NSLog(@"currentconcours = nil");
            //[dictionaryCurrentConcours setObject:[dictionaryCurrentDocument copy] forKey:[arrayDocuments objectAtIndex:i]];
            //[dictionaryDocuments setObject:[dictionaryCurrentConcours copy] forKey:currentConcours];
            [arrayCurrentConcours removeAllObjects];
            [arrayCurrentConcours addObject:[dictionaryCurrentDocument copy]];
            //[dictionaryDocuments setObject:[arrayCurrentConcours copy] forKey:currentConcours];
            [dictionaryDocuments setObject:[[NSMutableArray alloc] initWithArray:arrayCurrentConcours] forKey:currentConcours];
        }
        else
        {
            NSLog(@"currentconcours exists");
            //[[dictionaryDocuments objectForKey:currentConcours] setObject:[dictionaryCurrentDocument copy] forKey:[arrayDocuments objectAtIndex:i]];
            
            [[dictionaryDocuments objectForKey:currentConcours] addObject:[dictionaryCurrentDocument copy]];
        }
    }
    
    //arrayConcours = [[NSMutableArray alloc] initWithArray:[dictionaryDocuments allKeys]];
//    NSLog(@"Nb fichiers dans dico : %i",[dictionaryDocuments count]);
//    NSLog(@"All keys : %@",[dictionaryDocuments allKeys]);

    
//    for (NSString *key in dictionaryDocuments) {
//        double number = [dictionaryDocuments objectForKey:key];
//        NSLog(@"fichiers: %f", number);
//    }
    
    [self.tableView reloadData];
    
    [editButton_ setEnabled:([arrayDocuments count] != 0)];
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
    NSLog(@"Nb sections : %i",[[dictionaryDocuments allKeys] count]);
    return [[dictionaryDocuments allKeys] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[dictionaryDocuments allKeys] objectAtIndex:section];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float heightSection = 25;
    UIView *viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, heightSection)];
    //viewSection.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.7];
    viewSection.backgroundColor = [UIColor clearColor];
    viewSection.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
//    CAGradientLayer *shadowSection = [CAGradientLayer layer];
//    shadowSection.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.75 alpha:0.7].CGColor,(id)[UIColor colorWithWhite:0.85 alpha:0.7].CGColor,nil];
//    //shadowSection.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:14/255.0f green:156/255.0f blue:255/255.0f alpha:0.7].CGColor,(id)[UIColor colorWithRed:77/255.0f green:182/255.0f blue:255/255.0f alpha:0.7].CGColor,nil];
//    CGRect frameShadow = viewSection.frame;
//    //frameShadow.size.height = 25;
//    shadowSection.frame = frameShadow;
//    shadowSection.startPoint = CGPointMake(0.5, 0);
//    shadowSection.endPoint = CGPointMake(0.5,1);
//    [viewSection.layer addSublayer:shadowSection];
    
    UIImageView *iconConcours = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionCCP.png"]];
    iconConcours.alpha = 0.7;
    [viewSection addSubview:iconConcours];
    
    CALayer *lineTop = [CALayer layer];
    lineTop.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    lineTop.frame = CGRectMake(0, 0, 320, 1);
    //[viewSection.layer addSublayer:lineTop];
    
    CALayer *lineBottom = [CALayer layer];
    lineBottom.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
    lineBottom.frame = CGRectMake(0, heightSection-1, 320, 1);
    [viewSection.layer addSublayer:lineBottom];
    
    UILabel *labelSection = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 300, heightSection)];
    labelSection.backgroundColor = [UIColor clearColor];
    labelSection.font = [UIFont fontWithName:@"Helvetica" size:14];
    //labelSection.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    labelSection.textColor = [UIColor colorWithWhite:0.45 alpha:1];
    //labelSection.shadowColor = [UIColor blackColor];
    labelSection.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    labelSection.shadowOffset = CGSizeMake(0, 1);
    labelSection.text = [[dictionaryDocuments allKeys] objectAtIndex:section];
    [viewSection addSubview:labelSection];
    
    return viewSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Nb rows : %i",[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:section]] count]);
    return [[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [arrayDocuments objectAtIndex:[indexPath row]];
    //float FileSize = [[arraySize objectAtIndex:[indexPath row]] floatValue];
    
    //NSLog(@"éléments arrayDocuments dans cellule: %@", [arrayDocuments objectAtIndex:[indexPath row]]);
    
    //NSString *concoursForRow = [[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]];
    //NSLog(@"Concours : %@",concoursForRow);
    
    NSDictionary *dictionaryCurrentCell = [[NSDictionary alloc] initWithDictionary:[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]]];
    
    NSString *type = [dictionaryCurrentCell objectForKey:@"type"];
    //NSString *concours = [dictionaryCurrentCell objectForKey:@"concours"];
    NSString *epreuve = [dictionaryCurrentCell objectForKey:@"epreuve"];
    NSString *filiere = [dictionaryCurrentCell objectForKey:@"filiere"];
    NSString *annee = [dictionaryCurrentCell objectForKey:@"annee"];
    NSString *size = [dictionaryCurrentCell objectForKey:@"size"];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", type, epreuve, filiere, annee];
    float FileSize = [size floatValue];
    
    //cell.textLabel.text = [[dictionaryDocuments objectForKey:[arrayDocuments objectAtIndex:[indexPath row]]] objectForKey:@"name"];
    //float FileSize = [[[dictionaryDocuments objectForKey:[arrayDocuments objectAtIndex:[indexPath row]]] objectForKey:@"size"] floatValue];
    
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
    cell.sizeLabel.text = fileSizeString;
    
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        NSError *deleteError;
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *documentPath = [paths objectAtIndex:0];
        //NSString *documentToDeletePath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:[indexPath row]]];
        //NSString *documentToDeletePath = [[dictionaryDocuments objectForKey:[arrayDocuments objectAtIndex:[indexPath row]]] objectForKey:@"path"];
        NSDictionary *dictionaryCellToDelete = [[NSDictionary alloc] initWithDictionary:[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]]];
        NSString *documentToDeletePath = [dictionaryCellToDelete objectForKey:@"path"];
        
        [[NSFileManager defaultManager] removeItemAtPath:documentToDeletePath error:&deleteError];
        [[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] removeObjectAtIndex:[indexPath row]];
        if([[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] count] == 0)
        {
            NSLog(@"Concours vide");
            [dictionaryDocuments removeObjectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
        //[arrayDocuments removeObjectAtIndex:[indexPath row]];
        //[arraySize removeObjectAtIndex:[indexPath row]];
        
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
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
    
    FileCell *cell = (FileCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEditing] == YES)
    {
        //[cell setSelected:![cell isSelected] animated:YES];
//        if ([cell isSelected])
//        {
//            [cell setSelected:NO animated:NO];
//        }
//        else
//        {
//            [cell setSelected:YES animated:NO];
//        }
    }
    else
    {
        // Do Something else.
        [self performSegueWithIdentifier: @"modalToViewerFromFile" sender: self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalToViewerFromFile"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSString *filePath = [[dictionaryDocuments objectForKey:[arrayDocuments objectAtIndex:[indexPath row]]] objectForKey:@"path"];
        NSDictionary *dictionarySelectedCell = [[NSDictionary alloc] initWithDictionary:[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]]];
        NSString *filePath = [dictionarySelectedCell objectForKey:@"path"];
        
        
        //NSArray *arrayTitleFile = [[[arrayDocuments objectAtIndex:[indexPath row]] stringByDeletingPathExtension] componentsSeparatedByString:@" - "];
        NSArray *arrayTitleFile = [[[dictionarySelectedCell objectForKey:@"name"] stringByDeletingPathExtension] componentsSeparatedByString:@" - "];
        
        ViewerViewController *destViewController = segue.destinationViewController;
        
        destViewController.type = [arrayTitleFile objectAtIndex:0];
        destViewController.concours = [arrayTitleFile objectAtIndex:1];
        destViewController.epreuve = [arrayTitleFile objectAtIndex:2];
        destViewController.filiere = [arrayTitleFile objectAtIndex:3];
        destViewController.annee = [arrayTitleFile objectAtIndex:4];
        
        destViewController.isLocalFile = YES;
        destViewController.lienString = filePath;
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
        [editButton_ setStyle:UIBarButtonItemStyleBordered];
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
    //NSError *deleteError;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentPath = [paths objectAtIndex:0];
    
    //NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
    //NSMutableArray *documentToDeleteArray = [[NSMutableArray alloc] init];
    //NSMutableIndexSet *indexSetToDelete = [NSMutableIndexSet indexSet];
    
//    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
//        NSIndexPath *p = [NSIndexPath indexPathForRow:i inSection:0];
//        
//        if ([[self.tableView cellForRowAtIndexPath:p] isSelected])
//        {
//            [cellIndicesToBeDeleted addObject:p];
//            
//            //NSString *documentToDeletePath = [documentPath stringByAppendingPathComponent:[arrayDocuments objectAtIndex:i] ];
//            NSString *documentToDeletePath = [[dictionaryDocuments objectForKey:[arrayDocuments objectAtIndex:i]] objectForKey:@"path"];
//            
//            [[NSFileManager defaultManager] removeItemAtPath:documentToDeletePath error:&deleteError];
//            //[dictionaryDocuments removeObjectForKey:[arrayDocuments objectAtIndex:i]];
//            //[arrayDocuments removeObjectAtIndex:i];
//            //[arraySize removeObjectAtIndex:i];
//            
//            [documentToDeleteArray addObject:[arrayDocuments objectAtIndex:i]];
//            [indexSetToDelete addIndex:i];
//        }
//    }
    
//    NSArray *arraySelectedPaths = [self.tableView indexPathsForSelectedRows];
//    
//    for (int i=0; i < [arraySelectedPaths count]; i+=1)
//    {
//        NSIndexPath *indexPath = [arraySelectedPaths objectAtIndex:i];
//        NSError *deleteError;
//        NSDictionary *dictionaryCellToDelete = [[NSDictionary alloc] initWithDictionary:[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]]];
//        NSString *documentToDeletePath = [dictionaryCellToDelete objectForKey:@"path"];
//        
//        [[NSFileManager defaultManager] removeItemAtPath:documentToDeletePath error:&deleteError];
//        
//        [[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] removeObjectAtIndex:[indexPath row]];
//        if([[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] count] == 0)
//        {
//            NSLog(@"Concours vide");
//            [dictionaryDocuments removeObjectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]];
//            //[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        else
//        {
//            //[arrayDocuments removeObjectAtIndex:[indexPath row]];
//            //[arraySize removeObjectAtIndex:[indexPath row]];
//            
//            //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//    }
    
    NSMutableArray *arrayPathsToDelete = [[NSMutableArray alloc] init];
    NSMutableArray *arraySectionsToDelete = [[NSMutableArray alloc] init];
    NSMutableIndexSet *currentIndexSetToDelete = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *indexSetSectionsToDelete = [NSMutableIndexSet indexSet];
    
    for (int section=0; section < [self.tableView numberOfSections]; section+=1)
    {
        //[arrayPathsToDelete removeAllObjects];
        [currentIndexSetToDelete removeAllIndexes];
        
        for (int row=0; row < [self.tableView numberOfRowsInSection:section]; row+=1)
        {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if ([[self.tableView cellForRowAtIndexPath:currentIndexPath] isSelected])
            {
                NSError *deleteError;
                NSDictionary *dictionaryCellToDelete = [[NSDictionary alloc] initWithDictionary:[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[currentIndexPath section]]] objectAtIndex:[currentIndexPath row]]];
                NSString *documentToDeletePath = [dictionaryCellToDelete objectForKey:@"path"];
                
                [[NSFileManager defaultManager] removeItemAtPath:documentToDeletePath error:&deleteError];
                
                [arrayPathsToDelete addObject:currentIndexPath];
                [currentIndexSetToDelete addIndex:[currentIndexPath row]];
                
                //[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:[indexPath section]]] removeObjectAtIndex:[indexPath row]];
                
            }
        }
        
        [[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:section]] removeObjectsAtIndexes:currentIndexSetToDelete];
        NSLog(@"Nb fichiers : %i",[[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:section]] count]);
        
//        if([[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:section]] count] == 0)
//        {
//            NSLog(@"Concours vide");
//
//            [arraySectionsToDelete addObject:[[dictionaryDocuments allKeys] objectAtIndex:section]];
//            [indexSetSectionsToDelete addIndex:section];
//            
//            //[tableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        else
//        {
//            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
    }
    
    [self.tableView deleteRowsAtIndexPaths:arrayPathsToDelete
                          withRowAnimation:UITableViewRowAnimationFade];
    
    for (int section=0; section < [self.tableView numberOfSections]; section+=1)
    {
        if([[dictionaryDocuments objectForKey:[[dictionaryDocuments allKeys] objectAtIndex:section]] count] == 0)
        {
            NSLog(@"Concours vide");
            
            [arraySectionsToDelete addObject:[[dictionaryDocuments allKeys] objectAtIndex:section]];
            [indexSetSectionsToDelete addIndex:section];
            
            //[tableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [dictionaryDocuments removeObjectsForKeys:arraySectionsToDelete];
    
    [self.tableView deleteSections:indexSetSectionsToDelete withRowAnimation:UITableViewRowAnimationFade];
    
    [self enterEditMode:nil];
}

- (void)exitEditingMode
{
    [self.tableView setEditing:NO animated:YES];
}

@end
