//
//  ASAnswerKeyboard.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASAnswerKeyboard.h"
#import "ASMacros.h"
#import "ASAnsweKeyButton.h"
#import "ASKeyObject.h"

#define MAX_ANSWER_LENGTH 10

@interface ASAnswerKeyboard()

@property (nonatomic,assign) NSMutableDictionary *inputContent;
@property (nonatomic,assign) NSInteger blinkCount;
@end

@implementation ASAnswerKeyboard

+(ASAnswerKeyboard *)keyboardWithCharaterNum:(NSInteger)iNum sideLength:(NSInteger)iLength{
    CGPoint origin;
    origin.x = ([UIScreen mainScreen].bounds.size.width - iNum*iLength) / 2;
    origin.y = ANSWER_KEYBOARD_START_YCOORD;
    ASAnswerKeyboard *keyboard = [[ASAnswerKeyboard alloc] initWithFrame:CGRectMake(origin.x, origin.y, iNum*iLength, 1*iLength)];
    [keyboard setColumnNum:iNum];
    [keyboard setRowNum:1];
    [keyboard setSideLength:iLength];
    [keyboard initializeButton];
    [keyboard initializeInputContent];
    return [keyboard autorelease];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _inputContent = [[NSMutableDictionary alloc] initWithCapacity:MAX_ANSWER_LENGTH];
        _blinkCount = 0;
    }
    return self;
}

-(void)initializeButton{
    for (int iRow=0; iRow<self.rowNum; iRow++) {
        for (int iColumn=0; iColumn<self.columnNum; iColumn++) {
            ASAnsweKeyButton *button = [ASAnsweKeyButton buttonWithFrame:[self frameForButtonWithRow:iRow column:iColumn]];
            [button setDelegate:self];
            [button setButtonNum:self.columnNum*iRow + iColumn];
            [self addSubview:button];
            [self.buttonList addObject:button];
        }
    }
}

-(void)initializeInputContent{
    NSNumber *num;
    [_inputContent removeAllObjects];
    for (NSInteger iIndex=0; iIndex<MAX_ANSWER_LENGTH; iIndex++) {
        num = [NSNumber numberWithInteger:iIndex];
        [_inputContent setObject:[NSNull null] forKey:num];
    }
}

-(CGRect)frameForButtonWithRow:(NSInteger)iRow column:(NSInteger)iColumn{
    return CGRectMake(self.sideLength*iColumn, self.sideLength*iRow, self.sideLength, self.sideLength);
}

-(void)blink{
    for (ASAnsweKeyButton *button in self.buttonList) {
        [button blink];
    }
}

-(void)resetButtonColor{
    for (ASAnsweKeyButton *button in self.buttonList) {
        [button resetColor];
    }
}

-(NSString *)answerString{
    NSMutableString *sAnswer = [[[NSMutableString alloc] initWithCapacity:MAX_ANSWER_LENGTH] autorelease];
    for (NSInteger iIndex=0; iIndex<MAX_ANSWER_LENGTH; iIndex++) {
        NSNumber *num = [NSNumber numberWithInteger:iIndex];
        id object = [_inputContent objectForKey:num];
        if (object == [NSNull null]) {
            break;
        }
        [sAnswer appendString:[(ASKeyObject *)object charater]];
    }
    return sAnswer;
}

-(void)verifyAnswer{
    NSString *sAnswer = [self answerString];
    if ([sAnswer length] != [_correctAnswer length]) {
        return;
    }
    //execute to here means all the block was filled
    if ([sAnswer isEqualToString:_correctAnswer]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didVerifyAnswer:withObject:)]) {
            [self.delegate didVerifyAnswer:self withObject:_inputContent];
        }
    }else{
        ASLogOneArg(@"答案错误:%@,正确答案:%@",sAnswer,_correctAnswer);
        [self setUserInteractionEnabled:NO];
        _blinkCount = 0;
        [self blink];
    }
}

-(void)appendKeyObject:(ASKeyObject *)object{
    for (NSInteger iIndex=0; iIndex<MAX_ANSWER_LENGTH; iIndex++) {
        NSNumber *num = [NSNumber numberWithInteger:iIndex];
        if ([_inputContent objectForKey:num] == [NSNull null]) {
            [_inputContent setObject:object forKey:num];
            [[self.buttonList objectAtIndex:iIndex] setContent:[object charater]];
            [self verifyAnswer];
            return;
        }
    }
}

-(void)insertKeyObject:(ASKeyObject *)object atIndex:(NSInteger)iIndex{
    NSNumber *num = [NSNumber numberWithInteger:iIndex];
    if ([_inputContent objectForKey:num] == [NSNull null]) {
        [_inputContent setObject:object forKey:num];
        [[self.buttonList objectAtIndex:iIndex] setContent:[object charater]];
        [self verifyAnswer];
    }
}

-(NSInteger)indexForContent:(NSString *)sContent{
    for (NSInteger iIndex = 0; iIndex < [_correctAnswer length]; iIndex++) {
        NSNumber *num = [NSNumber numberWithInteger:iIndex];
        id object = [_inputContent objectForKey:num];
        if (object == [NSNull null]) {
            continue;
        }
        if ([[object charater] isEqualToString:sContent]) {
            return iIndex;
        }
    }
    return -1;
}

//-(NSArray *)unfillContentIndexs{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (NSInteger iIndex=0; iIndex<[_correctAnswer length]; iIndex++) {
//        NSNumber *num = [NSNumber numberWithInteger:iIndex];
//        id object = [_inputContent objectForKey:num];
//        if (object == [NSNull null]) {
//            [array addObject:num];
//        }
//    }
//    return [array autorelease];
//}

-(NSArray *)unfillContents{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger iIndex=0; iIndex<[_correctAnswer length]; iIndex++) {
        NSString *substring = [_correctAnswer substringWithRange:NSMakeRange(iIndex, 1)];
        [array addObject:substring];
    }
    for (NSInteger iIndex=0; iIndex<[_correctAnswer length]; iIndex++) {
        NSNumber *num = [NSNumber numberWithInteger:iIndex];
        id object = [_inputContent objectForKey:num];
        if (object != [NSNull null]) {
            [array removeObject:[object charater]];
        }
    }
    return [array autorelease];
}

-(BOOL)keyboardCompleted{
    NSString *sAnswer = [self answerString];
    return [sAnswer length] == [_correctAnswer length];
}

-(void)setEnable:(BOOL)enabled atIndex:(NSInteger)iIndex{
    [[self.buttonList objectAtIndex:iIndex] setEnabled:enabled];
}

-(BOOL)keyboardEnabledAtIndex:(NSInteger)iIndex{
    return ((ASAnsweKeyButton *)[self.buttonList objectAtIndex:iIndex]).enabled;
}

#pragma mark - ASZoomButtonDelegate
-(void)didClickButtonNum:(NSInteger)iNum{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickKeyboard:withObject:)]) {
        NSNumber *num = [NSNumber numberWithInteger:iNum];
        id object = [_inputContent objectForKey:num];
        if (object != [NSNull null]) {
            ASKeyObject *copyObject = [ASKeyObject keyObjectWithCharater:[object charater] number:[object num]];
            [_inputContent setObject:[NSNull null] forKey:num];
            [self resetButtonColor];
            [self.delegate didClickKeyboard:self withObject:copyObject];
        }
    }
}

-(void)didFinishBlinkButton{
    _blinkCount++;
    if (_blinkCount == [self.buttonList count]) {
        [self setUserInteractionEnabled:YES];
    }
}

-(void)dealloc{
    ASLogFunction();
    [_correctAnswer release];
    [_inputContent release];
    [super dealloc];
}

@end
