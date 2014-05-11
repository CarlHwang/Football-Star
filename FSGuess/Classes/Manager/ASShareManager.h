//
//  ASShareManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-2-27.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASShareManager : NSObject

+(BOOL)shareToWXSessionWithImage:(UIImage *)image;
+(BOOL)shareToWXTimelineWithImage:(UIImage *)image;
+(BOOL)shareToQQSessionWithImage:(UIImage *)image;
+(BOOL)shareToQQTimelineWithImage:(UIImage *)image;

@end