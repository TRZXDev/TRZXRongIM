//
//  TRZXYdyTableViewCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/10/26.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "TRZXYdyTableViewCell.h"

@implementation TRZXYdyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bjView.layer.masksToBounds = YES;
    self.bjView.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
