//
//  CTMediator+Wallet.h
//  TRZXWallet
//
//  Created by Rhino on 2017/2/24.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>

@interface CTMediator (Wallet)


/**
 钱宝首页

 @param params ..
 @return ...
 */
- (UIViewController *)wallet_HomeViewController:(NSDictionary *)params;

@end
