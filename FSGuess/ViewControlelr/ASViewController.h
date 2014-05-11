//
//  ASViewController.h
//  FSGuess
//
//  Created by CarlHwang on 14-1-1.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

typedef enum {
    __ASGamePage = 0,
    __ASLevelPage,
    __ASShowPage,
}ASControllerPage;

#import <UIKit/UIKit.h>
#import "ASAfroView.h"

@protocol ASControllerTypeAssert <NSObject>
-(void)setControllerType;
@end


@interface ASViewController : UIViewController

@property (nonatomic,assign) ASControllerPage pageType;
@property (nonatomic,retain,readonly) UIImageView *backgroundView;
@property (nonatomic,retain,readonly) UIImageView *navigationBar;
@property (nonatomic,retain,readonly) ASAfroView *afroView;

-(CGRect)contentFrame;
-(void)quit;

@end
