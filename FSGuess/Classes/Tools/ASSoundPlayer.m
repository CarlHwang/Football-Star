//
//  ASSoundPlayer.m
//  FSGuess
//
//  Created by CarlHwang on 14-4-7.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "ASSoundPlayer.h"
#import "ASImageManager.h"


@interface ASSoundPlayer()
@property (nonatomic,assign) NSMutableArray *pressSoundPlayers;
@property (nonatomic,assign) NSMutableArray *cancelSoundPlayers;
@end

@implementation ASSoundPlayer

static ASSoundPlayer *sharedPlayer = nil;
+(ASSoundPlayer *)sharedPlayer{
    if (!sharedPlayer) {
        sharedPlayer = [[ASSoundPlayer alloc] init];
    }
    return sharedPlayer;
}

-(id)init{
    self = [super init];
    if (nil != self) {
        _pressSoundPlayers = [[NSMutableArray alloc] initWithCapacity:5];
        _cancelSoundPlayers = [[NSMutableArray alloc] initWithCapacity:5];
        [self initialize];
    }
    return self;
}

-(void)dealloc{
    [_cancelSoundPlayers release];
    [_pressSoundPlayers release];
    [super dealloc];
}

-(void)initialize{
    //保证不打断其他app的声音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    for (NSInteger index=0; index<5; index++) {
        AVAudioPlayer *player = [[[AVAudioPlayer alloc] initWithData:[ASImageManager soundForPath:@"press.wav" cacheIt:YES] error:nil] autorelease];
        if (player) {
            [player prepareToPlay];
            [_pressSoundPlayers addObject:player];
        }
    }
    for (NSInteger index=0; index<5; index++) {
        AVAudioPlayer *player = [[[AVAudioPlayer alloc] initWithData:[ASImageManager soundForPath:@"cancel.wav" cacheIt:YES] error:nil] autorelease];
        if (player) {
            [player prepareToPlay];
            [_cancelSoundPlayers addObject:player];
        }
    }
}

+(void)playPressSound{
    ASSoundPlayer *player = [ASSoundPlayer sharedPlayer];
    for (AVAudioPlayer *soundPlayer in player.pressSoundPlayers) {
        if (!soundPlayer.playing) {
            [soundPlayer play];
            return;
        }
    }
}

+(void)playCancelSound{
    ASSoundPlayer *player = [ASSoundPlayer sharedPlayer];
    for (AVAudioPlayer *soundPlayer in player.cancelSoundPlayers) {
        if (!soundPlayer.playing) {
            [soundPlayer play];
            return;
        }
    }
}

@end
