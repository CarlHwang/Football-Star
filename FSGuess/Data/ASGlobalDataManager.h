//
//  ASGlobalDataManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-25.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGlobalDataManager : NSObject

@property (nonatomic,assign) NSInteger latestMission;
@property (nonatomic,assign) BOOL hasShowDetailAlert;

+(ASGlobalDataManager *)getInstance;

@end
