//
//  EOChooseBankTableViewCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EOBankModel;

@interface EOChooseBankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (nonatomic,strong)EOBankModel *model;

@end
