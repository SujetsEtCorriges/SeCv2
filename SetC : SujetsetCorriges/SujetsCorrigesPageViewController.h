//
//  SujetsCorrigesPageViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SujetsCorrigesPageViewController : UIViewController <UIPageViewControllerDataSource, UIPickerViewAccessibilityDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
{
    //variables pour le picker view
    NSArray *tabFiliere_; //tableau des filiere
    NSString *filiere_; //filiere actuelle
    UIActionSheet *menu_; //menu du picker
    NSInteger filiereRow_; //row de la filiere actuelle
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) NSString *concours;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@end
