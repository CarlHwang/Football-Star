//
//  ASLeagueData.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASLeagueData.h"

@interface ASLeagueData()
@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,copy) NSString *leagueName;
@end

@implementation ASLeagueData

+(ASLeagueData *)createLeagueID:(NSInteger)ID leagueName:(NSString *)sLeagueName{
    ASLeagueData *data = [[ASLeagueData alloc] init];
    data.ID = ID;
    data.leagueName = sLeagueName;
    return [data autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        _ID = -1;
        _leagueName = nil;
    }
    return self;
}

-(void)dealloc{
    [_leagueName release];
    [super dealloc];
}

@end
