//
//  ASKeyObject.h
//  FSGuess
//
//  Created by CarlHwang on 14-2-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASKeyObject : NSObject

+(ASKeyObject *)keyObjectWithCharater:(NSString *)sKey number:(NSNumber *)num;

@property (nonatomic,copy) NSString *charater;
@property (nonatomic,retain) NSNumber *num;

@end
