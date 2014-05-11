//
//  ASShakeButton.m
//  FSGuess
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASShakeButton.h"
#import "ASImageManager.h"
#import "ASTypeMacros.h"
#import "ASResourceMacros.h"

@interface ASShakeButton()
@property(nonatomic,assign) NSTimeInterval interval;
@property(nonatomic,retain) NSTimer *timer;
@end

@implementation ASShakeButton

+(ASShakeButton *)createButtonWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center shakeInterval:(NSTimeInterval)interval{
    ASShakeButton *button = [[ASShakeButton alloc] initWithOrgSize:orgSize prsSize:prsSize center:center];
    [button setInterval:interval];
    [button initailizeTimer];
    return [button autorelease];
}

-(void)initailizeTimer{
    if (_interval <= 0) {
        _timer = nil;
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(shake) userInfo:nil repeats:YES];
}

-(void)shake{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    shake.fromValue = [NSNumber numberWithFloat:-0.3];
    shake.toValue = [NSNumber numberWithFloat:+0.3];
    shake.duration = 0.1;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 4;
    
    [self.layer addAnimation:shake forKey:@"imageView"];
    self.alpha = 1.0;
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}

-(void)removeFromSuperview{
    [_timer invalidate];
    [super removeFromSuperview];
}

-(void)dealloc{
    [_timer invalidate];
    [_timer release];
    [super dealloc];
}

@end
