//
//  ASClubData.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASLeagueData.h"
#import "ASClubData.h"

@interface ASClubData()
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *clubName;
@end

@implementation ASClubData

+(ASClubData *)createClubID:(NSInteger)ID clubName:(NSString *)sClubName{
    ASClubData *data = [[ASClubData alloc] init];
    data.ID = ID;
    data.clubName = sClubName;
    return [data autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        _ID = -1;
        _clubName = nil;
    }
    return self;
}

-(void)dealloc{
    [_clubName release];
    [super dealloc];
}

@end
