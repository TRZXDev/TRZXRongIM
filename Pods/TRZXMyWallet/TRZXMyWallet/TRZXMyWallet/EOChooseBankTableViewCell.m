//
//  EOChooseBankTableViewCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOChooseBankTableViewCell.h"
#import "EOWalletModel.h"

@implementation EOChooseBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(EOBankModel *)model
{
    _model = model;
    NSMutableString *weihaoStr = [NSMutableString stringWithString:model.accNo];
    [weihaoStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, model.accNo.length)];
    NSString *string =[weihaoStr substringFromIndex:weihaoStr.length - 4];
    
    self.bankName.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,string];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
