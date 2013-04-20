//
//  CommentsViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 17/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UITableViewController


@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *idArticle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *writeButton;

-(IBAction)closeComments:(id)sender;
-(IBAction)writeComment:(id)sender;

@end
