//
//  ASShareView.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-3.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASShareView.h"
#import "ASMacros.h"
#import "ASImageManager.h"
#import "ASExpandButton.h"

#define BACKBOARD_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(300,150) : CGSizeMake(684,292))
#define SHAREBUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(46,46) : CGSizeMake(104,104))
#define CLOSEBUTTON_LENGTH (DEVICE_BASIC_IPHONE() ? 31 : 63)
#define CLOSEBUTTON_CLICK_LENGTH (DEVICE_BASIC_IPHONE() ? 41 : 83)
#define TITLE_LABEL_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(100,25) : CGSizeMake(200,50))
//#define LABEL_HEIGHT (DEVICE_BASIC_IPHONE() ? 23 : 52)
#define SHARE_LABEL_FONT (DEVICE_BASIC_IPHONE() ? 12 : 24)

@interface ASShareView()
@property(nonatomic,copy) NSString *title;
@end

@implementation ASShareView

+(ASShareView *)shareViewWithTitle:(NSString *)sTitle{
    ASShareView *view = [[ASShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.title = sTitle;
    [view initializeSubView];
    return [view autorelease];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = nil;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetGrayFillColor(context, 0.0f, 0.6f);
    CGContextAddRect(context, [[UIScreen mainScreen] bounds]);
    CGContextFillPath(context);
}

-(void)initializeSubView{
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *backboard = [[[UIImageView alloc] init] autorelease];
    [backboard setFrame:[self frameForBackboard]];
    [backboard setImage:[ASImageManager imageForPath:AS_RS_SHARE_BACKGROUND cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD]];
    [backboard setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [backboard setUserInteractionEnabled:YES];
    [self addSubview:backboard];
    
    
    //wxsession
    UIButton *wxSessionBtn = [[[UIButton alloc] init] autorelease];
    [wxSessionBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_WXSESSION_BUTTON cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [wxSessionBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_WXSESSION_BUTTONCLICK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [wxSessionBtn setFrame:[self frameForButtonWithIndex:0]];
    [wxSessionBtn addTarget:self action:@selector(onclickWXSession) forControlEvents:UIControlEventTouchUpInside];
    UILabel *wxSessionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(wxSessionBtn.frame), CGRectGetMaxY(wxSessionBtn.frame), CGRectGetWidth(wxSessionBtn.frame), 0.5*CGRectGetHeight(wxSessionBtn.frame))] autorelease];
    [wxSessionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:SHARE_LABEL_FONT]];
    [wxSessionLabel setTextAlignment:NSTextAlignmentCenter];
    [wxSessionLabel setBackgroundColor:[UIColor clearColor]];
    [wxSessionLabel setText:@"微信"];
    
    
    //wxtimeline
    UIButton *wxTimelineBtn = [[[UIButton alloc] init] autorelease];
    [wxTimelineBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_WXTIMELINE_BUTTON cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [wxTimelineBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_WXTIMELINE_BUTTONCLICK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [wxTimelineBtn setFrame:[self frameForButtonWithIndex:1]];
    [wxTimelineBtn addTarget:self action:@selector(onclickWXTimeline) forControlEvents:UIControlEventTouchUpInside];
    UILabel *wxTimelineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(wxTimelineBtn.frame), CGRectGetMaxY(wxTimelineBtn.frame), CGRectGetWidth(wxTimelineBtn.frame), 0.5*CGRectGetHeight(wxTimelineBtn.frame))] autorelease];
    [wxTimelineLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:SHARE_LABEL_FONT]];
    [wxTimelineLabel setTextAlignment:NSTextAlignmentCenter];
    [wxTimelineLabel setBackgroundColor:[UIColor clearColor]];
    [wxTimelineLabel setText:@"朋友圈"];
    
    
    //qqsession
    UIButton *qqSessionBtn = [[[UIButton alloc] init] autorelease];
    [qqSessionBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_QQSESSION_BUTTON cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [qqSessionBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_QQSESSION_BUTTONCLICK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [qqSessionBtn setFrame:[self frameForButtonWithIndex:2]];
    [qqSessionBtn addTarget:self action:@selector(onclickQQSession) forControlEvents:UIControlEventTouchUpInside];
    UILabel *qqSessionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(qqSessionBtn.frame), CGRectGetMaxY(qqSessionBtn.frame), CGRectGetWidth(qqSessionBtn.frame), 0.5*CGRectGetHeight(qqSessionBtn.frame))] autorelease];
    [qqSessionLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:SHARE_LABEL_FONT]];
    [qqSessionLabel setTextAlignment:NSTextAlignmentCenter];
    [qqSessionLabel setBackgroundColor:[UIColor clearColor]];
    [qqSessionLabel setText:@"QQ"];
    
    
    //qqtimeline
    UIButton *qqTimelineBtn = [[[UIButton alloc] init] autorelease];
    [qqTimelineBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_QQTIMELINE_BUTTON cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [qqTimelineBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_QQTIMELINE_BUTTONCLICK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [qqTimelineBtn setFrame:[self frameForButtonWithIndex:3]];
    [qqTimelineBtn addTarget:self action:@selector(onclickQQTimeline) forControlEvents:UIControlEventTouchUpInside];
    UILabel *qqTimelineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(qqTimelineBtn.frame), CGRectGetMaxY(qqTimelineBtn.frame), CGRectGetWidth(qqTimelineBtn.frame), 0.5*CGRectGetHeight(qqTimelineBtn.frame))] autorelease];
    [qqTimelineLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:SHARE_LABEL_FONT]];
    [qqTimelineLabel setTextAlignment:NSTextAlignmentCenter];
    [qqTimelineLabel setBackgroundColor:[UIColor clearColor]];
    [qqTimelineLabel setText:@"空间"];
    
    
    //weibo
    UIButton *weiboBtn = [[[UIButton alloc] init] autorelease];
    [weiboBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_WEIBO_BUTTON cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
    [weiboBtn setBackgroundImage:[ASImageManager imageForPath:AS_RS_WEIBO_BUTTONCLICK cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
    [weiboBtn setFrame:[self frameForButtonWithIndex:4]];
    [weiboBtn addTarget:self action:@selector(onclickWeibo) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weiboLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(weiboBtn.frame), CGRectGetMaxY(weiboBtn.frame), CGRectGetWidth(weiboBtn.frame), 0.5*CGRectGetHeight(weiboBtn.frame))] autorelease];
    [weiboLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:SHARE_LABEL_FONT]];
    [weiboLabel setTextAlignment:NSTextAlignmentCenter];
    [weiboLabel setBackgroundColor:[UIColor clearColor]];
    [weiboLabel setText:@"微博"];
    
    [backboard addSubview:wxSessionBtn];
    [backboard addSubview:wxTimelineBtn];
    [backboard addSubview:qqSessionBtn];
    [backboard addSubview:qqTimelineBtn];
    [backboard addSubview:weiboBtn];
    
    [backboard addSubview:wxSessionLabel];
    [backboard addSubview:wxTimelineLabel];
    [backboard addSubview:qqSessionLabel];
    [backboard addSubview:qqTimelineLabel];
    [backboard addSubview:weiboLabel];
    
    CGPoint closeBtnCenter = CGPointMake(CGRectGetWidth(backboard.frame)-CLOSEBUTTON_LENGTH/2, CLOSEBUTTON_LENGTH/2);
    ASExpandButton *closeBtn = [ASExpandButton createButtonWithOrgSize:SQUARE_SIZE(CLOSEBUTTON_LENGTH) prsSize:SQUARE_SIZE(CLOSEBUTTON_CLICK_LENGTH) center:closeBtnCenter];
    [closeBtn setOrgImageForName:AS_RS_SHARE_CLOSE_BUTTON prsImageForName:AS_RS_SHARE_CLOSE_BUTTONCLICK];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [backboard addSubview:closeBtn];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:[self frameForTitleLabel]] autorelease];
    [titleLabel setCenter:CGPointMake(0.5*CGRectGetWidth(backboard.frame), 0.2*CGRectGetHeight(backboard.frame))];
    [titleLabel setText:_title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:TIPS_VIEW_FONTSIZE]];
    [backboard addSubview:titleLabel];
}

-(void)close{
    [self removeFromSuperview];
}


-(CGRect)frameForBackboard{
    CGRect frame = CGRectZero;
    frame.size = BACKBOARD_SIZE;
    return frame;
}

-(CGRect)frameForButtonWithIndex:(NSInteger)iIndex{
    CGRect frame;
    frame.size = SHAREBUTTON_SIZE;
    CGFloat backboardWidth = BACKBOARD_SIZE.width;
    CGFloat buttonWidth = SHAREBUTTON_SIZE.width;
    CGFloat gap = (backboardWidth-5*buttonWidth)/6;
//    CGFloat gap = (backboardWidth-4*buttonWidth)/5;
    frame.origin = CGPointMake(iIndex*buttonWidth+(iIndex+1)*gap, (BACKBOARD_SIZE.height-SHAREBUTTON_SIZE.height)/2);
    return frame;
}

-(CGRect)frameForTitleLabel{
    CGRect frame = CGRectZero;
    frame.size = TITLE_LABEL_SIZE;
    return frame;
}

-(void)onclickWXSession{
    [_delegate shareToWXSession];
}

-(void)onclickWXTimeline{
    [_delegate shareToWXTimeline];
}

-(void)onclickQQSession{
    [_delegate shareToQQSession];
}

-(void)onclickQQTimeline{
    [_delegate shareToQQTimeline];
}

-(void)onclickWeibo{
    [_delegate shareToWeibo];
}

-(void)dealloc{
    [_title release];
    [super dealloc];
}

@end
