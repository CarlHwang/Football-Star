//
//  ASAboutController.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-23.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASAboutController.h"
#import "ASImageManager.h"
#import "ASMacros.h"
#import "ASExpandButton.h"
#import "MobClick.h"

#define REVIEW_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(33,24) : CGSizeMake(82,59))
#define REVIEW_BUTTON_CENTER (DEVICE_BASIC_IPHONE() ? REVIEW_BUTTON_IPHONE_CENTER : CGPointMake(670,950))
#define REVIEW_BUTTON_IPHONE_CENTER (DEVICE_SCREEN_4INCHES() ? CGPointMake(285,528) : CGPointMake(285,440))

@interface ASAboutController ()
@property(nonatomic,assign) UIImageView *aboutImage;
@end

@implementation ASAboutController

+(ASAboutController *)createController{
    ASAboutController *controller = [[ASAboutController alloc] init];
    return [controller autorelease];
}


-(void)pressBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initializeSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:About_PAGE];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:About_PAGE];
}

-(void)initializeSubviews{
    _aboutImage = [[UIImageView alloc] initWithImage:[ASImageManager imageForPath:AS_RS_ABOUT_PAGE cacheIt:NO withType:IMAGE_RESOURCE_TYPE_SCREENHEIGHT]];
    [_aboutImage setUserInteractionEnabled:YES];
    [self.view addSubview:_aboutImage];
    
    UIButton *previewButton = [[[UIButton alloc] init] autorelease];
    CGRect frame = CGRectZero;
    frame.size = REVIEW_BUTTON_SIZE;
    [previewButton setFrame:frame];
    [previewButton setCenter:REVIEW_BUTTON_CENTER];
    [previewButton setImage:[ASImageManager imageForPath:AS_RS_ABOUT_BACK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [previewButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [_aboutImage addSubview:previewButton];
}

-(void)quit{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    ASLogFunction();
    [_aboutImage release];
    [super dealloc];
}

@end
