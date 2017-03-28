//
//  EOWalletWithDrawViewController.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "WalletBaseViewController.h"

/**
 *  提现
 */
@class EOBankModel;

@interface EOWalletWithDrawViewController : WalletBaseViewController


@property (nonatomic,copy)NSString *amout;//余额
@property (nonatomic,strong)EOBankModel *bankModel;
@property (nonatomic,copy)NSString *residual;//可提现额度

@end
