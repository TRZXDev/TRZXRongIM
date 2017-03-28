//
//  EOWalletBankCardViewController.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "WalletBaseViewController.h"

/**
 *  银行卡
 */
@class EOBankModel;

@interface EOWalletBankCardViewController : WalletBaseViewController

@property (nonatomic,copy)void (^bankCallBack)(EOBankModel *);
/**
 *  选择银行卡type = 2    银行卡界面 type = 1
 */
@property (nonatomic,copy)NSString *type;

@property (nonatomic,assign)BOOL statusBarType;

@end

