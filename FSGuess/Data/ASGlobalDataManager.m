//
//  ASGlobalDataManager.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-25.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASGlobalDataManager.h"
#import "ASAESEncryption.h"
#import "ASUserDefaults.h"
#import "ASGameDataManager.h"

#define AES_KEY @"huangwenzhicommandercarl"
#define AES_LATESMISSION @"carljoaquinhwang"

#define WIN_TIMES_FOR_SHOW_RATING 15

@interface ASGlobalDataManager()
@property (nonatomic,assign) NSInteger latestMission;
@property (nonatomic,assign) BOOL hasShowDetailAlert;
@property (nonatomic,assign) NSInteger winCount; //回答正确的统计
@property (nonatomic,copy) NSString *bundleVersion;
@property (nonatomic,assign) BOOL canShowRating;
@property (nonatomic,assign) NSInteger rewardCoinWhenBecomeActive;
@end


@implementation ASGlobalDataManager

static ASGlobalDataManager *globalDataManager = nil;
+(ASGlobalDataManager *)getInstance{
    if (!globalDataManager) {
        globalDataManager = [[ASGlobalDataManager alloc] init];
    }
    return globalDataManager;
}

+(NSInteger)rewardCoinWhenBecomeActive{
    ASGlobalDataManager *globalManager = [ASGlobalDataManager getInstance];
    return globalManager.rewardCoinWhenBecomeActive;
}

+(void)setRewardCoinWhenBecomeActive:(NSInteger)coinValue{
    ASGlobalDataManager *globalManager = [ASGlobalDataManager getInstance];
    globalManager.rewardCoinWhenBecomeActive = coinValue;
}

//! 弹出请求评价的框，规则：每次启动后获胜WIN_TIMES_FOR_SHOW_RATING次后弹出，弹出后无论是否选择评价，以后都不再提示。版本更新后恢复规则。
+(BOOL)showRating{
    ASGlobalDataManager *globalManager = [ASGlobalDataManager getInstance];
    if (!globalManager.canShowRating) {
        return NO;
    }
    ASGlobalDataManager *manager = [ASGlobalDataManager getInstance];
    manager.winCount++;
    return manager.winCount == WIN_TIMES_FOR_SHOW_RATING;
}

+(void)disableShowRating{
    ASGlobalDataManager *globalManager = [ASGlobalDataManager getInstance];
    globalManager.canShowRating = NO;
    [ASUserDefaults setString:@"0" forKey:@"**canshowrating"];
}

+(NSInteger)latestMission{
    return [ASGlobalDataManager getInstance].latestMission;
}

+(void)setLatestMission:(NSInteger)latestMission{
    ASGlobalDataManager *globalManager = [ASGlobalDataManager getInstance];
    
    if (globalManager.latestMission >= latestMission || globalManager.latestMission >= [ASGameDataManager playerCount] -1 ) {
        return;
    }
    globalManager.latestMission = latestMission;
    NSString *latesMissionKey = [ASGlobalDataManager keyForLatestMission];
    [ASUserDefaults setString:[[NSString stringWithFormat:@"%d",globalManager.latestMission] AES256EncryptWithKey:AES_LATESMISSION] forKey:latesMissionKey];
}

+(BOOL)hasShowDetailAlert{
    return [ASGlobalDataManager getInstance].hasShowDetailAlert;
}

+(void)setHasShowDetailAlert:(BOOL)hasShowDetailAlert{
    ASGlobalDataManager *globalManager = [ASGlobalDataManager getInstance];
    
    if (globalManager.hasShowDetailAlert != hasShowDetailAlert) {
        globalManager.hasShowDetailAlert = hasShowDetailAlert;
        [ASUserDefaults setString:[NSString stringWithFormat:@"%d",globalManager.hasShowDetailAlert] forKey:@"**hasshowdetailalert"];
    }
}

#pragma mark - private

+(NSString *)keyForLatestMission{
    return [@"**latestMission**" AES256EncryptWithKey:AES_KEY];
}

#pragma mark - （-）method

-(id)init{
    self = [super init];
    if (self) {
        _winCount = 0;
        [self initDatas];
    }
    return self;
}

-(void)initDatas{
    [self initializeLatestMission];
    [self initializeHasShowDetail];
    [self initializeCanShowRating];
    [self initializeBundleVersion];
}

-(void)initializeLatestMission{
    //最新关数
    NSString *latesMissionKey = [ASGlobalDataManager keyForLatestMission];
    NSString *latesMissionString = [[ASUserDefaults stringForKey:latesMissionKey] AES256DecryptWithKey:AES_LATESMISSION];
    if (!latesMissionString) {
        latesMissionString = @"0";
        [ASUserDefaults setString:[latesMissionString AES256EncryptWithKey:AES_LATESMISSION] forKey:latesMissionKey];
    }
    _latestMission = [latesMissionString integerValue];
}

-(void)initializeHasShowDetail{
    //是否弹过“奖励逐渐减少”的框
    NSString *showDetailAlertString = [ASUserDefaults stringForKey:@"**hasshowdetailalert"];
    if (!showDetailAlertString) {
        showDetailAlertString = @"0";
        [ASUserDefaults setString:showDetailAlertString forKey:@"**hasshowdetailalert"];
    }
    _hasShowDetailAlert = [showDetailAlertString boolValue];
}

-(void)initializeCanShowRating{
    //是否可以弹出评价
    NSString *canShowRatingString = [ASUserDefaults stringForKey:@"**canshowrating"];
    if (!canShowRatingString) {
        canShowRatingString = @"1";
        [ASUserDefaults setString:canShowRatingString forKey:@"**canshowrating"];
    }
    _canShowRating = [canShowRatingString boolValue];
}

-(void)initializeBundleVersion{
    //版本号
    NSString *bundleVersion = [ASUserDefaults stringForKey:@"**bundleversion"]; //已保存的版本号
    self.bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //当前版本号
    ASLog(@"%@",_bundleVersion);
    
    if (!bundleVersion) {
        
        if (_bundleVersion) {
            [ASUserDefaults setString:_bundleVersion forKey:@"**bundleversion"];
        }
    }else{
        if (_bundleVersion) {
            if (![_bundleVersion isEqualToString:bundleVersion]) {
                [self actionWhenBundleVersionUpdated];
                [ASUserDefaults setString:_bundleVersion forKey:@"**bundleversion"];
            }
        }
    }
}


//! 版本更新后要做的事，一般用户恢复某些标志，比如是否弹出评价框
-(void)actionWhenBundleVersionUpdated{
    _canShowRating = YES;
    [ASUserDefaults setString:@"1" forKey:@"**canshowrating"];
}

@end
