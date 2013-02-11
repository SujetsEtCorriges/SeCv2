//
//  FileCell.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 10/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHSpaceLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sizeLabelHSpaceLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHSpaceRightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;

@end
