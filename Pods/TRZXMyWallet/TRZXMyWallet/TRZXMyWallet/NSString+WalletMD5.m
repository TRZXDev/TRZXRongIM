//
//  NSString+MD5.m
//  TRZXWallet
//
//  Created by Rhino on 2017/2/20.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "NSString+WalletMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WalletMD5)

//支持双加密方式
//32位MD5加密方式
+ (NSString *)wallet_getMd5_32Bit_String:(NSString *)srcString isUppercase:(BOOL)isUppercase{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    //    CC_MD5( cStr, strlen(cStr), digest );
    CC_MD5(cStr, (uint32_t)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    if (isUppercase) {
        return   [result uppercaseString];
    }else{
        return result;
    }
}

@end
