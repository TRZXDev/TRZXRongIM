//
//  EOWalletHeaderView.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOWalletHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//余额
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//收入
@property (weak, nonatomic) IBOutlet UILabel *withDrawLabel;//提现
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;//充值
@property (weak, nonatomic) IBOutlet UIButton *accountDetailButton;//账户详情
@property (weak, nonatomic) IBOutlet UIButton *withDrawButton;//提现按钮
@property (weak, nonatomic) IBOutlet UIButton *bankCardButton;//银行卡


@end
