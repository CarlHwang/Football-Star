//
//  ASShowController.m
//  FSGuess
//
//  Created by CarlHwang on 14-2-20.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASShowController.h"
#import "ASMacros.h"
#import "ASImageManager.h"
#import "ASFunctions.h"
#import "ASExpandButton.h"
#import "ASGlobalDataManager.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "MobClick.h"

#define SHOWVIEW_ORIGIN_Y (DEVICE_BASIC_IPHONE() ? SHOWVIEW_ORIGIN_Y_IPHONE : 400)
#define SHOWVIEW_ORIGIN_Y_IPHONE (DEVICE_SCREEN_4INCHES() ? 250 : 200)

#define COIN_VIEW_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(90,46) : CGSizeMake(220,112))
#define COIN_VIEW_ORIGIN_Y (DEVICE_BASIC_IPHONE() ? COIN_VIEW_ORIGIN_Y_IPHONE : 800)
#define COIN_VIEW_ORIGIN_Y_IPHONE (DEVICE_SCREEN_4INCHES() ? 450 : 380)
#define COIN_VIEW_ORIGIN_X (DEVICE_BASIC_IPHONE() ? 10 : 25)

#define COIN_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(51,46) : CGSizeMake(126,112))
#define COIN_CLICK_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(60,53) : CGSizeMake(146,131))

#define COIN_LABEL_FONT_SIZE (DEVICE_BASIC_IPHONE() ? 20 : 48)

#define SHARE_BUTTON_SIZE COIN_BUTTON_SIZE
#define SHARE_CLICK_BUTTON_SIZE COIN_CLICK_BUTTON_SIZE
#define SHARE_BUTTON_ORIGIN_Y COIN_VIEW_ORIGIN_Y
#define SHARE_BUTTON_ORIGIN_X (DEVICE_BASIC_IPHONE() ? 260 : 620)

#define CONTINUE_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(120,72) : CGSizeMake(244,147))
#define CONTINUE_CLICK_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(120,72) : CGSizeMake(244,147))
#define CONTINUE_BUTTON_ORIGIN_Y (DEVICE_BASIC_IPHONE() ? COIN_VIEW_ORIGIN_Y - 12 : COIN_VIEW_ORIGIN_Y - 22)
#define CONTINUE_BUTTON_ORIGIN_X (DEVICE_BASIC_IPHONE() ? 110 : 280)

#define REVIEW_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(33,24) : CGSizeMake(82,59))
#define REVIEW_BUTTON_CENTER (DEVICE_BASIC_IPHONE() ? REVIEW_BUTTON_IPHONE_CENTER : CGPointMake(670,950))
#define REVIEW_BUTTON_IPHONE_CENTER (DEVICE_SCREEN_4INCHES() ? CGPointMake(285,528) : CGPointMake(285,440))


@interface ASShowController ()
@property (nonatomic,assign) UIImageView *showView;
@property (nonatomic,assign) UIView *coinView;
@property (nonatomic,assign) UILabel *coinLabel;
@property (nonatomic,assign) UIView *unterminateView;
@end

@implementation ASShowController

+(ASShowController *)createController{
    ASShowController *controller = [[ASShowController alloc] init];
    return [controller autorelease];
}

-(void)loadView{
    [super loadView];
    [self initializeShowView];
    [self initializeCoinView];
    [self initializeShareButton];
    [self initializeContinueButton];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:SHOW_PAGE];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([ASGlobalDataManager showRating]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%C如果喜欢我们的App，请给予我们五星评价鼓励一下吧。\n可获得30个金币奖励哦！", 0xE418] delegate:self cancelButtonTitle:@"残忍地拒绝" otherButtonTitles:@"现在去评价", nil];
        [alertView show];
        [alertView release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"现在去评价"]) {
        NSString *ratingURL;
        if ([ASFunctions systemVersionNotSmallerThan:7.0]) {
            ratingURL = @"itms-apps://itunes.apple.com/app/id838889890";
        }else{
            ratingURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=838889890";
        }
        
        NSURL *URL = [NSURL URLWithString:ratingURL];
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            
            [[UIApplication sharedApplication] openURL:URL];
            [ASGlobalDataManager setRewardCoinWhenBecomeActive:30];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，打开评价页失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }
    
    [ASGlobalDataManager disableShowRating];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:SHOW_PAGE];
}

-(void)initializeShareButton{
//    ASExpandButton *shareButton = [ASExpandButton createButtonWithOrgSize:SHARE_BUTTON_SIZE prsSize:SHARE_CLICK_BUTTON_SIZE center:CGPointMake(SHARE_BUTTON_ORIGIN_X+0.5*SHARE_BUTTON_SIZE.width, SHARE_BUTTON_ORIGIN_Y+0.5*SHARE_BUTTON_SIZE.height)];
//    [shareButton setOrgImageForName:AS_RS_ANSWERPAGE_SHARE_BUTTON prsImageForName:AS_RS_ANSWERPAGE_SHARE_BUTTONCLICK];
//    [self.view addSubview:shareButton];
}

-(void)initializeContinueButton{
    ASExpandButton *continueButton = [ASExpandButton createButtonWithOrgSize:CONTINUE_BUTTON_SIZE prsSize:CONTINUE_CLICK_BUTTON_SIZE center:CGPointMake(CONTINUE_BUTTON_ORIGIN_X+0.5*CONTINUE_BUTTON_SIZE.width, CONTINUE_BUTTON_ORIGIN_Y+0.5*CONTINUE_BUTTON_SIZE.height)];
    [continueButton setOrgImageForName:AS_RS_ANSWERPAGE_CONTINUE_BUTTON prsImageForName:AS_RS_ANSWERPAGE_CONTINUE_BUTTONCLICK];
    [continueButton addTarget:self action:@selector(continueNextQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
}

-(void)initializeShowView{
    _showView = [[UIImageView alloc] initWithImage:[ASImageManager imageForPath:AS_RS_ANSWERPAGE_AFRO_VIEW cacheIt:NO withType:IMAGE_RESOURCE_TYPE_SCREENHEIGHT]];
    [_showView setCenter:CGPointMake(self.view.frame.size.width/2, SHOWVIEW_ORIGIN_Y)];
    [self.view addSubview:_showView];
}

-(void)initializeCoinView{
    CGRect frame = CGRectMake(COIN_VIEW_ORIGIN_X, COIN_VIEW_ORIGIN_Y, COIN_VIEW_SIZE.width, COIN_VIEW_SIZE.height);
    _coinView = [[UIView alloc] initWithFrame:frame];
    ASExpandButton *coinButton = [ASExpandButton createButtonWithOrgSize:COIN_BUTTON_SIZE prsSize:COIN_CLICK_BUTTON_SIZE center:CGPointMake(COIN_BUTTON_SIZE.width/2, COIN_BUTTON_SIZE.height/2)];
    [coinButton setOrgImageForName:AS_RS_ANSWERPAGE_COIN_BUTTON prsImageForName:AS_RS_ANSWERPAGE_COIN_BUTTONCLICK];
    [_coinView addSubview:coinButton];
    _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(COIN_BUTTON_SIZE.width, 0, COIN_VIEW_SIZE.width-COIN_BUTTON_SIZE.width, COIN_VIEW_SIZE.height)];
    [_coinLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:COIN_LABEL_FONT_SIZE]];
    [_coinLabel setTextColor:[UIColor whiteColor]];
    [_coinLabel setBackgroundColor:[UIColor clearColor]];
    [_coinLabel setTextAlignment:NSTextAlignmentLeft];
    [_coinView addSubview:_coinLabel];
    [self.view addSubview:_coinView];
}

-(void)prepareUnterminateView{
    if (!_unterminateView) {
        _unterminateView = [[UIImageView alloc] initWithImage:[ASImageManager imageForPath:AS_RS_ENDINGPAGE cacheIt:NO withType:IMAGE_RESOURCE_TYPE_SCREENHEIGHT]];
        
        UIButton *previewButton = [[[UIButton alloc] init] autorelease];
        CGRect frame = CGRectZero;
        frame.size = REVIEW_BUTTON_SIZE;
        [previewButton setFrame:frame];
        [previewButton setCenter:REVIEW_BUTTON_CENTER];
        [previewButton setImage:[ASImageManager imageForPath:AS_RS_ABOUT_BACK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
        [previewButton addTarget:self action:@selector(gameOver) forControlEvents:UIControlEventTouchUpInside];
        
        [_unterminateView setUserInteractionEnabled:YES];
        [_unterminateView addSubview:previewButton];
    }
}

-(void)setCoinNumber:(NSInteger)iNum{
    NSString *sNum = [NSString stringWithFormat:@"+%d",iNum];
    [_coinLabel setText:sNum];
}

-(void)continueNextQuestion{
    if (_unterminateView) {
        [self.view addSubview:_unterminateView];
        [self.view bringSubviewToFront:_unterminateView];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)gameOver{
    [_delegate showControllerDidPressGameOver];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)send{
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:[ASImageManager imageForPath:AS_RS_BUTTON_LIGHT cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD]];
//    
//    UIImage* image = [ASImageManager imageForPath:AS_RS_BUTTON_LIGHT cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD];
//    WXImageObject *ext = [WXImageObject object];
//    ext.imageData = UIImagePNGRepresentation(image);
//
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneSession;
//    
//    [WXApi sendReq:req];
//    NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.gif"];
//    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    
    UIImage* image = [ASImageManager imageForPath:AS_RS_BUTTON_LIGHT cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD];
    NSData *imgData = UIImagePNGRepresentation(image);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:@"QQ互联测试"
                                                    description:@"QQ互联测试分享"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    ASLog(@"%d",sent);
}

-(void)setControllerType{
    self.pageType = __ASShowPage;
}


-(void)dealloc{
    ASLogFunction();
    [_coinView release];
    [_showView release];
    [_coinLabel release];
    [_unterminateView release];
    [super dealloc];
}
@end
