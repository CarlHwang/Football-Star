//
//  ASRewardAuthData.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-20.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASRewardAuthData.h"


@interface ASRewardAuthData()
@property (nonatomic,assign) NSInteger rewardLevel;
@property (nonatomic,retain) NSMutableArray *auths;
@end

@implementation ASRewardAuthData

+(ASRewardAuthData *)data{
    ASRewardAuthData *data = [[ASRewardAuthData alloc] init];
    [data initializeAuthsArray];
    return [data autorelease];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInteger:_rewardLevel] forKey:@"level"];
    [aCoder encodeObject:_auths forKey:@"auths"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (nil != self) {
        self.rewardLevel = [[aDecoder decodeObjectForKey:@"level"] integerValue];
        self.auths = [aDecoder decodeObjectForKey:@"auths"];
    }
    return self;
}

-(void)dealloc{
    [_auths release];
    [super dealloc];
}

-(void)initializeAuthsArray{
    self.auths = [[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil] autorelease];
}

-(void)addAuthForIndex:(NSInteger)iIndex{
    
    //表示该题已经被答出，没必要再处理权限和奖励数据
    if (_rewardLevel > 10) {
        return;
    }
    
    [_auths replaceObjectAtIndex:iIndex withObject:[NSNumber numberWithInt:1]];
    _rewardLevel = 0;
    for (NSNumber *auth in _auths) {
        if ([auth integerValue] == 1) {
            _rewardLevel++;
        }
    }
}

-(void)setRewardDisable{
    _rewardLevel = 99;
    self.auths = [[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil] autorelease];
}

-(NSInteger)rewardLevel{
    return _rewardLevel;
}

-(NSArray *)auths{
    return _auths;
}

@end
