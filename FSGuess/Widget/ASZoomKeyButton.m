//
//  ASZoomKeyButton.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-25.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASZoomKeyButton.h"
#import "ASImageManager.h"
#import "ASMacros.h"
#import "ASSoundPlayer.h"

#define BLINK_TIME 2
#define TEXT_LABEL_FONT_ORGSIZE (DEVICE_BASIC_IPHONE() ? 18 : 40)
#define TEXT_LABEL_FONT_PRSSIZE (DEVICE_BASIC_IPHONE() ? 22 : 48)

@interface ASZoomKeyButton()
@property(nonatomic,retain) UILabel *textLabel;
@property(nonatomic,assign) CGSize orgSize;
@property(nonatomic,assign) CGSize prsSize;
@property(nonatomic,assign) NSInteger blinkCount;
@end

@implementation ASZoomKeyButton

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[[UILabel alloc] init] autorelease];
        self.userInteractionEnabled = NO;
        _orgSize = frame.size;
        _prsSize = CGSizeMake(_orgSize.width+10, _orgSize.height+10);
        _blinkCount = 0;
        _buttonSoundType = ASButtonSoundTypePress;
    }
    return self;
}

-(void)initializeSubview{
    //content label
    UIFont *font = [UIFont fontWithName:@"YuppySC-Regular" size:TIPS_VIEW_FONTSIZE];
    [_textLabel setFont:font];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setTextColor:[UIColor blackColor]];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [self resetContentFrameDidPressed:NO];
    [self addSubview:_textLabel];

}

-(void)resetContentFrameDidPressed:(BOOL)pressed{
    CGRect frame = CGRectZero;
    if (pressed) {
        frame.size = _prsSize;
        UIFont *font = [UIFont fontWithName:@"YuppySC-Regular" size:TEXT_LABEL_FONT_PRSSIZE];
        [_textLabel setFont:font];
    }else{
        frame.size = _orgSize;
        UIFont *font = [UIFont fontWithName:@"YuppySC-Regular" size:TEXT_LABEL_FONT_ORGSIZE];
        [_textLabel setFont:font];
    }
    [_textLabel setFrame:frame];

}

-(void)playSound{
    if (_buttonSoundType == ASButtonSoundTypeCancel) {
        [ASSoundPlayer playCancelSound];
    }else{
        [ASSoundPlayer playPressSound];
    }
}

-(void)touchBegan{
    CGRect frame;
    frame.origin = self.frame.origin;
    frame.size = _prsSize;
    CGPoint center = self.center;
    [self setFrame:frame];
    [self setCenter:center];
    [self resetContentFrameDidPressed:YES];
    [self playSound];
}

-(void)touchMoveOut{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = _orgSize;
    CGPoint center = self.center;
    [self setFrame:frame];
    [self setCenter:center];
    [self resetContentFrameDidPressed:NO];
    
}

-(void)touchEnd{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = _orgSize;
    CGPoint center = self.center;
    [self setFrame:frame];
    [self setCenter:center];
    [self resetContentFrameDidPressed:NO];
    
}

-(void)touchWithObject:(id)object{
    //多态
}

-(void)bringToAnswerIndex:(NSInteger)iIndex{
    
}

-(void)setContent:(NSString *)sContent{
    _textLabel.text = sContent;
}

-(NSString *)content{
    return _textLabel.text;
}

-(void)blink{
    _blinkCount = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(blinkRed) userInfo:nil repeats:NO];
}

-(void)blinkRed{
    [_textLabel setTextColor:[UIColor redColor]];
    if (_blinkCount < BLINK_TIME) {
        _blinkCount++;
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(blinkBlack) userInfo:nil repeats:NO];
        return;
    }
    [_delegate didFinishBlinkButton];
}

-(void)blinkBlack{
    [_textLabel setTextColor:[UIColor blackColor]];
    [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(blinkRed) userInfo:nil repeats:NO];

}

-(void)resetColor{
    [_textLabel setTextColor:[UIColor blackColor]];
}

-(void)dealloc{
    ASLogFunction();
    [_textLabel release];
    [super dealloc];
}

@end
