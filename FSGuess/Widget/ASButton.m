//
//  ASButton.m
//  FSGuess
//
//  Created by CarlHwang on 13-9-29.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASButton.h"
#import "ASImageManager.h"
#import "ASSoundPlayer.h"

@interface ASButton()

@end

@implementation ASButton

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
//    [ASSoundPlayer playPressSound];
}

/* ------------------自己模拟highlight效果的实现方式
-(void)touchBegan{
    //多态吧骚年
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchBegan];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEnd];
    if (![self touchesBeyondFrame:touches]) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEnd];
}

-(BOOL)touchesBeyondFrame:(NSSet *)touches{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (pt.x  > CGRectGetWidth(self.frame) || pt.x  < 0 || pt.y  >CGRectGetHeight(self.frame) || pt.y  < 0) {
        return YES;
    }
    return NO;
}
*/

-(void)dealloc{
    ASLogFunction();
    [super dealloc];
}

@end
