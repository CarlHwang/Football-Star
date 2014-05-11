//
//  ASLogFile.h
//  FootballStarGuess
//
//  Created by CarlHwang on 13-9-21.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASLogFile : NSObject

+(NSString *)logName:(NSDate *)date;
+(NSString *)logPath:(NSDate *)date;
+(ASLogFile *)getInstance;
+(void)dropInstance;
+(BOOL)fileUsing:(NSString *)sFileName;
+(void)fileLog:(NSString *)statement,...;
+(void)simAndFileLog:(NSString *)statement,...;
+(void)simLog:(NSString *)statement,...;

@end
