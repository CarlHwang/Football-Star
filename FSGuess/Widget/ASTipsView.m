//
//  ASTipsView.m
//  FSGuess
//
//  Created by CarlHwang on 13-10-1.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASTipsView.h"
#import "ASMacros.h"
#import "ASImageManager.h"
#import "ASResourceMacros.h"
#import "ASTypeMacros.h"

#define TIPS_BUTTON_VERTICAL_PADDING  (DEVICE_BASIC_IPHONE() ? 20 : 20)
#define TIPS_BUTTON_HORIZON_PADDING  (DEVICE_BASIC_IPHONE() ? 40 : 40)
#define TIPS_BUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(133,60) : CGSizeMake(338,126))
#define DETAIL_VIEW_LENGTH (DEVICE_BASIC_IPHONE() ? 18 : 40)

@interface ASTipsView()

@end

@implementation ASTipsView

+(ASTipsView *)createView{
    ASTipsView *view = [[ASTipsView alloc] init];
    [view initialize];
    [view setUserInteractionEnabled:YES];
    return [view autorelease];
}

-(id)init{
    self = [super init];
    if (nil != self) {
        
    }
    return self;
}

-(void)initialize{
    for (NSInteger iIndex=0; iIndex<4; iIndex++) {
        [self initializeTipButton:iIndex];
    }
}

-(void)initializeTipButton:(NSInteger)iIndex{
    CGPoint detailViewCenter = [self centerForDetailView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:[self frameForButtonAtIndex:iIndex]];
    [button setBackgroundImage:[ASImageManager imageForPath:AS_RS_TIPS_BUTTON cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [button setBackgroundImage:[ASImageManager imageForPath:AS_RS_TIPS_BUTTONCLICK cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:TIPS_VIEW_FONTSIZE]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(onclickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:iIndex];
    
    UIImageView *detailView = [[[UIImageView alloc] initWithImage:[ASImageManager imageForPath:AS_RS_DETAIL_VIEW cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD]] autorelease];
    [detailView setCenter:detailViewCenter];
    [detailView setHidden:YES];
    [detailView setTag:99];
    [button addSubview:detailView];

    [self addSubview:button];
    [button release];
}

-(void)setText:(NSString *)sText forIndex:(NSInteger)iIndex hasDetail:(BOOL)hasDetail{
    UIButton *button = [[self subviews] objectAtIndex:iIndex];
    [button setTitle:sText forState:UIControlStateNormal];
    [button setUserInteractionEnabled:hasDetail];
    for (id view in [button subviews]) {
        if ([view tag] == 99) {
            [view setHidden:!hasDetail];
        }
    }
}

-(void)onclickButton:(id)sender{
    NSInteger iIndex = [sender tag];
    [_delegate tipsView:self clickButtonAtIndex:iIndex];
}

-(CGPoint)centerForDetailView{
    return CGPointMake(TIPS_BUTTON_SIZE.width-0.5*DETAIL_VIEW_LENGTH, 0.5*DETAIL_VIEW_LENGTH);
}

-(CGRect)frameForButtonAtIndex:(NSInteger)iIndex{
    NSInteger iRow = iIndex / 2;
    NSInteger iColumn = iIndex % 2;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat horizonInset = (bounds.size.width-TIPS_BUTTON_HORIZON_PADDING)/2-TIPS_BUTTON_SIZE.width;
    CGRect frame;
    frame.origin = CGPointMake(horizonInset+iColumn*(TIPS_BUTTON_SIZE.width+TIPS_BUTTON_HORIZON_PADDING), iRow*(TIPS_BUTTON_SIZE.height+TIPS_BUTTON_VERTICAL_PADDING));
    frame.size = TIPS_BUTTON_SIZE;
    return frame;
}

-(void)dealloc{
    ASLogFunction();
    [super dealloc];
}

@end
