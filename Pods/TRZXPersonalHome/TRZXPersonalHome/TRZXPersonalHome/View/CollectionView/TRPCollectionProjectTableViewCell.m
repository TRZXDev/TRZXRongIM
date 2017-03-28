//
//  CollectionProjectTableViewCell.m
//  TRZX
//
//  Created by 张江威 on 2017/3/3.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import "TRPCollectionProjectTableViewCell.h"

@implementation TRPCollectionProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
