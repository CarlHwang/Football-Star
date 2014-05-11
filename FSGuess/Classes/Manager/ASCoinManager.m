//
//  ASCoinManager.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-18.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASCoinManager.h"
#import "ASUserDefaults.h"
#import "ASAESEncryption.h"
#import "ASFunctions.h"

#define COIN_DEFAULT_KEY @"qiuxingcaidaodi.coin.key"    //金币默认的key
#define COIN_BACKUP_KEY @"afrostudio.coin.backup"       //当金币的值错乱时备用key

#define AES_SECRET_KEY  @"huangwenzhicarlhwang443623"   //AES密钥，默认使用
#define AES_BACKUP_KEY @"commandercarl20140318"         //AES备份金币专用密钥

#define START_UP_COIN_STRING @"100"

@interface ASCoinManager()
@property(nonatomic,assign) NSInteger coin;
@end

@implementation ASCoinManager

static ASCoinManager *coinManager = nil;
+(ASCoinManager *)getInstance{
    if (coinManager == nil) {
        coinManager = [[ASCoinManager alloc] init];
    }
    return coinManager;
}

+(void)dropInstance{
    if (coinManager) {
        [coinManager release];
    }
    coinManager = nil;
}

+(NSInteger)coinValue{
    if (coinManager) {
        return MAX(coinManager.coin, -1);
    }
    return -1;
}

+(void)addCoin:(NSInteger)iValue{
    if (coinManager) {
        coinManager.coin += iValue;
        [coinManager writeDefaultCoin:coinManager.coin];
        [coinManager writeBackupCoin:coinManager.coin];
    }
}

+(BOOL)substractCoin:(NSInteger)iValue{
    if (coinManager) {
        if (coinManager.coin >= iValue) {
            coinManager.coin -= iValue;
            [coinManager writeDefaultCoin:coinManager.coin];
            [coinManager writeBackupCoin:coinManager.coin];
            return YES;
        }
    }
    return NO;
}

-(id)init{
    self = [super init];
    if (nil != self) {
        _coin = [self fetchCoinValue];
    }
    return self;
}

-(void)writeDefaultCoin:(NSInteger)iCoin{
    NSString *sCoinString = [NSString stringWithFormat:@"%d",iCoin];
    [self writeDefauleCoinString:sCoinString];
}

-(void)writeBackupCoin:(NSInteger)iCoin{
    NSString *sCoinString = [NSString stringWithFormat:@"%d",iCoin];
    [self writeBakcupCoinString:sCoinString];
}

-(void)writeDefauleCoinString:(NSString *)sCoinString{
    NSString *sAESKey = [COIN_DEFAULT_KEY AES256EncryptWithKey:AES_SECRET_KEY];
    [ASUserDefaults setString:[sCoinString AES256EncryptWithKey:AES_SECRET_KEY] forKey:sAESKey];
}

-(void)writeBakcupCoinString:(NSString *)sCoinString{
    NSString *sAESKeyBackup = [COIN_BACKUP_KEY AES256EncryptWithKey:AES_BACKUP_KEY];
    [ASUserDefaults setString:[sCoinString AES256EncryptWithKey:AES_BACKUP_KEY] forKey:sAESKeyBackup];
}

-(NSString *)readDefaultCoinString{
    NSString *sAESKey = [COIN_DEFAULT_KEY AES256EncryptWithKey:AES_SECRET_KEY];
    NSString *sAESString = [ASUserDefaults stringForKey:sAESKey];
    if (sAESString) {
        return [sAESString AES256DecryptWithKey:AES_SECRET_KEY];
    }
    return nil;
}

-(NSString *)readBackupCoinString{
    NSString *sAESKey = [COIN_BACKUP_KEY AES256EncryptWithKey:AES_BACKUP_KEY];
    NSString *sAESString = [ASUserDefaults stringForKey:sAESKey];
    if (sAESString) {
        return [sAESString AES256DecryptWithKey:AES_BACKUP_KEY];
    }
    return nil;
}

-(NSInteger)fetchCoinValue{
    //!------------------default coin-------------------//
    NSString *sDefaultCoinString = [self readDefaultCoinString];
    if (!sDefaultCoinString) {
        sDefaultCoinString = START_UP_COIN_STRING;
        [self writeDefauleCoinString:sDefaultCoinString];
    }
    
    //!------------------backup coin-------------------//
    NSString *sBackupCoinString = [self readBackupCoinString];
    if (!sBackupCoinString) {
        sBackupCoinString = START_UP_COIN_STRING;
        [self writeBakcupCoinString:sBackupCoinString];
    }
    
    BOOL isDefaultCoinPureInt = [ASFunctions isPureInt:sDefaultCoinString];
    BOOL isBackupCoinPureInt = [ASFunctions isPureInt:sBackupCoinString];
    
    NSInteger iDefaultCoin = [sDefaultCoinString integerValue];
    NSInteger iBackupCoin = [sBackupCoinString integerValue];
    
    if (isDefaultCoinPureInt && isBackupCoinPureInt) {  //两个都是符合格式的整数
        
        //判断大小，用小的覆盖大的并返回小的
        if (iDefaultCoin < iBackupCoin) {
            [self writeBakcupCoinString:sDefaultCoinString];
            return iDefaultCoin;
            
        }else if (iDefaultCoin > iBackupCoin) {
            [self writeDefauleCoinString:sBackupCoinString];
            return iBackupCoin;
        }
        return iDefaultCoin;
        
    }else if (isDefaultCoinPureInt) {   //默认的是符合格式的整数，备份的不是
        
        [self writeBakcupCoinString:sDefaultCoinString];
        return iDefaultCoin;
        
    }else if (isBackupCoinPureInt) {
        [self writeDefauleCoinString:sBackupCoinString];
        return iBackupCoin;
        
    }else{
        [self writeBakcupCoinString:START_UP_COIN_STRING];
        [self writeDefauleCoinString:START_UP_COIN_STRING];
        return [START_UP_COIN_STRING integerValue];
    }
    return -1;
}

@end
