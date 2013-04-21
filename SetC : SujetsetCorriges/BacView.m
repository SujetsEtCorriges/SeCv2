//
//  BacView.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 21/04/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import "BacView.h"

@interface BacView()

@property (nonatomic, strong) IBOutlet UISwitch *optionSwitch1;
@property (nonatomic, strong) IBOutlet UISwitch *optionSwitch2;
@property (nonatomic, strong) IBOutlet UIScrollView *optionScroll1;

@end

@implementation BacView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initBacViewAtPosition:(float)yPosition
{
    UINib *nib = [UINib nibWithNibName:@"BacView" bundle:nil];
    UIView *myView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    myView.frame=CGRectMake(0,yPosition,320,257);
    [self hideScroll:_optionScroll1];
    self = (BacView *)myView;
    
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

- (IBAction)optionSwitch1Changed:(id)sender
{
    UISwitch *optionSwitch = (UISwitch *)sender;
    
    if (optionSwitch.on)
    {
        [UIView animateWithDuration: 1
                              delay: 0
                            options: (UIViewAnimationCurveEaseInOut)
                         animations:^{
                             optionSwitch.frame = CGRectMake(optionSwitch.frame.origin.x - 50, optionSwitch.frame.origin.y, optionSwitch.frame.size.height, optionSwitch.frame.size.width);
                         }
                         completion:^(BOOL finished) {
                             [self displayScroll:_optionScroll1];
                         }];
        
    }
    else
    {
        [self hideScroll:_optionScroll1];
        [UIView animateWithDuration: 1
                              delay: 0
                            options: (UIViewAnimationCurveEaseInOut)
                         animations:^{
                             optionSwitch.frame = CGRectMake(optionSwitch.frame.origin.x + 50, optionSwitch.frame.origin.y, optionSwitch.frame.size.height, optionSwitch.frame.size.width);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (IBAction)optionSwitch2Changed:(id)sender
{
    UISwitch *optionSwitch = (UISwitch *)sender;
    
    if (optionSwitch.on)
    {
        [UIView animateWithDuration: 1
                              delay: 0
                            options: (UIViewAnimationCurveEaseInOut)
                         animations:^{
                             optionSwitch.frame = CGRectMake(optionSwitch.frame.origin.x - 50, optionSwitch.frame.origin.y, optionSwitch.frame.size.height, optionSwitch.frame.size.width);
                            
                         } completion:nil];
    }
    else
    {
        [UIView animateWithDuration: 1
                              delay: 0
                            options: (UIViewAnimationCurveEaseInOut)
                         animations:^{
                             optionSwitch.frame = CGRectMake(optionSwitch.frame.origin.x + 50, optionSwitch.frame.origin.y, optionSwitch.frame.size.height, optionSwitch.frame.size.width);
                             
                         } completion:nil];
    }
}

- (void)displayScroll:(UIScrollView *)scrollView
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"Latin/Grec", @"Autre", nil];
    
    for (NSUInteger i=0; i<[array count]; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scrollView.frame.size.width*i, 0,scrollView.frame.size.width, scrollView.frame.size.height)];
        label.text = [array objectAtIndex:i];
        label.font = [UIFont fontWithName:@"Arial" size:12];
        label.textAlignment = NSTextAlignmentCenter;
        
        [scrollView addSubview:label];
    }
    CGSize contentSize = CGSizeMake(scrollView.frame.size.width*[array count], scrollView.frame.size.height);
    scrollView.contentSize = contentSize;
    
    [self addSubview:scrollView];
}

- (void)hideScroll:(UIScrollView *)scrollView
{
    [scrollView removeFromSuperview];
}

@end
