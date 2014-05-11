//
//  ASAfroView.h
//  FSGuess
//
//  Created by CarlHwang on 13-10-5.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAfroView : UIView

+(ASAfroView *)afroViewWithMission:(NSInteger)mission resource:(NSString *)resource;
+(ASAfroView *)afroViewWithResource:(NSString *)resource;

-(void)setMission:(NSInteger)mission;
-(NSInteger)mission;

@end
