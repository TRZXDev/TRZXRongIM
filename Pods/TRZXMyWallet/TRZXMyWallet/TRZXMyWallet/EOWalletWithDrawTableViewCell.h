//
//  EOWalletWithDrawTableViewCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOWalletWithDrawTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseCardButton;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *msgYuELabel;

@end
