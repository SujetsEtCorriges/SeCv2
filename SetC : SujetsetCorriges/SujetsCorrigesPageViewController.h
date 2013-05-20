//
//  SujetsCorrigesPageViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SujetsCorrigesPageViewController : UIViewController <UIPageViewControllerDataSource>
{
    NSString *filiere_; //filiere actuelle
    UIButton *filiereButton;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) NSString *concours;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@end
