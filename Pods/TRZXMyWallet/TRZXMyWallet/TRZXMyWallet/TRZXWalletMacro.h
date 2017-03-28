
//
//  TRZXWalletMacro.h
//  TRZXWallet
//
//  Created by Rhino on 2017/2/20.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#ifndef TRZXWalletMacro_h
#define TRZXWalletMacro_h

#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
#import <TRZXKit/TRZXKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <TRZXLogin/Login.h>

#import "NSString+WalletMD5.h"
#import "EOMyWalletViewModel.h"
#import "UIView+Wallet_Frame.h"
/** 主题颜色 */
#define TRZXWalletMainColor [UIColor trzx_RedColor]

#define WalletRGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]


#define TRZXWalletBundle [NSBundle bundleForClass:[self class]]

//定义宏（限制输入内容）
#define kWalletAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kWalletAlpha     @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define kWalletNumbers   @"0123456789."
#define kWalletXNumbers   @"0123456789x"


#define WalletzideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define WalletbackColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define WalletBlackColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


#define mobleNumber 30000
#define passworldNumber 30001
#define testNumber 30002
#define nickNameNumber 30003
#define nameNumber 30004







#endif /* TRZXWalletMacro_h */
