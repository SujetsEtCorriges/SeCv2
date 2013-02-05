//
//  EpreuveCell.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 05/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "EpreuveCell.h"

@implementation EpreuveCell

@synthesize epreuveLabel;

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

    epreuveLabel.shadowColor = selected ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setSelected:highlighted animated:animated];
    
    epreuveLabel.shadowColor = highlighted ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
    // Configure the view for the selected state
}

@end
