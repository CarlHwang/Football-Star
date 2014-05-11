//
//  ASAfroView.m
//  FSGuess
//
//  Created by CarlHwang on 13-10-5.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASAfroView.h"
#import "ASMacros.h"
#import "ASImageManager.h"

@interface ASAfroView()
@property (nonatomic,retain) UILabel *missionLabel;
@property (nonatomic,assign) NSInteger mission;
@property (nonatomic,copy) NSString *resource;
@property (nonatomic,retain) UIImageView *backgroundView;
@end

@implementation ASAfroView

+(ASAfroView *)afroViewWithMission:(NSInteger)mission resource:(NSString *)resource{
    ASAfroView *view = [[ASAfroView alloc] init];
    [view setFrame:AFRO_VIEW_FRAME()];
    view.mission = mission;
    view.resource = resource;
    [view initialize];
    return [view autorelease];
}

+(ASAfroView *)afroViewWithResource:(NSString *)resource{
    ASAfroView *view = [[ASAfroView alloc] init];
    [view setFrame:AFRO_VIEW_FRAME()];
    view.resource = resource;
    [view initialize];
    return [view autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        _mission = -1;
        self.resource = nil;
    }
    return self;
}

-(void)initialize{
    [self initializeBackground];
    [self initializeMission];
}

-(void)initializeBackground{
    self.backgroundView = [[[UIImageView alloc] initWithImage:[ASImageManager imageForPath:_resource cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD]] autorelease];
    [self addSubview:_backgroundView];
    [self sendSubviewToBack:_backgroundView];
}

-(void)initializeMission{
    self.missionLabel = [[[UILabel alloc] initWithFrame:AFRO_MISSION_VIEW_FRAME()] autorelease];
    [_missionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:12]];
    [_missionLabel setTextAlignment:NSTextAlignmentCenter];
    [_missionLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_missionLabel];
}

-(void)setMission:(NSInteger)mission{
    _mission = mission+1;
    if (_mission > 99) {
        [_missionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:AFRO_MISSION_FONTSIZE_3NUM]];
    }else{
        [_missionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:AFRO_MISSION_FONTSIZE_2NUM]];
    }
    [_missionLabel setText:[NSString stringWithFormat:@"%d", _mission]];
}

-(void)dealloc{
    ASLogFunction();
    [_backgroundView release];
    [_missionLabel release];
    [_resource release];
    [super dealloc];
}

@end
