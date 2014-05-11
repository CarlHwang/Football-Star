//
//  ASDetailTipsView.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDetailTipsView : UIView<UITextViewDelegate>

+(ASDetailTipsView *)detailTipsView;

-(void)setText:(NSString *)sText;

@end
