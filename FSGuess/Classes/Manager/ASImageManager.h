//
//  ASImageManager.h
//  FootballStar
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASImageManager : NSObject

+(UIImage *)imageForPath:(NSString *)sPath cacheIt:(BOOL)cache withType:(NSInteger)iType;
+(NSData *)soundForPath:(NSString *)sPath cacheIt:(BOOL)cache;

@end
