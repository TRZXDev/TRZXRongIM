//
//  SCViewTableViewCell.m
//  TRZX
//
//  Created by 张江威 on 16/7/8.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "SCViewTableViewCell.h"

@implementation SCViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bjView.layer.masksToBounds = YES;
    self.bjView.layer.cornerRadius = 6;
    self.txImage.layer.cornerRadius = 6;
    self.txImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
