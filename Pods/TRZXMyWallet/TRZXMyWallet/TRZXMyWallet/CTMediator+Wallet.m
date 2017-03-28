//
//  CTMediator+Wallet.m
//  TRZXWallet
//
//  Created by Rhino on 2017/2/24.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "CTMediator+Wallet.h"

NSString * const kCollegeTargetA = @"Wallet";
NSString * const kWalletActionHomeViewController              = @"Wallet_MyWalletViewController";


@implementation CTMediator (Wallet)


- (UIViewController *)wallet_HomeViewController:(NSDictionary *)params;{
    UIViewController *viewController = [self performTarget:kCollegeTargetA
                                                    action:kWalletActionHomeViewController
                                                    params:params
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
