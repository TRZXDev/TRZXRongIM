//
//  PersonaljiaoyiCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/15.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonaljiaoyiCell.h"

@implementation PersonaljiaoyiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bjView.layer.cornerRadius = 10;
    self.bjView.layer.masksToBounds = YES;
    self.icmImage.layer.cornerRadius = 6;
    self.icmImage.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
