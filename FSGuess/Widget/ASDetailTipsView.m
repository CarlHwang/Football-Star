//
//  ASDetailTipsView.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-26.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASDetailTipsView.h"
#import "ASImageManager.h"
#import "ASMacros.h"
#import "ASFunctions.h"

#define FONT_SIZE (DEVICE_BASIC_IPHONE() ? 20 : 40)

@interface ASDetailTipsView()
@property (nonatomic,assign) UITextView *textView;
@end

@implementation ASDetailTipsView

+(ASDetailTipsView *)detailTipsView{
    ASDetailTipsView *view = [[ASDetailTipsView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return [view autorelease];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)initialize{
    UIImageView *backgroundView = [[[UIImageView alloc] initWithImage:[ASImageManager imageForPath:AS_RS_DETAILTIPS_VIEW cacheIt:NO withType:IMAGE_RESOURCE_TYPE_SCREENHEIGHT]] autorelease];
    [self addSubview:backgroundView];
    
    CGFloat inset = [[UIScreen mainScreen] bounds].size.width*0.15;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(inset, inset, [[UIScreen mainScreen] bounds].size.width-2*inset, [[UIScreen mainScreen] bounds].size.height-2*inset)];
    _textView.delegate = self;
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setFont:[UIFont fontWithName:@"YuppySC-Regular" size:FONT_SIZE]];
    [_textView setTextAlignment:NSTextAlignmentLeft];
    [_textView setTextColor:[UIColor blackColor]];
    [_textView setEditable:YES];

    if ([ASFunctions systemVersionNotSmallerThan:7.0]) {
        [_textView setSelectable:NO];
    }
    
    [self addSubview:_textView];
    
    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
    [recognizer addTarget:self action:@selector(hide)];
    [self addGestureRecognizer:recognizer];
    
    //ios6下，如果设置editable=yes，那手势就会被屏蔽，所以要重新加一次
    if (![ASFunctions systemVersionNotSmallerThan:7.0]) {
        UITapGestureRecognizer *recognizer2 = [[[UITapGestureRecognizer alloc] init] autorelease];
        [recognizer2 addTarget:self action:@selector(hide)];
        [_textView addGestureRecognizer:recognizer2];
    }
}

-(void)setText:(NSString *)sText{
    [_textView setText:sText];
}

-(void)hide{
    [self removeFromSuperview];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

-(void)dealloc{
    [_textView release];
    [super dealloc];
}
@end
