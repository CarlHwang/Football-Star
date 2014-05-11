//
//  ASPurchaseView.m
//  FSGuess
//
//  Created by CarlHwang on 14-3-6.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import "ASPurchaseView.h"

#import "ASImageManager.h"
#import "ASExpandButton.h"
#import "ASMacros.h"

#define BACKBOARD_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(240,350) : CGSizeMake(485,617))
#define PAYBUTTON_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(192,40) : CGSizeMake(329,67))
#define PAYBUTTON_INSET (DEVICE_BASIC_IPHONE() ? 50 : 100)
#define PAYBUTTON_GAP (DEVICE_BASIC_IPHONE() ? 15 : 25)
#define CLOSEBUTTON_LENGTH (DEVICE_BASIC_IPHONE() ? 31 : 63)
#define CLOSEBUTTON_CLICK_LENGTH (DEVICE_BASIC_IPHONE() ? 41 : 83)
#define TITLE_LABEL_SIZE (DEVICE_BASIC_IPHONE() ? CGSizeMake(100,25) : CGSizeMake(200,50))

#define PRODUCT_LABEL_HEIGHT (DEVICE_BASIC_IPHONE() ? 40 : 67)
#define PRODUCT_LABEL_ORIGIN_X (DEVICE_BASIC_IPHONE() ? 40 : 70)

#define PRICE_LABEL_HEIGHT PRODUCT_LABEL_HEIGHT
#define PRICE_LABEL_RIGHT_INSET (DEVICE_BASIC_IPHONE() ? 30 : 50)

#define PURCHASE_VIEW_TITLE_SIZE (DEVICE_BASIC_IPHONE() ? 18 : 36)
#define PURCHASE_BUTTON_TEXT_SIZE (DEVICE_BASIC_IPHONE() ? 16 : 32)

@interface ASPurchaseView()
@property (nonatomic,assign) NSArray *productId;
@property (nonatomic,assign) NSArray *productName;
@property (nonatomic,assign) NSArray *price;
@end

@implementation ASPurchaseView

+(ASPurchaseView *)purchaseView{
    ASPurchaseView *view = [[ASPurchaseView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view initializeSubView];
    return [view autorelease];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _productId = [[NSArray alloc] initWithObjects:
                       @"qiuxingcaidaodi.coin.level1",
                       @"qiuxingcaidaodi.coin.level2",
                       @"qiuxingcaidaodi.coin.level3",
                       @"qiuxingcaidaodi.coin.level4",
                       @"qiuxingcaidaodi.coin.level5",
                       nil];
        
        _productName = [[NSArray alloc] initWithObjects:
                        @"288",
                        @"688",
                        @"1888",
                        @"4388",
                        @"9888",
                        nil];
        _price = [[NSArray alloc] initWithObjects:@"￥6", @"￥12", @"￥30", @"￥68", @"￥128", nil];
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
    [backboard setImage:[ASImageManager imageForPath:AS_RS_PAY_BACKGROUND cacheIt:NO withType:IMAGE_RESOURCE_TYPE_PHONEORPAD]];
    [backboard setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [backboard setUserInteractionEnabled:YES];
    [self addSubview:backboard];
    
    
    for (NSInteger iIndex=0; iIndex<5; iIndex++) {
        UIButton *button = [[[UIButton alloc] init] autorelease];
        [button setBackgroundImage:[ASImageManager imageForPath:AS_RS_PAY_BUTTON cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateNormal];
        [button setBackgroundImage:[ASImageManager imageForPath:AS_RS_PAY_BUTTONCLICK cacheIt:YES withType:IMAGE_RESOURCE_TYPE_PHONEORPAD] forState:UIControlStateHighlighted];
        [button setFrame:[self frameForButtonWithIndex:iIndex]];
        [button setTag:iIndex];
        [button addTarget:self action:@selector(onclickPayButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //产品
        UILabel *productLabel = [[[UILabel alloc] initWithFrame:CGRectMake(PRODUCT_LABEL_ORIGIN_X, 0, 100, PRODUCT_LABEL_HEIGHT)] autorelease];
        [productLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:PURCHASE_BUTTON_TEXT_SIZE]];
        [productLabel setTextAlignment:NSTextAlignmentLeft];
        [productLabel setText:[_productName objectAtIndex:iIndex]];
        [productLabel setBackgroundColor:[UIColor clearColor]];
        [button addSubview:productLabel];
        
        //价钱
        UILabel *priceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width-PRICE_LABEL_RIGHT_INSET-100, 0, 100, PRICE_LABEL_HEIGHT)] autorelease];
        [priceLabel setFont:[UIFont boldSystemFontOfSize:PURCHASE_BUTTON_TEXT_SIZE]];
        [priceLabel setTextAlignment:NSTextAlignmentRight];
        [priceLabel setText:[_price objectAtIndex:iIndex]];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [button addSubview:priceLabel];
        
        [backboard addSubview:button];
    }
    
    CGPoint closeBtnCenter = CGPointMake(CGRectGetWidth(backboard.frame)-CLOSEBUTTON_LENGTH/2, CLOSEBUTTON_LENGTH/2);
    ASExpandButton *closeBtn = [ASExpandButton createButtonWithOrgSize:SQUARE_SIZE(CLOSEBUTTON_LENGTH) prsSize:SQUARE_SIZE(CLOSEBUTTON_CLICK_LENGTH) center:closeBtnCenter];
    [closeBtn setOrgImageForName:AS_RS_PAY_CLOSE_BUTTON prsImageForName:AS_RS_PAY_CLOSE_BUTTONCLICK];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [backboard addSubview:closeBtn];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:[self frameForTitleLabel]] autorelease];
    [titleLabel setCenter:CGPointMake(0.5*CGRectGetWidth(backboard.frame), 0.08*CGRectGetHeight(backboard.frame))];
    [titleLabel setText:@"商店"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"YuppySC-Regular" size:PURCHASE_VIEW_TITLE_SIZE]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [backboard addSubview:titleLabel];
}

-(void)close{
    [self removeFromSuperview];
}

-(void)onclickPayButton:(id)sender{
    NSInteger iIndex = [sender tag];
    [_delegate purchaseView:self productId:[_productId objectAtIndex:iIndex]];
}


-(CGRect)frameForTitleLabel{
    CGRect frame = CGRectZero;
    frame.size = TITLE_LABEL_SIZE;
    return frame;
}

-(CGRect)frameForBackboard{
    CGRect frame = CGRectZero;
    frame.size = BACKBOARD_SIZE;
    return frame;
}

-(CGRect)frameForButtonWithIndex:(NSInteger)iIndex{
    CGRect frame;
    frame.size = PAYBUTTON_SIZE;
    frame.origin = CGPointMake((BACKBOARD_SIZE.width-PAYBUTTON_SIZE.width)/2, PAYBUTTON_INSET+iIndex*(PAYBUTTON_SIZE.height+PAYBUTTON_GAP));
    return frame;
}

-(void)dealloc{
    [_productId release];
    [_price release];
    [_productName release];
    [super dealloc];
}

@end
