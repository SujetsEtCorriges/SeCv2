//
//  FileManagerViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 09/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewerViewController.h"
#import "FileCell.h"

@interface FileManagerViewController : UITableViewController
{
    NSMutableArray * arrayDocuments;
    //NSMutableArray *arraySize;
    
    NSMutableDictionary *dictionaryDocuments;
    NSMutableDictionary *dictionaryCurrentDocument;
    NSMutableDictionary *dictionaryCurrentConcours;
    
    NSMutableArray *arrayCurrentConcours;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)enterEditMode:(id)sender;

@end
