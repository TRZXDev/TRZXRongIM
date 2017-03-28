//
//  EOEditMailTableViewCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOEditMailTableViewCell.h"
#import "TRZXWalletMacro.h"

@implementation EOEditMailTableViewCell

- (void)awakeFromNib {
//    self.getCodeButton.layer.cornerRadius = self.getCodeButton.frame.size.height/2;
    [super awakeFromNib];
    // Initialization code
    
    self.getCodeButton.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
