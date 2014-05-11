//
//  ASGameController.m
//  FSGuess
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASGameController.h"
#import "ASOptionKeyboard.h"
#import "ASAnswerKeyboard.h"
#import "ASShakeButton.h"
#import "ASImageManager.h"
#import "ASMacros.h"
#import "ASTipsView.h"
#import "ASShareView.h"
#import "MobClick.h"
#import "MBProgressHUD.h"
#import "ASGameDataManager.h"
#import "ASPlayerData.h"
#import "ASCoinManager.h"
#import "ASRewardAuthData.h"
#import "ASRewardAuthManager.h"
#import "ASDetailTipsView.h"
#import "ASAnsweKeyButton.h"
#import "ASShareManager.h"
#import "ASNameOptionGenerator.h"
#import "ASGlobalDataManager.h"

#define COIN_VIEW_FONTSIZE (DEVICE_BASIC_IPHONE() ? 18:36)
#define REWARD_LABEL_FONTSIZE (DEVICE_BASIC_IPHONE() ? 12:24)
#define COIN_VIEW_ORIGIN_Y (DEVICE_BASIC_IPHONE() ? 5:2)

@interface ASGameController ()
@property (nonatomic,assign) NSInteger mission;
@property (nonatomic,retain) ASExpandButton *coinButton;
@property (nonatomic,assign) UIView *coinView;
@property (nonatomic,assign) UILabel *coinLabel;
@property (nonatomic,assign) UILabel *rewardLabel;
@property (nonatomic,retain) ASTipsView *tipsView;
@property (nonatomic,retain) ASOptionKeyboard *keyboard;
@property (nonatomic,retain) ASAnswerKeyboard *answerBoard;
@property (nonatomic,retain) ASShowController *showController;
@property (nonatomic,retain) ASShareView *shareView;
@property (nonatomic,retain) ASPurchaseView *purchaseView;
@property (nonatomic,assign) EBPurchase *purchaseTool;
@property (nonatomic,assign) BOOL hasPurchased;
@property (nonatomic,retain) ASRewardAuthData *RAData;
@property (nonatomic,retain) ASDetailTipsView *detailTipsView;
@property (nonatomic,assign) NSInteger indexOfDetailWillShow;
@property (nonatomic,retain) UIImage *screenShot;

#pragma mark - 广告相关
@property (nonatomic,assign) DMAdView *domonADBanner;
@property (nonatomic,assign) GADBannerView *googleADBanner;
@property (nonatomic,assign) NSMutableArray *adBanners;
@property (nonatomic,assign) NSInteger adIndicator;
@property (nonatomic,retain) NSTimer *adTimer;
@property (nonatomic,assign) ASButton *adCloseButton;
@end

@implementation ASGameController

+(ASGameController *)controllerWithMission:(NSInteger)iMission{
    ASGameController *controller = [[ASGameController alloc] init];
    controller.mission = iMission;
    return [controller autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        _purchaseTool = [[EBPurchase alloc] init];
        _adBanners = [[NSMutableArray alloc] init];
        _showController = nil;
        _shareView = nil;
        _purchaseView = nil;
        _RAData = nil;
        _indexOfDetailWillShow = -1;
        _adIndicator = 0;
    }
    return self;
}

-(void)dealloc{
    ASLogFunction();
    [_coinLabel release];
    [_coinButton release];
    [_coinView release];
    [_tipsView release];
    [_keyboard release];
    [_answerBoard release];
    [_showController release];
    [_shareView release];
    [_purchaseView release];
    [_purchaseTool release];
    [_rewardLabel release];
    [_RAData release];
    [_detailTipsView release];
    [_screenShot release];
    [_adBanners release];
    
    //AD BANNER
    [_adTimer release];
    [_adCloseButton release];
    
    _googleADBanner.rootViewController = nil;
    _googleADBanner.delegate = nil;
    _domonADBanner.rootViewController = nil;
    _domonADBanner.delegate = nil;
    [_googleADBanner release];
    [_domonADBanner release];
    
    [super dealloc];
}

-(void)loadView{
    [super loadView];
    [self initializeLightButton];
    [self initializeShareButton];
    [self initializeTrashButton];
    [self initializeTipsView];
    [self initializeKeyboard];
    [self initializeCoinView];
    [self initializeRewardLabel];
    [self initializeADBanner];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateView];

    _purchaseTool.delegate = self;
    _hasPurchased = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:GAME_PAGE];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:GAME_PAGE];
}

-(void)quit{
    [super quit];
    [_adTimer invalidate];
}

-(void)setControllerType{
    self.pageType = __ASGamePage;
}

#pragma mark - Initialize Widget（初始化时调用）
-(void)initializeADBanner{
    
    CGFloat screenWidth = DEVICE_BASIC_IPHONE() ? 320.0 : 768.0;
    
    //-------------------------------------
    // 1 - 多盟广告
    
    CGSize domobADSize = DEVICE_BASIC_IPHONE() ? DOMOB_AD_SIZE_320x50 : DOMOB_AD_SIZE_728x90;
    CGRect domobADFrame;
    domobADFrame.origin = CGPointMake((screenWidth-domobADSize.width)/2.0, 0);
    domobADFrame.size = domobADSize;
    
    _domonADBanner = [[DMAdView alloc] initWithPublisherId:DMMOB_PUBLISH_ID placementId:DMMOB_PLACEMENT_ID size:domobADSize autorefresh:NO];
    _domonADBanner.frame = domobADFrame;
    _domonADBanner.delegate = self;
    _domonADBanner.rootViewController = self;
    
    //-------------------------------------
    // 1 - 谷歌广告
    CGSize googleADSize = DEVICE_BASIC_IPHONE() ? GAD_SIZE_320x50 : GAD_SIZE_728x90;
    CGRect googleADFrame;
    googleADFrame.origin = CGPointMake((screenWidth-googleADSize.width)/2.0, 0);
    googleADFrame.size = googleADSize;
    
    _googleADBanner = [[GADBannerView alloc] initWithFrame:googleADFrame];
    _googleADBanner.adUnitID = ADMOB_ID;
    _googleADBanner.delegate = self;
    _googleADBanner.rootViewController = self;
    
    [_adBanners addObject:_domonADBanner];
    [_adBanners addObject:_googleADBanner];
    
    [self loadADRequest];
    
    CGRect closeButtonFrame = CGRectZero;
    closeButtonFrame.size = CGSizeMake(googleADSize.height, googleADSize.height);
    _adCloseButton = [[ASButton alloc] initWithFrame:closeButtonFrame];
    [_adCloseButton setBackgroundImage:[ASImageManager imageForPath:AS_RS_AD_BUTTON_CLOSE cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [_adCloseButton addTarget:self action:@selector(closeADBanner) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initializeTipsView{
    self.tipsView = [ASTipsView createView];
    [_tipsView setFrame:TIPS_VIEW_FRAME()];
    [_tipsView setDelegate:self];
    [self.view addSubview:_tipsView];
}

-(void)initializeLightButton{
    ASShakeButton *button = [ASShakeButton createButtonWithOrgSize:SQUARE_SIZE(LIGHT_BUTTON_LENGTH) prsSize:SQUARE_SIZE(LIGHTCLICK_BUTTON_LENGTH) center:LIGHT_BUTTON_CENTER shakeInterval:3.5];
    [button setOrgImageForName:AS_RS_BUTTON_LIGHT prsImageForName:AS_RS_BUTTON_LIGHTCLICK];
    [button addTarget:self action:@selector(light) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)initializeTrashButton{
    ASShakeButton *button = [ASShakeButton createButtonWithOrgSize:SQUARE_SIZE(TRASH_BUTTON_LENGTH) prsSize:SQUARE_SIZE(TRASHCLICK_BUTTON_LENGTH) center:TRASH_BUTTON_CENTER shakeInterval:4.2];
    [button setOrgImageForName:AS_RS_BUTTON_TRASH prsImageForName:AS_RS_BUTTON_TRASHCLICK];
    [button addTarget:self action:@selector(trash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)initializeShareButton{
    ASShakeButton *button = [ASShakeButton createButtonWithOrgSize:SQUARE_SIZE(SHARE_BUTTON_LENGTH) prsSize:SQUARE_SIZE(SHARECLICK_BUTTON_LENGTH) center:SHARE_BUTTON_CENTER shakeInterval:6.1];
    [button setOrgImageForName:AS_RS_BUTTON_SHARE prsImageForName:AS_RS_BUTTON_SHARECLICK];
    [button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)initializeCoinView{
    self.coinButton = [ASExpandButton createButtonWithOrgSize:SQUARE_SIZE(COIN_BUTTON_LENGTH) prsSize:SQUARE_SIZE(COINCLICK_BUTTON_LENGTH) center:COIN_BUTTON_CENTER];
    [_coinButton setOrgImageForName:AS_RS_BUTTON_COIN prsImageForName:AS_RS_BUTTON_COINCLICK];
    [_coinButton addTarget:self action:@selector(showPurchase) forControlEvents:UIControlEventTouchUpInside];
    
    _coinLabel = [[UILabel alloc] init];
    [_coinLabel setBackgroundColor:[UIColor clearColor]];
    [_coinLabel setTextAlignment:NSTextAlignmentCenter];
    [_coinLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:COIN_VIEW_FONTSIZE]];
    [_coinLabel setTextColor:[UIColor whiteColor]];
    [_coinLabel setUserInteractionEnabled:YES];
    UIGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPurchase)] autorelease];
    [_coinLabel addGestureRecognizer:recognizer];
    
    _coinView = [[UIView alloc] init];
    [self.navigationBar addSubview:_coinView];
}

-(void)initializeRewardLabel{
    self.rewardLabel = [[UILabel alloc] init];
    [_rewardLabel setFrame:CGRectMake(0, REWARD_LABEL_ORIGIN_Y, self.view.bounds.size.width, 36)];
    [_rewardLabel setTextAlignment:NSTextAlignmentCenter];
    [_rewardLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:REWARD_LABEL_FONTSIZE]];
    [_rewardLabel setTextColor:[UIColor whiteColor]];
    [_rewardLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_rewardLabel];
}

-(void)initializeKeyboard{
    self.keyboard = [ASOptionKeyboard keyboardWithRowNum:3 columnNum:8 sideLength:MAIN_KEYBOARD_SIDE_LENGTH];
    _keyboard.delegate = self;
    [self.view addSubview:_keyboard];
}

#pragma mark - refresh Widget（刷新时调用）
-(void)refreshRewardLabel{
    [_rewardLabel setText:[NSString stringWithFormat:@"答对该题可得奖励:%d金币",[self rewardOfLevel:[_RAData rewardLevel]]]];
}

-(void)refreshCoinView{
    [_coinButton removeFromSuperview];
    [_coinLabel removeFromSuperview];
    
    NSString *sCoinValue = [NSString stringWithFormat:@"%d",[ASCoinManager coinValue]];
    CGSize size = [sCoinValue sizeWithFont:[UIFont fontWithName:@"YuppySC-Regular" size:COIN_VIEW_FONTSIZE]];
    
    CGRect labelFrame;
    labelFrame.origin = CGPointMake(COIN_BUTTON_LENGTH, 0);
    labelFrame.size = CGSizeMake(size.width, COIN_BUTTON_LENGTH);
    [_coinLabel setFrame:labelFrame];
    [_coinLabel setText:sCoinValue];
    
    CGRect viewFrame;
    viewFrame.size = CGSizeMake(COIN_BUTTON_LENGTH+labelFrame.size.width, COIN_BUTTON_LENGTH);
    viewFrame.origin = CGPointMake(self.view.bounds.size.width-viewFrame.size.width-10, COIN_VIEW_ORIGIN_Y);
    [_coinView setFrame:viewFrame];
    
    [_coinView addSubview:_coinButton];
    [_coinView addSubview:_coinLabel];
}

-(void)refreshAnswerBoard:(NSString *)sAnswer{
    [_answerBoard removeFromSuperview];
    NSInteger iNum = [sAnswer length];
    self.answerBoard = [ASAnswerKeyboard keyboardWithCharaterNum:iNum sideLength:MAIN_KEYBOARD_SIDE_LENGTH];
    for (ASAnsweKeyButton *button in _answerBoard.buttonList) {
        if (button.enabled) {
            ASLogOneArg(@"可用");
        }else{
            ASLogOneArg(@"不可用");
        }
    }
    
    _answerBoard.delegate = self;
    [_answerBoard setCorrectAnswer:sAnswer];
    [self.view addSubview:_answerBoard];
    ASLog(@"%@",self.view.subviews);
}

//每一题重新开始时更新界面所有信息
-(void)refresh{
    //-------------------------------------
    // 1 - 先以答对的题目的关卡数mission来修改一些参数（如奖励）
    [self updateReward];
    
    //-------------------------------------
    // 2 - 更新关卡数，并刷新选关页
    _mission++;
    [self updateLevelPage];
    
    //-------------------------------------
    // 3 - 刷新界面
    [self updateView];
}

//updateReward将会在每次刷新时调用
-(void)updateReward{
    NSInteger iReward = [self rewardOfLevel:[_RAData rewardLevel]];
    if (iReward != 0) {
        [ASCoinManager addCoin:iReward];
    }
    
    [_RAData setRewardDisable];
    [[ASRewardAuthManager getInstance] updateData:_RAData forMission:_mission];
}

-(void)updateLevelPage{
    //刷新levelPage的信息（打开箱子）
    [_delegate gameController:self didStartMission:_mission];
}

//updateView将会在第一次进入界面和每次刷新时调用
-(void)updateView{
    //-------------------------------------//
    // 进入这个方法时，mission必须依据被更新    //
    //-------------------------------------//
    
    //-------------------------------------
    // 1. - 重新获取新的题目的raData
    self.RAData = [[ASRewardAuthManager getInstance] dataForMission:_mission];
    if (!_RAData) {
        [[self showController] prepareUnterminateView]; //取不到下一题了，设置准备未完待续页
        return;
    }
    
    //-------------------------------------
    // 2. - 刷新金币数和奖励数和题号
    [self.afroView setMission:_mission];
    [self refreshCoinView];
    [self refreshRewardLabel];
    
    //-------------------------------------
    // 3. - 更新playerData
    ASPlayerData *playerData = [ASGameDataManager playDataForMission:_mission];
    if (!playerData) {
        return;
    }
    
    //-------------------------------------
    // 4. - 刷新回答keyboard
    [_keyboard refreshButtonForContents:[ASNameOptionGenerator optionArrayForNameArray:[playerData options]]];
    [self refreshAnswerBoard:[playerData playerName]];
    
    //-------------------------------------
    // 5. - 刷新提示框
    for (NSInteger iIndex=0; iIndex<4; iIndex++) {
        BOOL hasDetail = [playerData detailForIndex:iIndex] != nil;
        [_tipsView setText:[playerData briefForIndex:iIndex] forIndex:iIndex hasDetail:hasDetail];
    }
}

-(NSInteger)rewardOfLevel:(NSInteger)iLevel{
    switch (iLevel) {
        case 0:
            return 5;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(ASShowController *)showController{
    if (!_showController) {
        self.showController = [ASShowController createController];
        _showController.delegate = self;
    }
    return _showController;
}

#pragma mark - Inner Method

-(void)light{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"显示一个正确答案（80金币）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
    [alertView setTag:1];
    [alertView show];
}

-(void)trash{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"去掉一个错误答案（30金币）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
    [alertView setTag:2];
    [alertView show];
}

-(void)share{
    //截图
    CGRect rect =self.view.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    self.screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!_shareView) {
        self.shareView = [ASShareView shareViewWithTitle:@"问问朋友"];
        [_shareView setDelegate:self];
    }
    [self.view addSubview:_shareView];
}

-(void)showPurchase{
    if(!_purchaseView) {
        self.purchaseView = [ASPurchaseView purchaseView];
        [_purchaseView setDelegate:self];
    }
    [self.view addSubview:_purchaseView];
}


-(void)showOneRight{
    BOOL success = [ASCoinManager substractCoin:80];
    if (!success) {
        [self showPurchase];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C提示",0xE018] message:@"抱歉，您没有足够的金币了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView setTag:99];
        [alertView show];
        [alertView release];
        return;
    }
    NSArray *unfillIndexs = [_answerBoard unfillContentIndexs];
    
    if ([unfillIndexs count] > 0) {
        NSInteger iRandom = arc4random() % [unfillIndexs count];
        NSInteger iRandomIndex = [[unfillIndexs objectAtIndex:iRandom] integerValue];
        NSString *sCharater = [[_answerBoard correctAnswer] substringWithRange:NSMakeRange(iRandomIndex, 1)];
        [_answerBoard setEnable:NO atIndex:iRandomIndex];
        [_keyboard autoclickForButtonContent:sCharater toAnwerIndex:iRandomIndex];
        [self refreshCoinView];
    }else{
        //进入这里表示当前所有空都被填满
        while (YES) {
            NSInteger iRandomIndex = arc4random() % [[_answerBoard correctAnswer] length];
            if ([_answerBoard isButtonEnabledAtIndex:iRandomIndex]) {
                //随机出一个非自动生成的空格，先自动取消这个空格的值
                [_answerBoard autoClickAtIndex:iRandomIndex];
                //再选择匹配这个空的正确值填进去
                NSString *sCharater = [[_answerBoard correctAnswer] substringWithRange:NSMakeRange(iRandomIndex, 1)];
                [_answerBoard setEnable:NO atIndex:iRandomIndex];
                [_keyboard autoclickForButtonContent:sCharater toAnwerIndex:iRandomIndex];
                [self refreshCoinView];
                break;
            }
        }
        return;
    }
}

-(void)deleteOneWrong{
    if (![_keyboard canHideButton]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C提示",0xE018] message:@"最多可去掉10个错误答案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView setTag:99];
        [alertView show];
        [alertView release];
        return;
    }
    
    BOOL success = [ASCoinManager substractCoin:30];
    if (!success) {
        [self showPurchase];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C提示",0xE018] message:@"抱歉，您没有足够的金币了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView setTag:99];
        [alertView show];
        [alertView release];
        return;
    }
    
    NSArray *unfillContents = [_answerBoard unfillContents];
    [_keyboard hideButtonExceptContents:unfillContents];
    [self refreshCoinView];
}

-(void)showDetailForIndex:(NSInteger)iIndex{
    ASPlayerData *playerData = [ASGameDataManager playDataForMission:_mission];
    [self showDetailViewWithText:[playerData detailForIndex:iIndex]];
}

-(void)transationForDetail{
    [_RAData addAuthForIndex:_indexOfDetailWillShow];
    [[ASRewardAuthManager getInstance] updateData:_RAData forMission:_mission];
    [self refreshRewardLabel];
    [self showDetailForIndex:_indexOfDetailWillShow];
    _indexOfDetailWillShow = -1;
}

#pragma mark
#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"取消"]) {
        return;
    }
    NSInteger tag = [alertView tag];
    switch (tag) {
        case 1:
            [self showOneRight];
            break;
        case 2:
            [self deleteOneWrong];
        case 3:
            if (_indexOfDetailWillShow >= 0) {
                [self transationForDetail];
                [[ASGlobalDataManager getInstance] setHasShowDetailAlert:YES];
            }
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark - ASShowControllerDelegate
-(void)showControllerDidPressGameOver{
    [self quit];
}

#pragma mark
#pragma mark - ASTipsViewDelegate
-(void)tipsView:(ASTipsView *)tipsView clickButtonAtIndex:(NSInteger)iIndex{
    BOOL alreadyAuth = [[[_RAData auths] objectAtIndex:iIndex] integerValue] == 1;
    if (alreadyAuth) {
        [self showDetailForIndex:iIndex];
    }else{
        _indexOfDetailWillShow = iIndex;
        if (![[ASGlobalDataManager getInstance] hasShowDetailAlert]) {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C提示",0xE018] message:@"查看详细资料会减少该关卡获得的奖励\n(确认后将不再出现该提示)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
            [alertView setTag:3];
            [alertView show];
        }else{
            [self transationForDetail];
        }
    }
    ASLog(@"%d",iIndex);
}

-(void)showDetailViewWithText:(NSString *)sText{
    if (!_detailTipsView) {
        self.detailTipsView = [ASDetailTipsView detailTipsView];
    }
    [_detailTipsView setText:sText];
    [self.view addSubview:_detailTipsView];
    

    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [_detailTipsView.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark
#pragma mark - ASZoomKeyboardDelegate
-(void)didClickKeyboard:(ASZoomKeyboard *)keyboard withObject:(id)object{
    if ([keyboard isKindOfClass:[ASOptionKeyboard class]]) {
        if (object) {
            if ([object isKindOfClass:[NSArray class]]) {
                id keyObject = [object objectAtIndex:0];
                NSNumber *insertIndex = [object objectAtIndex:1];
                [_answerBoard insertKeyObject:keyObject atIndex:[insertIndex integerValue]];
                if ([_answerBoard keyboardCompleted]) {
                    [_keyboard setUserInteractionEnabled:NO];
                }
            }else{
                [_answerBoard appendKeyObject:object];
                if ([_answerBoard keyboardCompleted]) {
                    [_keyboard setUserInteractionEnabled:NO];
                }
            }
        }
    }else if ([keyboard isKindOfClass:[ASAnswerKeyboard class]]){
        if (object) {
            [_keyboard cancelSelectKeyObject:object];
            if (![_answerBoard keyboardCompleted]) {
                [_keyboard setUserInteractionEnabled:YES];
            }
        }
    }
}

-(void)didVerifyAnswer:(ASZoomKeyboard *)keyboard withObject:(id)object{
    
    if ([keyboard isKindOfClass:[ASAnswerKeyboard class]]) {
        
        ASShowController *controller = [self showController];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        NSInteger iReward = [self rewardOfLevel:[_RAData rewardLevel]];
        [controller setCoinNumber:iReward];
        
        ASLogOneArg(@"回答正确，跳转下一题");
        [self refresh];
    }
}

#pragma mark
#pragma mark - ASShareViewDelegate
-(void)shareToWXSession{
    BOOL success = [ASShareManager shareToWXSessionWithImage:_screenShot];
    [self handleShareResult:success];
}

-(void)shareToWXTimeline{
    BOOL success = [ASShareManager shareToWXTimelineWithImage:_screenShot];
    [self handleShareResult:success];
}

-(void)shareToQQSession{
    BOOL success = [ASShareManager shareToQQSessionWithImage:_screenShot];
    [self handleShareResult:success];
}

-(void)shareToQQTimeline{
    BOOL success = [ASShareManager shareToQQTimelineWithImage:_screenShot];
    [self handleShareResult:success];
}

-(void)shareToWeibo{
    
}

-(void)handleShareResult:(BOOL)success{
    self.screenShot = nil;
    [_shareView removeFromSuperview];
    
    if (!success) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C提示",0xE018] message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView setTag:99];
        [alertView show];
        [alertView release];
    }
}

#pragma mark
#pragma mark - ASPurchaseViewDelegate
-(void)purchaseView:(ASPurchaseView *)purchaseView productId:(NSString *)productId{
    if (!productId) {
        ASLogOneArg(@"product id = nil");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C购买失败",0XE11A] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
    _hasPurchased = NO;
    if (![_purchaseTool requestProduct:productId]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内购被禁用" message:@"请到 \"设置-通用-访问限制\" 启用App内购买项目" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

#pragma mark
#pragma mark - EBPurchaseDelegate
-(NSInteger)coinPurchaseForLevel:(NSInteger)level{
    switch (level) {
        case 1:
            return 288;
        case 2:
            return 688;
        case 3:
            return 1888;
        case 4:
            return 4388;
        case 5:
            return 9888;
        default:
            return 0;
    }
    return 0;
}

-(void)requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription{
    if (productPrice != nil) {
        if (![_purchaseTool purchaseProduct:_purchaseTool.validProduct]){
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内购被禁用" message:@"请到 \"设置-通用-访问限制\" 启用App内购买项目" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [alertView release];
        }
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        ASLogOneArg(@"purchase stop: price = nil");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C购买失败",0XE11A] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
}

-(void)successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt{
    ASLogOneArg(@"successfulPurchase");
    
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (!_hasPurchased)
    {
        // If paid status has not yet changed, then do so now. Checking
        // isPurchased boolean ensures user is only shown Thank You message
        // once even if multiple transaction receipts are successfully
        // processed (such as past subscription renewals).
        
        _hasPurchased = YES;
        
        //-------------------------------------
        // 1 - Unlock the purchased content and update the app's stored settings.
        
        if ([productId hasPrefix:@"qiuxingcaidaodi.coin.level"]) {
            NSInteger level = [[productId substringFromIndex:[productId length]-1] integerValue];
            [ASCoinManager addCoin:[self coinPurchaseForLevel:level]];
            [self refreshCoinView];
        }
        
        //-------------------------------------
        // 2 - Notify the user that the transaction was successful.
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"购买成功,感谢您对我们的支持%C",0xE022] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [updatedAlert show];
        [updatedAlert release];
    }
}

-(void)failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{
    ASLogOneArg(@"failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C购买失败",0XE11A] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [failedAlert show];
    [failedAlert release];
}

-(void)incompleteRestore:(EBPurchase*)ebp{
    ASLogOneArg(@"incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C恢复失败",0XE11A] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [restoreAlert show];
    [restoreAlert release];
}

-(void)failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{
    ASLogOneArg(@"failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C购买失败",0XE11A] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [failedAlert show];
    [failedAlert release];
}

-(void)failedRequest{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%C购买失败",0XE11A] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [failedAlert show];
    [failedAlert release];
}

#pragma mark - 广告相关

-(void)loadADRequest{
    if ([_adBanners count] <= 0) {
        return;
    }
    
    NSInteger index = _adIndicator % [_adBanners count];
    id banner = [_adBanners objectAtIndex:index];
    
    if ([banner isKindOfClass:[GADBannerView class]]) {
        [(GADBannerView *)banner loadRequest:[GADRequest request]];
        
    }else if ([banner isKindOfClass:[DMAdView class]]) {
        [(DMAdView *)banner loadAd];
        
    }
    _adIndicator++;
    if (_adIndicator >= [_adBanners count]) {
        _adIndicator = 0;
    }
}

-(void)reloadADRequest{
    [_adTimer invalidate];
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loadADRequest) userInfo:nil repeats:NO];
}

-(void)clearADBanner{
    ASLogOneArg(@"关闭广告");
    [_adCloseButton removeFromSuperview];
    for (id banner in _adBanners) {
        [banner removeFromSuperview];
    }
}

-(void)closeADBanner{
    [self clearADBanner];
    [self reloadADRequest];
}

-(void)adViewDidReceiveAd:(GADBannerView *)view{
    ASLogOneArg(@"Received google ad successfully");
    [self clearADBanner];
    [_googleADBanner addSubview:_adCloseButton];
    [self.view addSubview:_googleADBanner];
    [self reloadADRequest];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    ASLog(@"Failed to receive google ad with error: %@", [error localizedFailureReason]);
    [self loadADRequest];
}

-(void)dmAdViewSuccessToLoadAd:(DMAdView *)adView{
    ASLogOneArg(@"Received domob ad successfully");
    [self clearADBanner];
    [_domonADBanner addSubview:_adCloseButton];
    [self.view addSubview:_domonADBanner];
    [self reloadADRequest];
}

-(void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error{
    ASLog(@"Failed to receive domob ad with error: %@", [error localizedFailureReason]);
    [self loadADRequest];
}


@end
