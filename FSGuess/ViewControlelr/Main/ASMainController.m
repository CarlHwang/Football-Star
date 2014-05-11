//
//  ASMainController.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-23.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASMainController.h"
#import "ASAboutController.h"
#import "ASLevelController.h"
#import "ASMacros.h"
#import "ASImageManager.h"
#import "ASExpandButton.h"
#import "MobClick.h"

#define START_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(200,76) : CGSizeMake(391,148))
#define START_BUTTON_ORIGIN (DEVICE_BASIC_IPHONE() ? START_BUTTON_IPHONE_ORIGIN : CGPointMake(131,44))
#define START_BUTTON_IPHONE_ORIGIN (DEVICE_SCREEN_4INCHES() ? CGPointMake(44,93.1) : CGPointMake(41,40))

#define ABOUT_BUTTON_LENGTH (DEVICE_BASIC_IPHONE() ? 34 : 75)
#define ABOUT_BUTTONCLICK_LENGTH (DEVICE_BASIC_IPHONE() ? 44: 95)
#define ABOUT_BUTTON_CENTER (DEVICE_BASIC_IPHONE() ? ABOUT_BUTTON_IPHONE_CENTER : CGPointMake(670,950))
#define ABOUT_BUTTON_IPHONE_CENTER (DEVICE_SCREEN_4INCHES() ? CGPointMake(285,528) : CGPointMake(285,440))

@interface ASMainController ()
@property(nonatomic,assign) UIImageView *backgroundImage;
@end

@implementation ASMainController

+(ASMainController *)mainController{
    ASMainController *controller = [[ASMainController alloc] init];
    return [controller autorelease];
}

-(id)init{
    self = [super init];
    if (nil != self) {

    }
    return self;
}

-(void)loadView{
    [super loadView];
    _backgroundImage = [[UIImageView alloc] initWithImage:[ASImageManager imageForPath:AS_RS_MAINPAGE_BACKGROUND cacheIt:NO withType:IMAGE_RESOURCE_TYPE_SCREENHEIGHT]];
    [_backgroundImage setUserInteractionEnabled:YES];
    [self.view addSubview:_backgroundImage];
    [self initializeSubviews];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:MAIN_PAGE];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:MAIN_PAGE];
}

-(void)initializeSubviews{
    UIButton *startButton = [[[UIButton alloc] init] autorelease];
    [startButton setBackgroundImage:[ASImageManager imageForPath:AS_RS_MAINPAGE_START_BUTTON cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[ASImageManager imageForPath:AS_RS_MAINPAGE_START_BUTTONCLICK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [startButton setFrame:[self frameForStartButton]];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImage addSubview:startButton];
    
    ASExpandButton *aboutButton = [ASExpandButton createButtonWithOrgSize:SQUARE_SIZE(ABOUT_BUTTON_LENGTH) prsSize:SQUARE_SIZE(ABOUT_BUTTONCLICK_LENGTH) center:ABOUT_BUTTON_CENTER];
    [aboutButton setOrgImageForName:AS_RS_MAINPAGE_ABOUT_BUTTON prsImageForName:AS_RS_MAINPAGE_ABOUT_BUTTONCLICK];
    [aboutButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImage addSubview:aboutButton];
}

-(CGRect)frameForStartButton{
    CGRect frame;
    frame.size = START_BUTTON_SIZE;
    frame.origin = START_BUTTON_ORIGIN;
    return frame;
}

-(void)startGame{
    ASLevelController *levelPage = [ASLevelController createController];
    [self.navigationController pushViewController:levelPage animated:NO];
    [levelPage autoEnterLatestMission];
}

-(void)showAbout{
    ASAboutController *aboutPage = [ASAboutController createController];
    [self.navigationController pushViewController:aboutPage animated:YES];
}

-(void)dealloc{
    [_backgroundImage release];
    [super dealloc];
}

@end

