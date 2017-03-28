//
//  ZhuTiMoneyTableViewCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "ZhuTiMoneyTableViewCell.h"

@implementation ZhuTiMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_bjView.layer setCornerRadius:6];
    _bjView.layer.masksToBounds = YES;
    [_bobanBtn.layer setCornerRadius:15];
    _bobanBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
