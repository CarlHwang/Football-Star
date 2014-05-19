//
//  ASLevelController.m
//  FSGuess
//
//  Created by CarlHwang on 13-12-30.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASLevelController.h"
#import "ASCaseButton.h"
#import "ASMacros.h"
#import "ASGameDataManager.h"
#import "ASGlobalDataManager.h"
#import "ASGameController.h"
#import "MobClick.h"

@interface ASLevelController ()
@property(nonatomic,retain) UIScrollView *pagingScrollView;
@property(nonatomic,assign) NSInteger gamesCount;
@end

@implementation ASLevelController

+(ASLevelController *)createController{
    ASLevelController *controller = [[ASLevelController alloc] init];
    return [controller autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        [self initializeData];
    }
    return self;
}

-(void)dealloc{
    ASLogFunction();
    [_pagingScrollView release];
    [super dealloc];
}

-(void)initializeData{
    _gamesCount = [ASGameDataManager playerCount];
}

-(void)loadView{
    [super loadView];
    [self initializePagingScrollView];
    [self initializeQuestionCase];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:LEVEL_PAGE];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:LEVEL_PAGE];
}

-(void)initializePagingScrollView{
    self.pagingScrollView = [[[UIScrollView alloc] initWithFrame:[self contentFrame]] autorelease];
    [_pagingScrollView setBackgroundColor:[UIColor clearColor]];
    [_pagingScrollView setPagingEnabled:YES];
    [_pagingScrollView setScrollEnabled:YES];
    [_pagingScrollView setContentSize:[self contentSizeForPagingScrollView]];
    [self.backgroundView addSubview:_pagingScrollView];
}


-(void)initializeQuestionCase{
    
    CGFloat xPadding = (_pagingScrollView.frame.size.width - 2*LEVEL_PAGE_CASE_INSET_X - LEVEL_PAGE_CASE_X_NUM*CASE_WIDTH)/(LEVEL_PAGE_CASE_X_NUM-1);
    CGFloat yPadding = (_pagingScrollView.frame.size.height - 2*LEVEL_PAGE_CASE_INSET_Y - LEVEL_PAGE_CASE_Y_NUM*CASE_HEIGHT)/(LEVEL_PAGE_CASE_Y_NUM-1);
    
    CGSize orgSize = CGSizeMake(CASE_WIDTH, CASE_HEIGHT);
    CGSize prsSize = CGSizeMake(CASECLICK_BUTTON_WIDTH, CASECLICK_BUTTON_HEIGHT);
    
    NSInteger lastestMission = [ASGlobalDataManager latestMission];
    
    for (NSInteger iMission = 0; iMission < _gamesCount; iMission++) {
        
        CGPoint caseCenter = [self caseCenterForNum:iMission xPadding:xPadding yPadding:yPadding size:orgSize];
        ASCaseButton *questionCase = [ASCaseButton createButtonWithOrgSize:orgSize prsSize:prsSize center:caseCenter];
        
        if (iMission > lastestMission) {
            [questionCase setOpened:NO];
        }else{
            [questionCase setOpened:YES];
        }
        
        [questionCase addTarget:self action:@selector(caseClick:) forControlEvents:UIControlEventTouchUpInside];
        [questionCase setMission:iMission];
        [_pagingScrollView addSubview:questionCase];
    }
}

-(CGPoint)caseCenterForNum:(NSInteger)iNum xPadding:(CGFloat)xPadding yPadding:(CGFloat)yPadding size:(CGSize)size{
    NSInteger iPage = iNum / (LEVEL_PAGE_CASE_X_NUM * LEVEL_PAGE_CASE_Y_NUM);
    NSInteger relateiveNum = iNum % (LEVEL_PAGE_CASE_X_NUM * LEVEL_PAGE_CASE_Y_NUM);
    CGPoint coord = [self coordinateForNum:relateiveNum];
    CGFloat pageX = LEVEL_PAGE_CASE_INSET_X + (size.width + xPadding)*coord.y + 0.5*size.width;
    CGFloat pageY = LEVEL_PAGE_CASE_INSET_Y + (size.height + yPadding)*coord.x + 0.5*size.height;
    return CGPointMake(pageX + iPage*self.view.bounds.size.width, pageY);
}

-(CGPoint)coordinateForNum:(NSInteger)iNum{
    NSInteger iCoordX = iNum / LEVEL_PAGE_CASE_X_NUM;
    NSInteger iCoordY = iNum % LEVEL_PAGE_CASE_X_NUM;
    return CGPointMake(iCoordX, iCoordY);
}

-(CGSize)contentSizeForPagingScrollView{
    NSInteger iPage = floorf(_gamesCount/(LEVEL_PAGE_CASE_X_NUM * LEVEL_PAGE_CASE_Y_NUM)) + 1;
    CGRect frame = _pagingScrollView.frame;
    CGSize size = frame.size;
    size.width = frame.size.width * iPage;
    return size;
}

-(void)setControllerType{
    self.pageType = __ASLevelPage;
}

-(void)autoEnterLatestMission{
    ASGameController *gameController = [ASGameController controllerWithMission:[ASGlobalDataManager latestMission]];
    gameController.delegate = self;
    [self.navigationController pushViewController:gameController animated:YES];
}

-(void)caseClick:(id)sender{
    ASCaseButton *button = (ASCaseButton *)sender;
    if ([button opened]) {
        ASGameController *gameController = [ASGameController controllerWithMission:[button mission]];
        gameController.delegate = self;
        [self.navigationController pushViewController:gameController animated:YES];
    }
}

-(void)gameController:(ASGameController *)controller didStartMission:(NSInteger)mission{
    if ([ASGlobalDataManager latestMission] >= mission || mission > _gamesCount) {
        return;
    }
    [ASGlobalDataManager setLatestMission:mission];
    for (id subview in _pagingScrollView.subviews) {
        if ([subview isKindOfClass:[ASCaseButton class]] && [subview mission] == mission) {
            [subview setOpened:YES];
            return;
        }
    }
}

@end
