//
//  ASGameController.h
//  FSGuess
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASViewController.h"
#import "ASZoomKeyboard.h"
#import "ASShareView.h"
#import "ASPurchaseView.h"
#import "ASShowController.h"
#import "ASTipsView.h"
#import "EBPurchase.h"
#import "GADBannerView.h"
#import "DMAdView.h"

@class ASGameController;

@protocol ASGameControllerDelegate <NSObject>
@required
-(void)gameController:(ASGameController *)controller didStartMission:(NSInteger)mission;
@end

@interface ASGameController : ASViewController<ASControllerTypeAssert,ASZoomKeyboardDelegate,ASShareViewDelegate,ASPurchaseViewDelegate,EBPurchaseDelegate,ASTipsViewDelegate,ASShowControllerDelegate, UIAlertViewDelegate, GADBannerViewDelegate, DMAdViewDelegate>

@property (nonatomic,assign) id<ASGameControllerDelegate> delegate;

+(ASGameController *)controllerWithMission:(NSInteger)iMission;

@end
