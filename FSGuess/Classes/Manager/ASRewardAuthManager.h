//
//  ASRewardAuthManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-20.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASRewardAuthData.h"

@interface ASRewardAuthManager : NSObject

+(ASRewardAuthManager *)getInstance;

-(ASRewardAuthData *)dataForMission:(NSInteger)iMission;
-(void)updateData:(ASRewardAuthData *)data forMission:(NSInteger)iMission;

@end
