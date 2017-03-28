//
//  EOWalletNoteTableViewCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EOWalletRecordModel;

static  NSString *noteIdentifier     = @"EOWalletNoteTableViewCell";

@interface EOWalletNoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong,nonatomic)EOWalletRecordModel *model;

@end
