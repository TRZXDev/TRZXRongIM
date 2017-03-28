//
//  EOWalletBankCardTableViewCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletBankCardTableViewCell.h"
#import "EOWalletModel.h"

@implementation EOWalletBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cardBgView.layer.cornerRadius = 6;
    
}

- (void)setModel:(EOBankModel *)model
{
    _model = model;
    self.bankLabel.text = model.bankName;
    self.subtitleLabel.text = @"储蓄卡";
    
    NSMutableString *weihaoStr = [NSMutableString stringWithString:model.accNo];
    [weihaoStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, model.accNo.length)];
    NSString *string = [[NSString alloc]initWithFormat:@"*** **** **** **** %@",[weihaoStr substringFromIndex:weihaoStr.length - 4]];
    
    self.cardNumberlabel.text = string;
//    [self.cardPhotoImage sd_setImageWithURL:[NSURL URLWithString:model.bankLogo] placeholderImage:[UIImage imageNamed:@"展位图"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
