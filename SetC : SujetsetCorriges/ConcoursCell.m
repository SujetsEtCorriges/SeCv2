//
//  ConcoursCell.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 05/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "ConcoursCell.h"

@implementation ConcoursCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
    
    // Your code goes here!
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    line.frame = CGRectMake(0, 0, 320, 1);
    
    [self.layer addSublayer:line];
    
    return self;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//        CALayer *line = [CALayer layer];
//        line.backgroundColor = [UIColor blackColor].CGColor;
//        line.frame = CGRectMake(0, 40, 320, 1);
//        
//        [self.layer addSublayer:line];
//    }
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
