//
//  ASRewardAuthData.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-20.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASRewardAuthData : NSObject<NSCoding>

+(ASRewardAuthData *)data;

-(void)addAuthForIndex:(NSInteger)iIndex;
-(void)setRewardDisable;
-(NSInteger)rewardLevel;
-(NSArray *)auths;

@end
