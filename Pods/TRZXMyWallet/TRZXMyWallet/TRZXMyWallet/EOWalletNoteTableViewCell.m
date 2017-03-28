//
//  EOWalletNoteTableViewCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletNoteTableViewCell.h"
#import "EOWalletModel.h"
#import "TRZXWalletMacro.h"

@implementation EOWalletNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(EOWalletRecordModel *)mode
{
    _model = mode;
    
    self.noteDateLabel.text = mode.createDate;
    if ([mode.inOut isEqualToString:@"in"]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@",mode.amount];
    } else if ([mode.inOut isEqualToString:@"out"]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",mode.amount];
    }
    self.noteTypeLabel.text = mode.abs; //[self getTypeTitle:mode.type];
    
    if ([mode.status isEqualToString:@"1"]) {
        self.noteMsgLabel.text = @"审核中";
        self.noteMsgLabel.textColor = WalletRGBA(255.0, 137.0, 0, 1);
    }
    if ([mode.status isEqualToString:@"2"]) {
        self.noteMsgLabel.text = @"成功";
        self.noteMsgLabel.textColor = WalletRGBA(90.0, 203.0, 81.0, 1);
    }
    
    if ([mode.status isEqualToString:@"3"]) {
        self.noteMsgLabel.text = @"失败";
        self.noteMsgLabel.textColor = TRZXWalletMainColor;
    }
    
}

//交易类型 0=专家约见 ，1=账户提现，2=系统打款,3=充值,4=退款,5=购买视频,6=项目诚意金,7=润嗓费，8=问答费，9=推荐会员奖励
- (NSString *)getTypeTitle:(NSInteger)type {
    switch (type) {
        case 0:
            return @"专家约见";
            break;
        case 1:
            return @"钱包提现";
            break;
        case 2:
            return @"系统打款";
            break;
        case 3:
            return @"钱包充值";
            break;
        case 4:
            return @"退款";
            break;
        case 5:
            return @"购买视频";
            break;
        case 6:
            return @"项目诚意金";
            break;
        case 7:
            return @"润嗓费用";
            break;
        case 8:
            return @"问答费用";
            break;
        case 9:
            return @"推荐费";
            break;

        default:
            return @"";
            break;
            
    }
    return @"";
}




@end
