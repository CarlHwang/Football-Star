//
//  ASGlobalDataManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-25.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGlobalDataManager : NSObject

+(ASGlobalDataManager *)getInstance;

+(NSInteger)rewardCoinWhenBecomeActive;
+(void)setRewardCoinWhenBecomeActive:(NSInteger)coinValue;

+(NSInteger)latestMission;
+(void)setLatestMission:(NSInteger)latestMission;

+(BOOL)hasShowDetailAlert;
+(void)setHasShowDetailAlert:(BOOL)hasShowDetailAlert;

+(BOOL)showRating;
+(void)disableShowRating;

@end
