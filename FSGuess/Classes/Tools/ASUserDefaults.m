//
//  ASUserDefaults.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-18.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASUserDefaults.h"

@implementation ASUserDefaults

+(NSData *)dataForKey:(NSString *)sId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:sId];
}

+(void)setData:(NSData *)data forKey:(NSString *)sId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:sId];
    [defaults synchronize];
}

+(NSString *)stringForKey:(NSString *)sId{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    return [defaluts objectForKey:sId];
}

+(void)setString:(NSString *)string forKey:(NSString *)sId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:sId];
    [defaults synchronize];
}

+(void)removeDataForKey:(NSString *)sId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:sId];
    [defaults synchronize];
}

@end
