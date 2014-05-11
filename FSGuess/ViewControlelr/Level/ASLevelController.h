//
//  ASLevelController.h
//  FSGuess
//
//  Created by CarlHwang on 13-12-30.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASViewController.h"
#import "ASGameController.h"

@interface ASLevelController : ASViewController <ASControllerTypeAssert, ASGameControllerDelegate>

+(ASLevelController *)createController;

-(void)autoEnterLatestMission;

@end
