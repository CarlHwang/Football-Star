//
//  ASExpandButton.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-1.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASButton.h"

@interface ASExpandButton : ASButton

+(ASExpandButton *)createButtonWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center;

-(id)initWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center;
-(void)setOrgImageForName:(NSString *)sOrgName prsImageForName:(NSString *)sPrsName;
@end
