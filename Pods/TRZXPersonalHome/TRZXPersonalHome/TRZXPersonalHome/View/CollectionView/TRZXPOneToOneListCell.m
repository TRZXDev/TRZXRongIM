//
//  OneToOneListCell.m
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "TRZXPOneToOneListCell.h"


@implementation TRZXPOneToOneListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius =   5;
    self.iconImageView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
