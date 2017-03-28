//
//  YYSTYTableViewCell.m
//  TRZX
//
//  Created by 张江威 on 16/9/13.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXYYSTYTableViewCell.h"

@implementation TRZXYYSTYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.chakanBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
