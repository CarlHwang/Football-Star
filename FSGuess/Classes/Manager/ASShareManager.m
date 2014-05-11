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
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    return sent == 0;
}



//+(void)shareToWXSessionForAppStoreLink{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"专访张小龙：产品之上的世界观";
//    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
//    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
//
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
//
//    message.mediaObject = ext;
//
//    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneSession;
//
//    [WXApi sendReq:req];
//}
//
//+(void)shareToWXTimelineForAppStoreLink{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"专访张小龙：产品之上的世界观";
//    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
//    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
//
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
//
//    message.mediaObject = ext;
//
//    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneSession;
//
//    [WXApi sendReq:req];
//}

@end
