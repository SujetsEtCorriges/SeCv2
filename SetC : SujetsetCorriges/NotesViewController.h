//
//  NotesViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Hedi Mestiri on 04/08/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (void)concoursCPGE:(NSString*)concours filiere:(NSString*)filiere redoublant:(BOOL)redoublant;

@end
