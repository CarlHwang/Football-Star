//
//  ASAnswerKeyboard.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASZoomKeyButton.h"
#import "ASZoomKeyboard.h"

@class ASKeyObject;

@interface ASAnswerKeyboard : ASZoomKeyboard<ASZoomButtonDelegate>

@property (nonatomic,copy) NSString *correctAnswer;

+(ASAnswerKeyboard *)keyboardWithCharaterNum:(NSInteger)iNum sideLength:(NSInteger)iLength;

-(void)appendKeyObject:(ASKeyObject *)object;
-(void)insertKeyObject:(ASKeyObject *)object atIndex:(NSInteger)iIndex;
-(void)setCorrectAnswer:(NSString *)correctAnswer;
-(BOOL)keyboardCompleted;
-(void)setEnable:(BOOL)enabled atIndex:(NSInteger)iIndex;
-(BOOL)keyboardEnabledAtIndex:(NSInteger)iIndex;

-(NSInteger)indexForContent:(NSString *)sContent;
-(NSArray *)unfillContents;
@end
