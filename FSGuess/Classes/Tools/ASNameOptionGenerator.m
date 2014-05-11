//
//  ASNameOptionGenerator.m
//  FootballStarGuess
//
//  Created by CarlHwang on 13-9-20.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASNameOptionGenerator.h"

@interface ASNameOptionGenerator()

@end

@implementation ASNameOptionGenerator

+(NSArray *)optionArrayForNameArray:(NSArray *)nameArray{
    NSMutableArray *nameCopys = [[[NSMutableArray alloc] initWithArray:nameArray] autorelease];
    NSMutableArray *options = [[NSMutableArray alloc] init];
    for (NSUInteger i=[nameArray count]; i>0; i--) {
        int iRandom = arc4random() % i + 1;
        [options addObject:[nameCopys objectAtIndex:iRandom-1]];
        [nameCopys removeObjectAtIndex:iRandom-1];
    }
    return [options autorelease];
}

@end
