//
//  ASFunctions.h
//  FootballStar
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASFunctions : NSObject
+(NSString *)daytimeDay:(NSDate *)time;
+(NSString *)storeLogPath:(NSString *)sSubPath;
+(NSString *)daytimeMinute:(NSDate *)time;
+(NSInteger)dayInterval:(NSDate *)date;

+(BOOL)isPureInt:(NSString*)string;
+(UIImage *)squareThumbnialFromImage:(UIImage *)image;
+(BOOL)systemVersionNotSmallerThan:(float)version;
@end
