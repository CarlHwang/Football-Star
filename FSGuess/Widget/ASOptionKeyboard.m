//
//  ASOptionKeyboard.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASOptionKeyboard.h"
#import "ASOptionKeyButton.h"
#import "ASMacros.h"
#import "ASKeyObject.h"

@interface ASOptionKeyboard()
@property  (nonatomic,assign) NSInteger hideButtonNumber;
@end

@implementation ASOptionKeyboard

+(ASOptionKeyboard *)keyboardWithRowNum:(NSInteger)iRow columnNum:(NSInteger)iColumn sideLength:(NSInteger)iLength{
    ASOptionKeyboard *keyboard = [[ASOptionKeyboard alloc] initWithFrame:CGRectMake(MAIN_KEYBOARD_START_XCOORD, MAIN_KEYBOARD_START_YCOORD, iColumn*iLength, iRow*iLength)];
    [keyboard setColumnNum:iColumn];
    [keyboard setRowNum:iRow];
    [keyboard setSideLength:iLength];
    [keyboard initializeButton];
    keyboard.hideButtonNumber = 0;
    return [keyboard autorelease];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)initializeButton{
    for (int iRow=0; iRow<self.rowNum; iRow++) {
        for (int iColumn=0; iColumn<self.columnNum; iColumn++) {
            ASOptionKeyButton *button = [ASOptionKeyButton buttonWithFrame:[self frameForButtonWithRow:iRow column:iColumn]];
            [button setDelegate:self];
            [button setButtonNum:self.columnNum*iRow + iColumn];
            [self addSubview:button];
            [self.buttonList addObject:button];
        }
    }
}

-(void)refreshButtonForContents:(NSArray *)contents{
    for (id button in self.buttonList) {
        [button setHidden:NO];
        _hideButtonNumber = 0;
        [button setContent:[contents objectAtIndex:[button buttonNum]]];
    }
}

-(void)cancelSelectKeyObject:(ASKeyObject *)object{
    [[self.buttonList objectAtIndex:[[object num] integerValue]] setHidden:NO];
}

-(void)autoclickForButtonContent:(NSString *)sContent toAnwerIndex:(NSInteger)iAnswerIndex{
    for (NSInteger iIndex=0; iIndex<[self.buttonList count]; iIndex++) {
        ASOptionKeyButton *button = [self.buttonList objectAtIndex:iIndex];
        if ([[button content] isEqualToString:sContent]) {
            [self autoClickAtIndex:iIndex withObject:[NSNumber numberWithInteger:iAnswerIndex]];
            return;
        }
    }
}

-(void)hideButtonExceptContents:(NSArray *)contents{
    while (YES) {
        NSInteger iIndex = arc4random() % self.buttonList.count;
        ASOptionKeyButton *button = [self.buttonList objectAtIndex:iIndex];
        if (!button.hidden && ![contents containsObject:button.content]) {
            [button setHidden:YES];
            _hideButtonNumber++;
            break;
        }
    }
    return;
}

-(BOOL)canHideButton{
    return _hideButtonNumber < 10;
}

-(BOOL)keyboardEnabledForContent:(NSString *)sContent{
    for (NSInteger iIndex=0; iIndex<[self.buttonList count]; iIndex++) {
        ASOptionKeyButton *button = [self.buttonList objectAtIndex:iIndex];
        if ([[button content] isEqualToString:sContent] && !button.hidden) {
            return YES;
        }
    }
    return NO;
}

-(CGRect)frameForButtonWithRow:(NSInteger)iRow column:(NSInteger)iColumn{
    return CGRectMake(self.sideLength*iColumn, self.sideLength*iRow, self.sideLength, self.sideLength);
}

#pragma mark - ASZoomButtonDelegate
-(void)didClickButton:(ASZoomKeyButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickKeyboard:withObject:)]) {
        ASKeyObject *keyObject = [ASKeyObject keyObjectWithCharater:[button content] number:[NSNumber numberWithInteger:[button buttonNum]]];
        [self.delegate didClickKeyboard:self withObject:keyObject];
    }
}

-(void)didClickButton:(ASZoomKeyButton *)button withObject:(id)object{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickKeyboard:withObject:)]) {
        ASKeyObject *keyObject = [ASKeyObject keyObjectWithCharater:[button content] number:[NSNumber numberWithInteger:[button buttonNum]]];
        NSArray *param = [NSArray arrayWithObjects:keyObject, object, nil];
        [self.delegate didClickKeyboard:self withObject:param];
    }
}

-(void)dealloc{
    ASLogFunction();
    [_contentList release];;
    [super dealloc];
}

@end
