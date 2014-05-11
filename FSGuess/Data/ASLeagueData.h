//
//  ASLeagueData.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASLeagueData : NSObject

+(ASLeagueData *)createLeagueID:(NSInteger)ID leagueName:(NSString *)sLeagueName;

@property(nonatomic,assign,readonly) NSInteger ID;
@property(nonatomic,copy,readonly) NSString *leagueName;

@end
