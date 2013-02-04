//
//  CommentsViewController.h
//  SetC : SujetsetCorriges
//
//  Created by Jérémy on 17/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullToRefreshView.h"
#import "XMLParser.h"
#import "MBProgressHUD.h"

@interface CommentsViewController : UITableViewController <PullToRefreshViewDelegate, XMLParserDelegate>
{
    NSMutableArray *newsData_;
    
    XMLParser *parser_;
}

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *idArticle;


@end
