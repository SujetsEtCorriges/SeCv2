//
//  VariableStore.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore

@synthesize concours;
@synthesize filiere;

static VariableStore *instance =nil;
+(VariableStore *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [VariableStore new];
            instance.concours = @"aucun";
            instance.filiere = @"MP";
        }
    }
    return instance;
}
@end

