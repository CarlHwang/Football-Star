//
//  ASShareManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-2-27.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASShareManager : NSObject

//游戏中分享
+(BOOL)shareToWXSessionWithImage:(UIImage *)image;
+(BOOL)shareToWXTimelineWithImage:(UIImage *)image;
+(BOOL)shareToQQSessionWithImage:(UIImage *)image;
+(BOOL)shareToQQTimelineWithImage:(UIImage *)image;
+(BOOL)shareToWeiboWithImage:(UIImage *)image;

//回答正确页推荐
+(BOOL)recommendToWXSession;
+(BOOL)recommendToWXTimeline;
+(BOOL)recommendToQQSession;
+(BOOL)recommendToQQTimeline;
+(BOOL)recommendToWeibo;

@end