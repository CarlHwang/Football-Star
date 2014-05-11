//
//  ASOptionKeyButton.m
//  FSGuess
//
//  Created by CarlHwang on 14-2-8.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASOptionKeyButton.h"
#import "ASMacros.h"
#import "ASImageManager.h"

@implementation ASOptionKeyButton

+(ASOptionKeyButton *)buttonWithFrame:(CGRect)frame{
    ASOptionKeyButton *button = [[ASOptionKeyButton alloc] initWithFrame:frame];
    [button initializeSubview];
    return [button autorelease];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initializeSubview{
    [super initializeSubview];
    //background image
    [self setBackgroundImage:[ASImageManager imageForPath:AS_RS_KEYBOARD_BUTTON cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
}

-(void)touchBegan{
    if (self.hidden) {
        return;
    }
    [super touchBegan];
}

-(void)touchMoveOut{
    if (self.hidden) {
        return;
    }
    [super touchMoveOut];
}

-(void)touchEnd{
    if (self.hidden) {
        return;
    }
    //ui effect
    [super touchEnd];
    [self setHidden:YES];
    //logical effect
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButton:)]) {
        [self.delegate didClickButton:self];
    }
}

-(void)touchWithObject:(id)object{
    if (self.hidden) {
        return;
    }
    //ui effect
    [super touchEnd];
    [self setHidden:YES];
    //logical effect
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButton:withObject:)]) {
        [self.delegate didClickButton:self withObject:object];
    }
}

@end
