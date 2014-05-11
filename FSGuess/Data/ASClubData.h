//
//  ASClubData.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASClubData : NSObject

+(ASClubData *)createClubID:(NSInteger)ID clubName:(NSString *)sClubName;

@property(nonatomic,assign,readonly) NSInteger ID;
@property(nonatomic,copy,readonly) NSString *clubName;

@end
