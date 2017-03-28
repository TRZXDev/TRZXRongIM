//
//  TZRTwoTableViewCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/3/3.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "TZRTwoTableViewCell.h"

@implementation TZRTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius =  10;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
