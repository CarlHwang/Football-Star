//
//  ASSoundPlayer.h
//  FSGuess
//
//  Created by CarlHwang on 14-4-7.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASSoundPlayer : NSObject

+(ASSoundPlayer *)sharedPlayer;
+(void)playPressSound;
+(void)playCancelSound;
@end
