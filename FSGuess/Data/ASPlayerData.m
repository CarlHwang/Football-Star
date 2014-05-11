//
//  ASPlayerData.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASPlayerData.h"

@interface ASPlayerData()
@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,copy) NSString *playerName;
@property(nonatomic,assign) NSMutableDictionary *brief;
@property(nonatomic,assign) NSMutableDictionary *detail;
@property(nonatomic,assign) NSMutableArray *options;
@end

@implementation ASPlayerData

+(ASPlayerData *)createPlayerID:(NSInteger)ID playerName:(NSString *)sPlayerName questionList:(NSArray *)list options:(NSString *)sOptions{
    ASPlayerData *data = [[ASPlayerData alloc] init];
    data.ID = ID;
    data.playerName = sPlayerName;
    [data initializeBrief:list];
    [data initializeDetail:list];
    [data initializeOptions:sOptions];
    return [data autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        _ID = -1;
        _playerName = nil;
        _brief = [[NSMutableDictionary alloc] initWithCapacity:4];
        _detail = [[NSMutableDictionary alloc] initWithCapacity:4];
        _options = [[NSMutableArray alloc] initWithCapacity:24];
    }
    return self;
}

-(NSString *)briefForIndex:(NSInteger)iIndex{
    NSString *result = [_brief objectForKey:[NSString stringWithFormat:@"%d",iIndex]];
    if ([result length] <= 0) {
        return nil;
    }
    return result;
}

-(NSString *)detailForIndex:(NSInteger)iIndex{
    NSString *result = [_detail objectForKey:[NSString stringWithFormat:@"%d",iIndex]];
    if ([result length] <= 0) {
        return nil;
    }
    return result;
}

-(NSArray *)options{
    return _options;
}

-(void)initializeBrief:(NSArray *)list{
    for (NSInteger iIndex=0; iIndex<4; iIndex++) {
        NSDictionary *briefDetailPair = [list objectAtIndex:iIndex];
        [_brief setObject:[briefDetailPair objectForKey:@"brief"] forKey:[NSString stringWithFormat:@"%d",iIndex]];
    }
}

-(void)initializeDetail:(NSArray *)list{
    for (NSInteger iIndex=0; iIndex<4; iIndex++) {
        NSDictionary *briefDetailPair = [list objectAtIndex:iIndex];
        [_detail setObject:[briefDetailPair objectForKey:@"detail"] forKey:[NSString stringWithFormat:@"%d",iIndex]];
    }
}

-(void)initializeOptions:(NSString *)sOption{
    for (NSInteger iIndex=0; iIndex<[sOption length]; iIndex++) {
        [_options addObject:[sOption substringWithRange:NSMakeRange(iIndex, 1)]];
    }
}

-(void)dealloc{
    [_playerName release];
    [_options release];
    [_brief release];
    [_detail release];
    [super dealloc];
}

@end
