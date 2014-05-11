//
//  ASAESEncryption.h
//  FSGuess
//
//  Created by CarlHwang on 14-3-17.
//  Copyright (c) 2014年 AfroStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

-(NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
-(NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end

@interface NSString (Encryption)

-(NSString *)AES256EncryptWithKey:(NSString *)key;
-(NSString *)AES256DecryptWithKey:(NSString *)key;

@end