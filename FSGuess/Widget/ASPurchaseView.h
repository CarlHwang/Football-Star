//
//  ASPurchaseView.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-6.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@class ASPurchaseView;

@protocol ASPurchaseViewDelegate <NSObject>
@required
-(void)purchaseView:(ASPurchaseView *)purchaseView productId:(NSString *)productId;
@end

@interface ASPurchaseView : UIView

+(ASPurchaseView *)purchaseView;

@property (nonatomic,assign) id<ASPurchaseViewDelegate> delegate;

@end
