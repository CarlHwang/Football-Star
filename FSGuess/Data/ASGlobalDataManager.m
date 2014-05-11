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

@interface ASGlobalDataManager()

@end


@implementation ASGlobalDataManager

static ASGlobalDataManager *globalDataManager = nil;
+(ASGlobalDataManager *)getInstance{
    if (!globalDataManager) {
        globalDataManager = [[ASGlobalDataManager alloc] init];
    }
    return globalDataManager;
}

-(id)init{
    self = [super init];
    if (self) {
        [self initDatas];
    }
    return self;
}

-(void)initDatas{
    NSString *latesMissionKey = [self keyForLatestMission];
    NSString *latesMissionString = [[ASUserDefaults stringForKey:latesMissionKey] AES256DecryptWithKey:AES_LATESMISSION];
    if (!latesMissionString) {
        latesMissionString = @"0";
        [ASUserDefaults setString:[latesMissionString AES256EncryptWithKey:AES_LATESMISSION] forKey:latesMissionKey];
    }
    _latestMission = [latesMissionString integerValue];
    
    NSString *showDetailAlertString = [ASUserDefaults stringForKey:@"**hasshowdetailalert"];
    if (!showDetailAlertString) {
        showDetailAlertString = @"0";
        [ASUserDefaults setString:showDetailAlertString forKey:@"**hasshowdetailalert"];
    }
    _hasShowDetailAlert = [showDetailAlertString boolValue];
}

-(void)setLatestMission:(NSInteger)latestMission{
    if (_latestMission >= latestMission || _latestMission >= [ASGameDataManager playerCount] -1 ) {
        return;
    }
    _latestMission = latestMission;
    NSString *latesMissionKey = [self keyForLatestMission];
    [ASUserDefaults setString:[[NSString stringWithFormat:@"%d",_latestMission] AES256EncryptWithKey:AES_LATESMISSION] forKey:latesMissionKey];
}

-(NSString *)keyForLatestMission{
    return [@"**latestMission**" AES256EncryptWithKey:AES_KEY];
}

-(void)setHasShowDetailAlert:(BOOL)hasShowDetailAlert{
    if (_hasShowDetailAlert != hasShowDetailAlert) {
        _hasShowDetailAlert = hasShowDetailAlert;
        [ASUserDefaults setString:[NSString stringWithFormat:@"%d",_hasShowDetailAlert] forKey:@"**hasshowdetailalert"];
    }
}

@end
