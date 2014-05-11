//
//  ASKeyObject.m
//  FSGuess
//
//  Created by CarlHwang on 14-2-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASKeyObject.h"

@implementation ASKeyObject

+(ASKeyObject *)keyObjectWithCharater:(NSString *)sKey number:(NSNumber *)num{
    ASKeyObject *object = [[ASKeyObject alloc] init];
    object.charater = sKey;
    object.num = num;
    return [object autorelease];
}

-(void)dealloc{
    [_charater release];
    [_num release];
    [super dealloc];
}

@end
