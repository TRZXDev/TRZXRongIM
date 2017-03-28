//
//  NSString+MD5.h
//  TRZXWallet
//
//  Created by Rhino on 2017/2/20.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WalletMD5)

+ (NSString *)wallet_getMd5_32Bit_String:(NSString *)srcString isUppercase:(BOOL)isUppercase;

@end
