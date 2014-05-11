//
//  ASZoomKeyboard.h
//  FootballStar
//
//  Created by CarlHwang on 13-9-24.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASZoomKeyboard;
@protocol ASZoomKeyboardDelegate <NSObject>
@optional
-(void)didClickKeyboard:(ASZoomKeyboard *)keyboard withObject:(id)object;
-(void)didVerifyAnswer:(ASZoomKeyboard *)keyboard withObject:(id)object;
@end

@interface ASZoomKeyboard : UIView

-(void)autoClickAtIndex:(NSInteger)iIndex;

#pragma mark - 子类方法，外部勿调用
-(void)autoClickAtIndex:(NSInteger)iIndex withObject:(id)object;

@property(nonatomic,assign) id <ASZoomKeyboardDelegate> delegate;
@property(nonatomic,assign) NSInteger rowNum;
@property(nonatomic,assign) NSInteger columnNum;
@property(nonatomic,assign) NSInteger sideLength;

@property(nonatomic,assign) NSMutableArray *buttonList;

@end
