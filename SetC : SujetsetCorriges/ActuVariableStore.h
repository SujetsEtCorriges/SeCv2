//
//  ActuVariableStore.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActuVariableStore : NSObject
{
    NSString *urlComments;
    NSString *idArticle;
    NSString *titreArticle;
}

@property (nonatomic,retain) NSString *urlComments;
@property (nonatomic,retain) NSString *idArticle;
@property (nonatomic,retain) NSString *titreArticle;
+(ActuVariableStore*)getInstance;

@end