//
//  FileCell.m
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 10/02/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

@synthesize nameLabel = nameLabel_;
@synthesize sizeLabel = sizeLabel_;
@synthesize nameLabelHSpaceLeftConstraint = nameLabelHSpaceLeftConstraint_;
@synthesize nameLabelHSpaceRightConstraint = nameLabelHSpaceRightConstraint_;
@synthesize sizeLabelHSpaceLeftConstraint = sizeLabelHSpaceLeftConstraint_;

- (void)awakeFromNib {
    // Your code goes here!
    [self removeConstraint:nameLabelHSpaceLeftConstraint_];
    [self removeConstraint:nameLabelHSpaceRightConstraint_];
    [self removeConstraint:sizeLabelHSpaceLeftConstraint_];
    
    NSDictionary *nameLabelViewDictionary = NSDictionaryOfVariableBindings(nameLabel_);
    NSDictionary *sizeLabelViewDictionary = NSDictionaryOfVariableBindings(sizeLabel_);
    
    // Create the new constraint
    NSArray *nameLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[nameLabel_]-15-|" options:0 metrics:nil views:nameLabelViewDictionary];
    NSArray *sizeLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[sizeLabel_]" options:0 metrics:nil views:sizeLabelViewDictionary];
    
    // Add the constraint against the contentView
    [self.contentView addConstraints:nameLabelConstraints];
    [self.contentView addConstraints:sizeLabelConstraints];
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//    nameLabel_.shadowColor = selected ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
//    sizeLabel_.shadowColor = selected ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
//}
//
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setSelected:highlighted animated:animated];
//    
//    // Configure the view for the selected state
//    nameLabel_.shadowColor = highlighted ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
//    sizeLabel_.shadowColor = highlighted ? [UIColor clearColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
//}

@end
