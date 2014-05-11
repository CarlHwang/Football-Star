//
//  ASRewardAuthManager.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-20.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASRewardAuthManager.h"
#import "ASGameDataManager.h"
#import "ASAESEncryption.h"
#import "ASUserDefaults.h"

#define AES_KEY @"huangwenzhicarlhwang"

@interface ASRewardAuthManager()
@property (nonatomic,assign) NSMutableDictionary *RADict;
@end

@implementation ASRewardAuthManager

static ASRewardAuthManager *RAManager = nil;
+(ASRewardAuthManager *)getInstance{
    if (RAManager == nil) {
        RAManager = [[ASRewardAuthManager alloc] init];
    }
    return RAManager;
}

+(void)dropInstance{
    if (RAManager) {
        [RAManager release];
    }
    RAManager = nil;
}

-(id)init{
    self = [super init];
    if (nil != self) {
        [self initRADict];
    }
    return self;
}

-(void)dealloc{
    [_RADict release];
    [super dealloc];
}

-(void)initRADict{
    _RADict = [[NSMutableDictionary alloc] init];
    NSInteger playerNum = [ASGameDataManager playerCount];
    for (NSInteger iMission=0; iMission<playerNum; iMission++) {
        NSString *key = [self keyForMission:iMission];
        NSData *decodeData = [ASUserDefaults dataForKey:key];
        if (!decodeData) {
            ASRewardAuthData *data = [ASRewardAuthData data];
            NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:data];
            [_RADict setObject:data forKey:[NSNumber numberWithInteger:iMission]];
            [ASUserDefaults setData:encodeData forKey:[self keyForMission:iMission]];
            continue;
        }
        ASRewardAuthData *data = (ASRewardAuthData *)[NSKeyedUnarchiver unarchiveObjectWithData:decodeData];
        [_RADict setObject:data forKey:[NSNumber numberWithInteger:iMission]];
    }
}

-(NSString *)keyForMission:(NSInteger)iMission{
    return [[NSString stringWithFormat:@"%d**radict**",iMission] AES256EncryptWithKey:AES_KEY];
}


-(ASRewardAuthData *)dataForMission:(NSInteger)iMission{
    ASRewardAuthData *data = [_RADict objectForKey:[NSNumber numberWithInteger:iMission]];
    if (!data) {
        NSString *key = [self keyForMission:iMission];
        NSData *decodeData = [ASUserDefaults dataForKey:key];
        if (decodeData) {
            data = (ASRewardAuthData *)[NSKeyedUnarchiver unarchiveObjectWithData:decodeData];
            [_RADict setObject:data forKey:[NSNumber numberWithInteger:iMission]];
        }
    }
    return data;
}

-(void)updateData:(ASRewardAuthData *)data forMission:(NSInteger)iMission{
    if (!data) {
        return;
    }
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [_RADict setObject:data forKey:[NSNumber numberWithInteger:iMission]];
    [ASUserDefaults setData:encodeData forKey:[self keyForMission:iMission]];
}


@end
