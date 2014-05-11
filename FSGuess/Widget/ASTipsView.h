//
//  ASTipsView.h
//  FSGuess
//
//  Created by CarlHwang on 13-10-1.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASTipsView;

@protocol ASTipsViewDelegate <NSObject>
@required
-(void)tipsView:(ASTipsView *)tipsView clickButtonAtIndex:(NSInteger)iIndex;
@end

@interface ASTipsView : UIView

+(ASTipsView *)createView;
-(void)setText:(NSString *)sText forIndex:(NSInteger)iIndex hasDetail:(BOOL)hasDetail;

@property(nonatomic,assign) id<ASTipsViewDelegate> delegate;

@end
