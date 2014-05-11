//
//  ASCaseButton.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASExpandButton.h"

@interface ASCaseButton : ASExpandButton

+(ASCaseButton *)createButtonWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center;

@property (nonatomic,assign) NSInteger mission;
@property (nonatomic,assign) BOOL opened;

@end
