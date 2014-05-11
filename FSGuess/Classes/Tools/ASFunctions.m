//
//  ASFunctions.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASFunctions.h"

@implementation ASFunctions

+(NSString *)daytimeDay:(NSDate *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *sDate = [formatter stringFromDate:time];
    [formatter release];
    return sDate;
}

+(NSString *)storeLogPath:(NSString *)sSubPath{
    NSString *sPath = [NSString stringWithFormat:@"%@/Documents/Log/",NSHomeDirectory()];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:sPath]) {
        [fileManager createDirectoryAtPath:sPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    if (sSubPath) {
        return [NSString stringWithFormat:@"%@%@",sPath,sSubPath];
    }
    return sPath;
}

+(NSString *)daytimeMinute:(NSDate *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss:SSS"];
    NSString *sDate = [formatter stringFromDate:time];
    [formatter release];
    return sDate;
}

+(NSInteger)dayInterval:(NSDate *)date{
    return [date timeIntervalSince1970]/(3600*24);
}


+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+(UIImage *)squareThumbnialFromImage:(UIImage *)image{
    UIImage *newImage;
    CGSize size = CGSizeMake(image.size.width/1.5, image.size.height/1.5);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize newSize = newImage.size;
    CGFloat length = newSize.width*0.7;
    CGImageRef sourceImageRef = [newImage CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake((newSize.width-length)/2, newSize.height*0.2, length,length));
    UIImage *newThumbnial = [UIImage imageWithCGImage:newImageRef];
    return newThumbnial;
}

+(BOOL)systemVersionNotSmallerThan:(float)version{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    float systemVersion = [phoneVersion floatValue];
    return systemVersion >= version;
}

@end
