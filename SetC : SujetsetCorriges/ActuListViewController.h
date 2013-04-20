//
//  ActuListViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullToRefreshView.h"
#import "NewsCell.h"

@interface ActuListViewController : UITableViewController <PullToRefreshViewDelegate>
{
    NSMutableArray *newsData_;
}

@end
