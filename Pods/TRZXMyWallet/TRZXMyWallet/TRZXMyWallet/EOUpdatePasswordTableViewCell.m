//
//  EOUpdatePasswordTableViewCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOUpdatePasswordTableViewCell.h"
#import "TRZXWalletMacro.h"

@implementation EOUpdatePasswordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = WalletzideColor;
    self.lineView0.backgroundColor = WalletzideColor;
    self.bgView.cornerRadius = 6;

    self.sendCodeButton.cornerRadius = 11;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
