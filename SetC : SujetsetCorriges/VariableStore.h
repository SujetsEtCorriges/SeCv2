//
//  VariableStore.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariableStore : NSObject
{
    NSString *concours;
    NSString *filiere;
}

@property(nonatomic,retain)NSString *concours;
@property(nonatomic,retain)NSString *filiere;
+(VariableStore*)getInstance;

@end
