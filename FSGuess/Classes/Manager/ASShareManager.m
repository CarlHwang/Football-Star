//
//  ASShareManager.m
//  FSGuess
//
//  Created by CarlHwang on 14-2-27.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASShareManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "ASFunctions.h"

@implementation ASShareManager

static ASShareManager *shareManager = nil;
+(ASShareManager *)getInstance{
    if (shareManager == nil) {
        shareManager = [[ASShareManager alloc] init];
    }
    return shareManager;
}

+(void)dropInstance{
    if (shareManager) {
        [shareManager release];
    }
    shareManager = nil;
}

#pragma mark - 分享

+(BOOL)shareToWXSessionWithImage:(UIImage *)image{
    UIImage *thumbnial = [ASFunctions squareThumbnialFromImage:image];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbnial];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 0.3);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    return [WXApi sendReq:req];
}

+(BOOL)shareToWXTimelineWithImage:(UIImage *)image{
    UIImage *thumbnial = [ASFunctions squareThumbnialFromImage:image];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbnial];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 0.3);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    return [WXApi sendReq:req];
}


+(BOOL)shareToQQSessionWithImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    NSData *thumbImgData = UIImageJPEGRepresentation(image, 0.3);
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:thumbImgData
                                                          title:nil
                                                    description:nil];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    return sent == 0;
}

+(BOOL)shareToQQTimelineWithImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    NSData *thumbImgData = UIImageJPEGRepresentation(image, 0.3);
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:thumbImgData
                                                          title:nil
                                                    description:nil];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    return sent == 0;
}

#pragma mark - 推荐

+(BOOL)recommendToWXSession{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.description = [NSString stringWithFormat:@"分享一个好游戏! 一起High爆世界杯吧%C",0xE018];
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];

    ext.webpageUrl = APPSTORE_URL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    return [WXApi sendReq:req];
}

+(BOOL)recommendToWXTimeline{
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"分享一个好游戏! 一起High爆世界杯吧%C",0xE018];
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = APPSTORE_URL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    return [WXApi sendReq:req];
}

+(BOOL)recommendToQQSession{
    
    
    NSURL *URL = [NSURL URLWithString:APPSTORE_URL];
    NSString *title = @"分享一个好游戏!";
    NSString *description = [NSString stringWithFormat:@"一起High爆世界杯吧%C",0xE018];
    NSData *previewImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"icon.png"], 0.8);
    
    QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:URL title:title description:description previewImageData:previewImageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

    return sent == 0;
}

+(BOOL)recommendToQQTimeline{
    
    NSURL *URL = [NSURL URLWithString:APPSTORE_URL];
    NSString *title = @"分享一个好游戏!";
    NSString *description = [NSString stringWithFormat:@"一起High爆世界杯吧%C",0xE018];
    NSData *previewImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"icon.png"], 0.8);
    
    QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:URL title:title description:description previewImageData:previewImageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    return sent == 0;
}

@end
