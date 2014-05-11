//
//  ASImageManager.m
//  FootballStar
//
//  Created by CarlHwang on 13-9-28.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASImageManager.h"
#import "ASFunctionMacros.h"
#import "ASTypeMacros.h"

@interface ASImageManager()
@property(nonatomic,assign) NSMutableDictionary *imageCache;
@property(nonatomic,assign) NSMutableDictionary *soundCache;
@end

@implementation ASImageManager

static ASImageManager *imageManager = nil;
+(ASImageManager *)getInstance{
    if (imageManager == nil) {
        imageManager = [[ASImageManager alloc] init];
    }
    return imageManager;
}

-(id)init{
    self = [super init];
    if (nil != self) {
        _imageCache = [[NSMutableDictionary alloc] init];
        _soundCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+(UIImage *)imageForPath:(NSString *)sPath cacheIt:(BOOL)cache withType:(NSInteger)iType{
    ASImageManager *imageManager = [ASImageManager getInstance];
    UIImage *image = [imageManager imageForPath:sPath];
    if (image) {
        return image;
    }
    
    NSString *sImagePath;
    if (iType == IMAGE_RESOURCE_TYPE_NOTYPE) {
        sImagePath = [ASImageManager imagePathForNoType:sPath];
    }else{
        sImagePath = [ASImageManager imagePath:sPath forType:iType];
    }
    NSString *sFullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Resource/Image/%@",sImagePath] ofType:nil];
    image = [UIImage imageWithContentsOfFile:sFullPath];
    if (image && cache) {
        [imageManager cacheImage:image forPath:sPath];
    }

    return image;
}

+(NSData *)soundForPath:(NSString *)sPath cacheIt:(BOOL)cache{
    ASImageManager *imageManager = [ASImageManager getInstance];
    NSData *sound = [imageManager soundForPath:sPath];
    if (sound) {
        return sound;
    }
    
    NSString *sFullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Resource/Sound/%@",sPath] ofType:nil];
    sound = [NSData dataWithContentsOfFile:sFullPath];
    if (sound && cache) {
        [imageManager cacheSound:sound forPath:sPath];
    }
    
    return sound;
}

+(NSString *)imagePathForNoType:(NSString *)sPath{
    return [sPath stringByAppendingString:@"_3.5.png"];
}

+(NSString *)imagePath:(NSString *)sPath forType:(NSInteger)iType{
    NSString *sImagePath;
    if(DEVICE_BASIC_IPHONE()){
        if (iType == IMAGE_RESOURCE_TYPE_SCREENHEIGHT && DEVICE_SCREEN_4INCHES()) {
            sImagePath = [sPath stringByAppendingString:@"_4.png"];
        }else{
            sImagePath = [sPath stringByAppendingString:@"_3.5.png"];
        }
    }else{
        sImagePath = [sPath stringByAppendingString:@"_ipad.png"];
    }
    return sImagePath;
}

-(UIImage *)imageForPath:(NSString *)sPath{
    return [_imageCache objectForKey:sPath];
}

-(void)cacheImage:(UIImage *)image forPath:(NSString *)sPath{
    [_imageCache setObject:image forKey:sPath];
}

-(NSData *)soundForPath:(NSString *)sPath{
    return [_soundCache objectForKey:sPath];
}

-(void)cacheSound:(NSData *)data forPath:(NSString *)sPath{
    [_soundCache setObject:data forKey:sPath];
}

-(void)dealloc{
    [_imageCache release];
    [_soundCache release];
    [super dealloc];
}

@end
