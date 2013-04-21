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
@property (nonatomic, strong) IBOutlet UIScrollView *optionScroll2;

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
        _optionSwitch2.enabled = YES;
        [self moveLeft:optionSwitch andDisplay:_optionScroll1];
    }
    else
    {
        _optionSwitch2.enabled = NO;
        if (_optionSwitch2.on)
        {
            _optionSwitch2.on = NO;
            [self moveRight:_optionSwitch2 andHide:_optionScroll2];
        }
        
        [self moveRight:optionSwitch andHide:_optionScroll1];
    }
}

- (IBAction)optionSwitch2Changed:(id)sender
{
    UISwitch *optionSwitch = (UISwitch *)sender;
    if (optionSwitch.on)
    {
            [self moveLeft:optionSwitch andDisplay:_optionScroll2];            
    }
    else
    {
            [self moveRight:optionSwitch andHide:_optionScroll2];
    }
}


#pragma mark - mouvement method
- (void)moveLeft:(UISwitch *)optionSwitch andDisplay:(UIScrollView *)scrollView
{

    [UIView animateWithDuration: 0.5
                          delay: 0
                        options: (UIViewAnimationCurveEaseInOut)
                     animations:^{
                         optionSwitch.frame = CGRectMake(125, optionSwitch.frame.origin.y, optionSwitch.frame.size.height, optionSwitch.frame.size.width);
                     }
                     completion:^(BOOL finished) {
                         [self displayScroll:scrollView];
                     }];
}

- (void)moveRight:(UISwitch *)optionSwitch andHide:(UIScrollView *)scrollView
{
    [self hideScroll:scrollView];
    [UIView animateWithDuration: 0.5
                          delay: 0
                        options: (UIViewAnimationCurveEaseInOut)
                     animations:^{
                         optionSwitch.frame = CGRectMake(185, optionSwitch.frame.origin.y, optionSwitch.frame.size.height, optionSwitch.frame.size.width);
                     }
                     completion:^(BOOL finished) {
                     }];
}


#pragma mark - scroll methods
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
