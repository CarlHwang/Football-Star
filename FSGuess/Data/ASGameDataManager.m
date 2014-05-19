//
//  ASGameDataManager.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-15.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "JSONKit.h"

#import "ASGameDataManager.h"
#import "ASClubData.h"
#import "ASPlayerData.h"
#import "ASLeagueData.h"
#import "ASDatabaseMacros.h"

@interface ASGameDataManager()
@property (nonatomic,assign) NSDictionary *leagues;
@property (nonatomic,assign) NSDictionary *clubs;
@property (nonatomic,assign) NSDictionary *players;
@property (nonatomic,assign) NSDictionary *missionMatchings;

@end

@implementation ASGameDataManager
static ASGameDataManager *gameDataManager = nil;
+(ASGameDataManager *)getInstance{
    if (gameDataManager == nil) {
        gameDataManager = [[ASGameDataManager alloc] init];
    }
    return gameDataManager;
}

+(void)dropInstance{
    if (gameDataManager) {
        [gameDataManager release];
    }
    gameDataManager = nil;
}

-(id)init{
    self = [super init];
    if (self) {
        [self initialData];
    }
    return self;
}

-(void)initialData{
    [self initialPlayers];
    [self initializeMissionMatching];
}

-(void)initialPlayers{
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ASPlayerData" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    
    if (textFileContents == nil) {
        
        NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }
    NSDictionary *playerJsonObj = [textFileContents objectFromJSONString];
    NSDictionary *players = [playerJsonObj objectForKey:@"playerList"];
    
    for (NSString *sKey in [players allKeys]) {
        
        NSInteger ID = [[sKey substringFromIndex:1] integerValue];
        NSDictionary *playerInfo = [players objectForKey:sKey];
        NSString *name = [playerInfo objectForKey:@"name"];
        NSArray *tips = [playerInfo objectForKey:@"tips"];
        NSString *options = [playerInfo objectForKey:@"options"];

        ASPlayerData *playerData = [ASPlayerData createPlayerID:ID playerName:name questionList:tips options:options];
        [tempDict setObject:playerData forKey:sKey];
    }
    
    if ([tempDict count] > 0) {
        _players = [[NSDictionary alloc] initWithDictionary:tempDict];
    }
    
    [tempDict release];
    ASLog(@"%@",_players);
}

-(void)initializeMissionMatching{
    
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ASMissionData" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    
    if (textFileContents == nil) {
        
        NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }
    
    NSDictionary *matchJsonObj = [textFileContents objectFromJSONString];
    _missionMatchings = [[NSDictionary alloc] initWithDictionary:[matchJsonObj objectForKey:@"missionMatching"]];
    
//    NSMutableArray *MATCHDICT = [[[NSMutableArray alloc] init] autorelease];
////    for (id key in _players) {
////        [MATCHDICT addObject:key];
////    }
////    
//    
//    for (id key in _missionMatchings) {
//        
//        NSString *num = [_missionMatchings objectForKey:key];
//        ASPlayerData *player = [_players objectForKey:num];
//        BOOL hasPlayer = (player != nil);
//        
//        BOOL isRepeat = [MATCHDICT containsObject:num];
//        
//        
//        if (![num isEqualToString:@""]) {
//            if (!isRepeat) {
//                [MATCHDICT addObject:num];
//            }else{
//                ASLogOneArg(@"重复啦！！！！！！！！！！！！！！！！！！！！！！！！！！");
//                
//            }
//            
//            if (!hasPlayer) {
//                ASLog(@"没有这个人！！！！！！！！！！！！！！！！！！！！！！！！！！%@",num);
//            }
//        }
//    }
//    
//    ASLog(@"%@",MATCHDICT);
}

+(NSInteger)playerCount{
    return [[ASGameDataManager getInstance].missionMatchings count];
}

+(ASPlayerData *)playDataForMission:(NSInteger)iMission{
    ASGameDataManager *manager = [ASGameDataManager getInstance];
    NSString *sPlayerKeyNum = [manager.missionMatchings objectForKey:[NSString stringWithFormat:@"%d",iMission]];
    return [manager.players objectForKey:sPlayerKeyNum];
}

-(void)dealloc{
    [_leagues release];
    [_clubs release];
    [_players release];
    [_missionMatchings release];
    [super dealloc];
}

@end
