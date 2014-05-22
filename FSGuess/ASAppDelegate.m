//
//  ASAppDelegate.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-23.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASMainController.h"
#import "ASCoinManager.h"
#import "ASMacros.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ASSoundPlayer.h"
#import "ASGlobalDataManager.h"
#import "ASFunctions.h"

@interface ASAppDelegate()
@property (nonatomic, retain) NSURL *updateURL;
@end

@implementation ASAppDelegate


#pragma mark - version update

-(void)handleUpdateDictionary:(NSDictionary *)infoDict{
    
    NSString *newVersion = [infoDict objectForKey:@"version"];
    if (!newVersion) {
        return;
    }
    
    BOOL update = [[infoDict objectForKey:@"update"] boolValue];
    BOOL needJumpAppStrore = NO;
    
    if (update) {
        
        NSString *handledVersion = [ASGlobalDataManager handledUpdateVersion];
        if (!handledVersion || ![newVersion isEqualToString:handledVersion]) {
            needJumpAppStrore = YES;
        }
    }
    
    if (needJumpAppStrore) {
        [ASGlobalDataManager setHandledUpdateVersion:newVersion];
        NSString *updateLog = [infoDict objectForKey:@"update_log"];
        
        NSArray *URLForVersion = [[infoDict objectForKey:@"path"] componentsSeparatedByString:@"$$"];
        NSString *URLString = [ASFunctions systemVersionNotSmallerThan:7.0] ? [URLForVersion objectAtIndex:1] : [URLForVersion objectAtIndex:0];
        
        self.updateURL = [NSURL URLWithString:URLString];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有可用的新版本%@",newVersion] message:updateLog delegate:self cancelButtonTitle:@"忽略此版本" otherButtonTitles:@"访问Store", nil];
        [alertView show];
        [alertView release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"访问Store"]) {

        
        if ([[UIApplication sharedApplication] canOpenURL:_updateURL]) {
            [[UIApplication sharedApplication] openURL:_updateURL];
            self.updateURL = nil;
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"无法跳转到AppStore" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }
}

#pragma mark - application delegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [ASCoinManager getInstance];
    [ASSoundPlayer sharedPlayer];
    return YES;
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    ASMainController *mainController = [ASMainController mainController];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:mainController] autorelease];
    [_navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    //umeng
    NSString *sUmendId = DEVICE_BASIC_IPHONE() ? UMEND_ID : UMEND_IPAD_ID;
    [MobClick startWithAppkey:sUmendId reportPolicy:SEND_INTERVAL channelId:nil];
    [MobClick checkUpdateWithDelegate:self selector:@selector(handleUpdateDictionary:)];
    
    //weixin
    [WXApi registerApp:WX_APP_ID];
    
    //QQ
    [[TencentOAuth alloc] initWithAppId:QQ_APP_ID andDelegate:nil];
    
    //weibo
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBO_APP_ID];
    
    return YES;
}
-(void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    NSInteger coinValue = [ASGlobalDataManager rewardCoinWhenBecomeActive];
    if (coinValue > 0) {
        [ASCoinManager addCoin:coinValue];
        [ASGlobalDataManager setRewardCoinWhenBecomeActive:0];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%C已经往您的金库塞了%d个金币哦~", 0xE418, coinValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    
    //取消之前所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //清空 icon数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //启动本地通知
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        //现在的时间
        NSDate *thisDayInNextWeek = [[NSDate date] dateByAddingTimeInterval:7*24*60*60];
        notification.fireDate = thisDayInNextWeek;
        notification.repeatInterval = kCFCalendarUnitWeek;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1;
        
        notification.alertBody = @"球星猜到底，为2014世界杯热身。";
        
        notification.alertAction = @"打开";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [notification release];
    }
    
}

-(void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    ASLog(@"%@",url);
    if ([url.absoluteString hasPrefix:WX_APP_ID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.absoluteString hasPrefix:[@"tencent" stringByAppendingString:QQ_APP_ID]]){
#if __QQAPI_ENABLE__
        [QQApiInterface handleOpenURL:url delegate:self];
#endif
        if (YES == [TencentOAuth CanHandleOpenURL:url]){
            return [TencentOAuth HandleOpenURL:url];
        }
        
    }else if ([url.absoluteString hasPrefix:[@"wb" stringByAppendingString:WEIBO_APP_ID]]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    ASLog(@"%@",url);
    if ([url.absoluteString hasPrefix:WX_APP_ID]) {
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if ([url.absoluteString hasPrefix:[@"tencent" stringByAppendingString:QQ_APP_ID]]){
#if __QQAPI_ENABLE__
        [QQApiInterface handleOpenURL:url delegate:self];
#endif
        if (YES == [TencentOAuth CanHandleOpenURL:url]){
            return [TencentOAuth HandleOpenURL:url];
        }
    
    }else if ([url.absoluteString hasPrefix:[@"wb" stringByAppendingString:WEIBO_APP_ID]]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    
    return YES;
}

-(void)onReq:(id)req{
    if ([req isKindOfClass:[QQBaseReq class]]) {
        
    }else if ([req isKindOfClass:[BaseReq class]]){
        
    }
}

-(void)onResp:(id)resp{
    if ([resp isKindOfClass:[QQBaseResp class]]) {
        
    }else if ([resp isKindOfClass:[BaseResp class]]){
        
    }
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

-(void)isOnlineResponse:(NSDictionary *)response{
    
}

-(void)dealloc{
    [_window release];
    [_updateURL release];
    [_navigationController release];
    [super dealloc];
}

@end
