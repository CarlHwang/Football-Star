//
//  ASShakeButton.h
//  FSGuess
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASExpandButton.h"

@interface ASShakeButton : ASExpandButton

+(ASShakeButton *)createButtonWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center shakeInterval:(NSTimeInterval)interval;


@end
