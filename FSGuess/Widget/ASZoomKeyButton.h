//
//  ASZoomKeyButton.h
//  FootballStar
//
//  Created by CarlHwang on 13-9-25.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASButton.h"

typedef enum {
    ASButtonSoundTypePress,
    ASButtonSoundTypeCancel,
}ASButtonSoundType;

@class ASZoomKeyButton;
@protocol ASZoomButtonDelegate <NSObject>
@optional
-(void)didClickButtonNum:(NSInteger)iNum;
-(void)didClickButtonText:(NSString *)sText;
-(void)didClickButton:(ASZoomKeyButton *)button;
-(void)didClickButton:(ASZoomKeyButton *)button withObject:(id)object;
-(void)didFinishBlinkButton;
@end

@interface ASZoomKeyButton : UIButton

@property(nonatomic,assign) NSInteger buttonNum;
@property(nonatomic,assign) id <ASZoomButtonDelegate> delegate;
@property (nonatomic,assign) ASButtonSoundType buttonSoundType;

-(void)initializeSubview;
-(void)touchBegan;
-(void)touchMoveOut;
-(void)touchEnd;
-(void)touchWithObject:(id)object;

-(void)setContent:(NSString *)sContent;
-(NSString *)content;
-(void)blink;
-(void)resetColor;
@end
