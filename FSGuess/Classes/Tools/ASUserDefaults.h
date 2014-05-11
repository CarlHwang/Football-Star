//
//  ASUserDefaults.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-18.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUserDefaults : NSObject

+(NSData *)dataForKey:(NSString *)sId;
+(void)setData:(NSData *)data forKey:(NSString *)sId;
+(NSString *)stringForKey:(NSString *)sId;
+(void)setString:(NSString *)string forKey:(NSString *)sId;
+(void)removeDataForKey:(NSString *)sId;

@end
