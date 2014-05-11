//
//  ASOptionKeyboard.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASZoomKeyboard.h"
#import "ASZoomKeyButton.h"

@class ASKeyObject;

@interface ASOptionKeyboard : ASZoomKeyboard<ASZoomButtonDelegate>

@property(nonatomic,retain) NSArray *contentList;

+(ASOptionKeyboard *)keyboardWithRowNum:(NSInteger)iRow columnNum:(NSInteger)iColumn sideLength:(NSInteger)iLength;

-(void)refreshButtonForContents:(NSArray *)contents;
-(void)cancelSelectKeyObject:(ASKeyObject *)object;
-(void)autoclickForButtonContent:(NSString *)sContent toAnwerIndex:(NSInteger)iAnswerIndex;
-(void)hideButtonExceptContents:(NSArray *)contents;
-(BOOL)canHideButton;
@end
