//
//  ASCaseButton.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASCaseButton.h"
#import "ASMacros.h"

@interface ASCaseButton()
@property (nonatomic,retain) UILabel *missionLabel;
@end

@implementation ASCaseButton
+(ASCaseButton *)createButtonWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center{
    ASCaseButton *button = [[ASCaseButton alloc] initWithOrgSize:orgSize prsSize:prsSize center:center];
    return [button autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        _missionLabel = nil;
        _opened = NO;
    }
    return self;
}

-(void)initializeMission{
    self.missionLabel = [[[UILabel alloc] initWithFrame:CASE_MISSION_VIEW_FRAME()] autorelease];
    [_missionLabel setTextAlignment:NSTextAlignmentCenter];
    [_missionLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_missionLabel];
}

-(void)setMission:(NSInteger)mission{
    _mission = mission;
    if (!_missionLabel) {
        [self initializeMission];
    }
    if (_mission+1 > 99) {
        [_missionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:AFRO_MISSION_FONTSIZE_3NUM]];
    }else{
        [_missionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:AFRO_MISSION_FONTSIZE_2NUM]];
    }
    [_missionLabel setText:[NSString stringWithFormat:@"%d", _mission+1]];
}

-(void)setOpened:(BOOL)opened{
    _opened = opened;
    if (_opened) {
        [self setOrgImageForName:AS_RS_CASE_OPEN prsImageForName:AS_RS_CASE_OPENCLICK];
    }else{
        [self setOrgImageForName:AS_RS_CASE_CLOSE prsImageForName:AS_RS_CASE_CLOSECLICK];
    }
    
}

-(void)dealloc{
    [_missionLabel release];
    [super dealloc];
}

@end
