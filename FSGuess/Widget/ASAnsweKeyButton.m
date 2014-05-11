//
//  ASAnsweKeyButton.m
//  FSGuess
//
//  Created by CarlHwang on 14-2-8.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASAnsweKeyButton.h"
#import "ASImageManager.h"
#import "ASMacros.h"

@implementation ASAnsweKeyButton

+(ASAnsweKeyButton *)buttonWithFrame:(CGRect)frame{
    ASAnsweKeyButton *button = [[ASAnsweKeyButton alloc] initWithFrame:frame];
    [button initializeSubview];
    return [button autorelease];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.buttonSoundType = ASButtonSoundTypeCancel;
    }
    return self;
}

-(void)initializeSubview{
    [super initializeSubview];
    //background image
    [self setBackgroundImage:[ASImageManager imageForPath:AS_RS_KEYBOARD_BUTTON cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
}

-(void)touchBegan{
    [super touchBegan];
}

-(void)touchMoveOut{
    [super touchMoveOut];
}

-(void)touchEnd{
    [super touchEnd];
    //ui effect
    [self setContent:nil];
    //logical effect
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonNum:)]) {
        [self.delegate didClickButtonNum:[self buttonNum]];
    }
}


@end
