//
//  ASCoinManager.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-18.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCoinManager : NSObject

+(ASCoinManager *)getInstance;
+(void)dropInstance;

+(NSInteger)coinValue;
+(void)addCoin:(NSInteger)iValue;
+(BOOL)substractCoin:(NSInteger)iValue;

@end
