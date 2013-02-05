//
//  NewsCell.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 04/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *nbcommentsLabel;

@end
