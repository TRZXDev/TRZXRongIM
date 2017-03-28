//
//  EOWalletAddCardTableViewCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletAddCardTableViewCell.h"

@implementation EOWalletAddCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addLabel.layer.cornerRadius = 6;
    self.addLabel.layer.masksToBounds = YES;
    
    self.addButton.layer.cornerRadius = 6;
    self.addButton.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
