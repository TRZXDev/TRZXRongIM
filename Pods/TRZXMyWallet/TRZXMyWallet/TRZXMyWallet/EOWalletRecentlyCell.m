//
//  EOWalletRecentlyCell.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletRecentlyCell.h"

@implementation EOWalletRecentlyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dateLabel.hidden = YES;
}
- (void)setUpdateDate:(NSString *)updateDate{
    _updateDate = updateDate;
    self.dateLabel.hidden = NO;
    self.dateLabel.text = [NSString stringWithFormat:@"%@年",updateDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
