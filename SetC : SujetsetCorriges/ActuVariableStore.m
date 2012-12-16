//
//  ActuVariableStore.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "ActuVariableStore.h"

@implementation ActuVariableStore

@synthesize urlComments;
@synthesize idArticle;
@synthesize titreArticle;

static ActuVariableStore *instance =nil;
+(ActuVariableStore *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [ActuVariableStore new];
            //instance.concours = @"aucun";
            //instance.filiere = @"MP";
        }
    }
    return instance;
}
@end
