//
//  ASZoomKeyboard.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-24.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASZoomKeyboard.h"
#import "ASZoomKeyButton.h"
#import "ASMacros.h"



@interface ASZoomKeyboard()
@property(nonatomic,assign) BOOL underPress;
@property(nonatomic,assign) BOOL hasBeyondKeyboard;
@property(nonatomic,assign) NSInteger underPressIndex;
@end

@implementation ASZoomKeyboard

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (nil != self) {
        _columnNum = 0;
        _rowNum = 0;
        _sideLength = 0;
        _underPress = NO;
        _hasBeyondKeyboard = NO;
        _underPressIndex = -1;

        _buttonList = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 触摸事件

-(void)touchBeganAtIndex:(NSInteger)iIndex{
    ASZoomKeyButton *button = [self.buttonList objectAtIndex:iIndex];
    if (button.enabled) {
        [self bringSubviewToFront:button];
        [button touchBegan];
        _underPress = YES;
    }
}

-(void)touchMoveOutFromIndex:(NSInteger)iIndex{
    ASZoomKeyButton *button = [self.buttonList objectAtIndex:iIndex];
    if (button.enabled) {
        _underPress = NO;
        [button touchMoveOut];
        [button removeFromSuperview];
        [self insertSubview:button atIndex:iIndex];
    }
}

-(void)touchEndAtIndex:(NSInteger)iIndex{
    ASZoomKeyButton *button = [self.buttonList objectAtIndex:iIndex];
    if (button.enabled) {
        _underPress = NO;
        [button touchEnd];
        [button removeFromSuperview];
        [self insertSubview:button atIndex:iIndex];
    }
}

//for answerboard
-(void)autoClickAtIndex:(NSInteger)iIndex{
    ASZoomKeyButton *button = [self.buttonList objectAtIndex:iIndex];
    if (button.enabled) {
        _underPress = NO;
        [button touchEnd];
        [button removeFromSuperview];
        [self insertSubview:button atIndex:iIndex];
    }
}

//for optionboard
-(void)autoClickAtIndex:(NSInteger)iIndex withObject:(id)object{
    ASZoomKeyButton *button = [self.buttonList objectAtIndex:iIndex];
    if (button.enabled) {
        _underPress = NO;
        [button touchWithObject:object];
        [button removeFromSuperview];
        [self insertSubview:button atIndex:iIndex];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _underPressIndex = [self indexOfButtonForTouches:touches];
    [self touchBeganAtIndex:_underPressIndex];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self touchesBeyondKeyboard:touches]) {
        [self touchMoveOutFromIndex:_underPressIndex];
        return;
    }
    [self touchEndAtIndex:_underPressIndex];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self touchesBeyondKeyboard:touches]) {
        [self touchMoveOutFromIndex:_underPressIndex];
        _hasBeyondKeyboard = YES;
        return;
    }
    NSInteger iIndex = [self indexOfButtonForTouches:touches];
    if (_hasBeyondKeyboard) {
        [self touchMoveOutFromIndex:_underPressIndex];
        [self touchBeganAtIndex:iIndex];
        _underPressIndex = iIndex;
        _hasBeyondKeyboard = NO;
    }else if (iIndex != _underPressIndex) {
        [self touchMoveOutFromIndex:_underPressIndex];
        [self touchBeganAtIndex:iIndex];
        _underPressIndex = iIndex;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSInteger iIndex = [self indexOfButtonForTouches:touches];
    [self touchMoveOutFromIndex:iIndex];
}

#pragma mark - 内部方法
-(BOOL)touchesBeyondKeyboard:(NSSet *)touches{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (pt.x  > _columnNum*_sideLength-1 || pt.x < 1 || pt.y > _rowNum*_sideLength-1 || pt.y < 1) {
        return YES;
    }
    return NO;
}

-(NSInteger)indexOfButtonForTouches:(NSSet *)touches{
    CGPoint pt = [[touches anyObject] locationInView:self];
    
    NSInteger iColIndex = MIN(pt.x/_sideLength, _columnNum-1);
    NSInteger iRowIndex = MIN(pt.y/_sideLength, _rowNum-1);
    
    return (iRowIndex)*_columnNum + iColIndex;
}

-(void)dealloc{
    ASLogFunction();
    [_buttonList release];
    [super dealloc];
}

@end
