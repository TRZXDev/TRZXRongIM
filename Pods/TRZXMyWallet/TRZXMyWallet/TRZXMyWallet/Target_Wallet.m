//
//  Target_Wallet.m
//  TRZXWallet
//
//  Created by Rhino on 2017/2/24.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "Target_Wallet.h"

@implementation Target_Wallet


/**
 钱包首页
 
 @param params 参数
 @return ..
 */
- (UIViewController *)Action_Wallet_MyWalletViewController:(NSDictionary *)params{
    
    UIViewController *vc = [[NSClassFromString(@"EOWalletViewController") alloc]init];
    return vc;
}

@end
