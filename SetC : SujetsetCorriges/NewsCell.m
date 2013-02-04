//
//  NewsCell.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 04/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.titleLabel.shadowColor = selected ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
    self.dateLabel.shadowColor = selected ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
}

@end
