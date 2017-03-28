//
//  WoWenTableViewCell.m
//  TRZX
//
//  Created by 张江威 on 16/7/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "WoWenTableViewCell.h"

@implementation WoWenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icmImage.layer.cornerRadius = 6;
    self.icmImage.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
