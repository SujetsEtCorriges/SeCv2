//
//  AppDelegate.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 15/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

//ASIHTTPRequest
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ASIHTTPRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
