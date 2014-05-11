//
//  ASLogFile.m
//  FootballStarGuess
//
//  Created by CarlHwang on 13-9-21.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASLogFile.h"
#import "ASFunctions.h"
#include <stdio.h>

@interface ASLogFile()
@property(nonatomic,assign) FILE *file;
@property(nonatomic,assign) NSInteger logDay;
@end

@implementation ASLogFile

+(NSString *)logName:(NSDate *)date{
    NSString *sLogFileName = [NSString stringWithFormat:@"Log%@.txt",[ASFunctions daytimeDay:date]];
    return sLogFileName;
}

+(NSString *)logPath:(NSDate *)date{
    NSString *sLogFileName = [ASLogFile logName:date];
    return [ASFunctions storeLogPath:sLogFileName];
}

static ASLogFile *g_LogFile = nil;
+(ASLogFile *)getInstance{
    if (nil == g_LogFile) {
        g_LogFile = [[ASLogFile alloc] init];
    }
    return g_LogFile;
}

+(void)dropInstance{
    if (g_LogFile) {
        [g_LogFile release];
    }
    g_LogFile = nil;
}

+(BOOL)fileUsing:(NSString *)sFileName{
    NSString *sLogFileName = [ASLogFile logName:[NSDate date]];
    if (g_LogFile && [g_LogFile logAvailable] && [sFileName isEqualToString:sLogFileName]) {
        return YES;
    }
    return NO;
}

+(void)fileLog:(NSString *)statement,...{
    ASLogFile *g_LogFile = [ASLogFile getInstance];
    if (g_LogFile && [g_LogFile logAvailable]) {
        va_list args;
        va_start(args, statement);
        NSString *str = [[NSString alloc] initWithFormat:statement arguments:args];
        va_end(args);
        [g_LogFile writeFile:str];
        [str release];
    }
}

+(void)simAndFileLog:(NSString *)statement,...{
    ASLogFile *g_LogFile = [ASLogFile getInstance];
    if (g_LogFile && [g_LogFile logAvailable]) {
        va_list args;
        va_start(args, statement);
        NSString *str = [[NSString alloc] initWithFormat:statement arguments:args];
        va_end(args);
        [g_LogFile writeFile:str];
//#if TARGET_IPHONE_SIMULATOR
//        NSLog(@"%@",str);
//#endif
        NSLog(@"%@",str);
        [str release];
    }
}

+(void)simLog:(NSString *)statement,...{
    va_list args;
    va_start(args, statement);
    NSString *str = [[NSString alloc] initWithFormat:statement arguments:args];
    va_end(args);
//#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"%@",str);
//#else
    NSLog(@"%@",str);
    ASLogFile *g_LogFile = [ASLogFile getInstance];
    if (g_LogFile && [g_LogFile logAvailable]) {
        [g_LogFile writeFile:str];
    }
//#endif
    [str release];
}

-(id)init{
    self = [super init];
    if (nil != self) {
        [self openFile:[NSDate date]];
    }
    return self;
}

-(BOOL)newDay:(NSDate *)date{
    return _logDay != [ASFunctions dayInterval:date];
}

-(BOOL)logAvailable{
    return NULL != _file;
}

-(void)checkDate:(NSDate *)date{
    if ([self newDay:date]) {
        [self closeFile];
        [self openFile:date];
    }
}

-(void)openFile:(NSDate *)date{
    _file = fopen([[ASLogFile logPath:date] UTF8String], "a+");
    if (NULL == _file) {
        return;
    }
    _logDay = [ASFunctions dayInterval:date];
}

-(void)writeFile:(NSString *)sContext{
    if (NULL == _file) {
        return;
    }
    NSString *sTemp = [NSString stringWithString:sContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSDate *date = [NSDate date];
        [self checkDate:date];
        if (NULL == _file) {
            return;
        }
        NSString *sAllText = [NSString stringWithFormat:@"%@ %@\n",[ASFunctions daytimeMinute:date], sTemp];
        NSData *data = [self utf8ByUtf8String:sAllText];
        fwrite([data bytes], 1, [data length], _file);
        fflush(_file);
        [pool release];
    });
}

-(NSData *)utf8ByUtf8String:(NSString *)string{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSData *data = [string dataUsingEncoding:enc];
    return data;
}

-(void)closeFile{
    if (_file != NULL) {
        fclose(_file);
        _logDay = 0;
        _file = NULL;
    }
}

@end
