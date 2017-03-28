//
//  EOWithDrawDetailViewController.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "WalletBaseViewController.h"

/**
 *  提现详情
 */

@class EOBankModel;

@interface EOWithDrawDetailViewController : WalletBaseViewController

@property (nonatomic,strong)EOBankModel *model;


@property (nonatomic,copy)NSString *money;//提现金额
@property (nonatomic,copy)NSString *mid;//提现id
@property (nonatomic,copy)NSString *bankNumber;
@end
