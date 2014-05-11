//
//  ASShareView.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-3.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASShareViewDelegate <NSObject>
@required
-(void)shareToWXSession;
-(void)shareToWXTimeline;
-(void)shareToQQSession;
-(void)shareToQQTimeline;
-(void)shareToWeibo;
@end

@interface ASShareView : UIView

+(ASShareView *)shareViewWithTitle:(NSString *)sTitle;

@property(nonatomic,assign) id<ASShareViewDelegate> delegate;

@end
