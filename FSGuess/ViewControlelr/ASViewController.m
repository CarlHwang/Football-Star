//
//  ASViewController.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-1.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASViewController.h"
#import "ASExpandButton.h"
#import "ASImageManager.h"
#import "ASMacros.h"

@interface ASViewController ()
@property (nonatomic,retain) ASAfroView *afroView;
@property (nonatomic,retain) UIImageView *backgroundView;
@property (nonatomic,retain) UIImageView *navigationBar;
@property (nonatomic,assign) NSArray *backButtonResources;
@property (nonatomic,assign) NSArray *backButtonClickResources;
@property (nonatomic,assign) NSArray *navigationBarResources;
@property (nonatomic,assign) NSArray *afroViewResources;
@property (nonatomic,assign) NSArray *backgroundResources;
@end

@implementation ASViewController

-(id)init{
    self = [super init];
    if (self) {
        _backButtonResources = [[NSArray alloc] initWithObjects:AS_RS_BUTTON_BACK, AS_RS_BUTTON_BACK, AS_RS_NULL, nil];
        _backButtonClickResources = [[NSArray alloc] initWithObjects:AS_RS_BUTTON_BACKCLICK, AS_RS_BUTTON_BACKCLICK, AS_RS_NULL, nil];
        _navigationBarResources = [[NSArray alloc] initWithObjects:AS_RS_NAVIGATION_BAR, AS_RS_LEVELPAGE_NAVIGATION_BAR, AS_RS_NULL, nil];
        _backgroundResources = [[NSArray alloc] initWithObjects:AS_RS_GAME_BACKGROUND, AS_RS_LEVEL_BACKGROUND, AS_RS_ANSWER_BACKGROUND, nil];
        _afroViewResources = [[NSArray alloc] initWithObjects:AS_RS_AFRO_VIEW, AS_RS_LEVELPAGE_AFRO_VIEW, AS_RS_NULL, nil];
    }
    return self;
}

-(void)dealloc{
    ASLogFunction();
    [_afroView release];
    [_backgroundView release];
    [_navigationBar release];
    [_afroViewResources release];
    [_backgroundResources release];
    [_backButtonClickResources release];
    [_backButtonResources release];
    [_navigationBarResources release];
    [super dealloc];
}

-(void)loadView{
    [super loadView];
    [self initializeViews];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)initializeViews{
    //set controller type before doing initialization of the subviews
    [self setControllerType];
    [self initializeBackground];
    [self initializeNavigationBar];
    [self initializeAfroView];
    [self initializeBackButton];
}

-(void)quit{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initializeAfroView{
    NSString *resource = _afroViewResources[_pageType];
    if (!resource || [resource isEqualToString:AS_RS_NULL]) {
        self.afroView = nil;
        return;
    }
    self.afroView = [ASAfroView afroViewWithResource:resource];
    [_navigationBar addSubview:_afroView];
}

-(void)initializeBackButton{
    NSString *resource = _backButtonResources[_pageType];
    if (!resource || [resource isEqualToString:AS_RS_NULL]) {
        return;
    }
    ASExpandButton *button = [ASExpandButton createButtonWithOrgSize:SQUARE_SIZE(BACK_BUTTON_LENGTH) prsSize:SQUARE_SIZE(BACKCLICK_BUTTON_LENGTH) center:BACK_BUTTON_CENTER];
    [button setOrgImageForName:_backButtonResources[_pageType] prsImageForName:_backButtonClickResources[_pageType]];
    [button addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:button];
}

-(void)initializeBackground{
    NSString *resource = _backgroundResources[_pageType];
    if (!resource || [resource isEqualToString:AS_RS_NULL]) {
        self.backgroundView = nil;
        return;
    }
    self.backgroundView = [[[UIImageView alloc] initWithImage:[ASImageManager imageForPath:_backgroundResources[_pageType] cacheIt:NO withType:IMAGE_RESOURCE_TYPE_SCREENHEIGHT]] autorelease];
    [_backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:_backgroundView];
    [self.view sendSubviewToBack:_backgroundView];
}

-(void)initializeNavigationBar{
    NSString *resource = _navigationBarResources[_pageType];
    if (!resource || [resource isEqualToString:AS_RS_NULL]) {
        self.navigationBar = nil;
        return;
    }
    self.navigationBar = [[[UIImageView alloc] initWithImage:[ASImageManager imageForPath:_navigationBarResources[_pageType] cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD]] autorelease];
    CGRect frame = _navigationBar.frame;
    frame.origin = NAVIGATION_BAR_ORIGIN;
    [_navigationBar setFrame:frame];
    [_navigationBar setUserInteractionEnabled:YES];
    [self.view addSubview:_navigationBar];
}

-(void)setControllerType{
    //Polymorphism
    if (![self conformsToProtocol:@protocol(ASControllerTypeAssert)]) {
        NSException *e = [NSException exceptionWithName:@"ASControllerTypeNotSetException" reason:@"Method \'setControllerType\' has not been implemented yet" userInfo:nil];
        @throw e;
    }
}

-(CGRect)contentFrame{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = _afroView.frame.size.height;
    CGRect bounds = self.view.bounds;
    frame.size = CGSizeMake(bounds.size.width, bounds.size.height - frame.origin.y);
    return frame;
}

@end
