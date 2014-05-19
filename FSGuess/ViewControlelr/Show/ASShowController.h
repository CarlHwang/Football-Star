//
//  ASShowController.h
//  FSGuess
//
//  Created by CarlHwang on 14-2-20.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASViewController.h"

@class ASShowController;

@protocol ASShowControllerDelegate <NSObject>
@required
-(void)showControllerDidPressGameOver;
@end

@interface ASShowController : ASViewController<ASControllerTypeAssert, UIAlertViewDelegate>

@property (nonatomic,assign) id<ASShowControllerDelegate> delegate;

+(ASShowController *)createController;
-(void)setCoinNumber:(NSInteger)iNum;
-(void)prepareUnterminateView;

@end
