//
//  ASPlayerData.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPlayerData : NSObject

+(ASPlayerData *)createPlayerID:(NSInteger)ID playerName:(NSString *)sPlayerName questionList:(NSArray *)list options:(NSString *)sOptions;
-(NSString *)briefForIndex:(NSInteger)iIndex;
-(NSString *)detailForIndex:(NSInteger)iIndex;
-(NSArray *)options;

@property(nonatomic,copy,readonly) NSString *playerName;
@end
