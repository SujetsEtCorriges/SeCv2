//
//  CPGEView.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 12/04/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "CPGEView.h"

@implementation CPGEView

@synthesize sgRedoublant = _sgRedoublant;
@synthesize lStatut = _lStatut;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initCPGEViewAtPosition:(float)yPosition
{
    UINib *nib = [UINib nibWithNibName:@"CPGEView" bundle:nil];
    UIView *myView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    myView.frame=CGRectMake(0,yPosition,320,257);
    self = (CPGEView *)myView;
        
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)valueChanged:(id)sender
{
    UISegmentedControl *sg = (UISegmentedControl *)sender;
    BOOL statut;
    
    switch (sg.selectedSegmentIndex)
    {
        case 0:
            statut = NO;
            break;
        case 1:
            statut = YES;
            break;
    }
    
    [self.delegate redoublant:statut];
}



@end
