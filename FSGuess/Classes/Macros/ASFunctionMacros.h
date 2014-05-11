//
//  ASFunctionMacros.h
//  FootballStar
//
//  Created by CarlHwang on 13-9-27.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#define DEVICE_BASIC_IPHONE() [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define DEVICE_SCREEN_HEIGHT() [[UIScreen mainScreen] bounds].size.height
#define DEVICE_SCREEN_4INCHES() DEVICE_SCREEN_HEIGHT() > 480
#define SQUARE_SIZE(x) CGSizeMake(x,x)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)