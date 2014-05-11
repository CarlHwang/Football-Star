//
//  ASGameDataManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASPlayerData;

@interface ASGameDataManager : NSObject

+(ASGameDataManager *)getInstance;
+(void)dropInstance;
+(NSInteger)playerCount;
+(ASPlayerData *)playDataForMission:(NSInteger)iMission;
@end
