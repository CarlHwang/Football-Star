//
//  ASExpandButton.m
//  FSGuess
//
//  Created by CarlHwang on 14-1-1.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASExpandButton.h"
#import "ASImageManager.h"
#import "ASMacros.h"

@interface ASExpandButton()
@property (nonatomic,assign) CGSize orgSize;
@property (nonatomic,assign) CGSize prsSize;
@property (nonatomic,retain) UIImage *orgImage;
@property (nonatomic,retain) UIImage *prsImage;
@end

@implementation ASExpandButton

+(ASExpandButton *)createButtonWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center{
    ASExpandButton *button = [[ASExpandButton alloc] initWithOrgSize:orgSize prsSize:prsSize center:center];
    return [button autorelease];
}

-(id)initWithOrgSize:(CGSize)orgSize prsSize:(CGSize)prsSize center:(CGPoint)center{
    self = [super init];
    if (self) {
        self.orgSize = orgSize;
        self.prsSize = prsSize;
        self.frame = CGRectMake(0, 0, orgSize.width, orgSize.height);
        self.center = center;
    }
    return self;
}

-(void)setOrgImageForName:(NSString *)sOrgName prsImageForName:(NSString *)sPrsName{
    self.orgImage = [ASImageManager imageForPath:sOrgName cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD];
    self.prsImage = [ASImageManager imageForPath:sPrsName cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD];
    [self setBackgroundImage:_orgImage forState:UIControlStateNormal];
}

-(void)setHighlighted:(BOOL)highlighted{
    CGSize sizeWillTransform;
    UIImage *imageWillAppearence;
    if (highlighted) {
        sizeWillTransform = _prsSize;
        imageWillAppearence = _prsImage;
    }else{
        sizeWillTransform = _orgSize;
        imageWillAppearence = _orgImage;
    }
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = sizeWillTransform;
    CGPoint center = self.center;
    [self setFrame:frame];
    [self setCenter:center];
    [self setBackgroundImage:imageWillAppearence forState:UIControlStateNormal];
}

-(void)dealloc{
    [_orgImage release];
    [_prsImage release];
    [super dealloc];
}


@end
