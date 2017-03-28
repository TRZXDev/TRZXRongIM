//
//  PersonalCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "PersonalCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)setModel:(MeetModel *)model{

    if (_model!=model) {
        _model = model;
        _dateLable.text = [NSString stringWithFormat:@"约%@",model.timeOnce];
        _nameLable.text = model.teacherName;
        if ([_vipStr isEqualToString:@"1"]) {
            _moneyLable.text = [NSString stringWithFormat:@"%@元/次",model.vipPrice];

        }else{
            _moneyLable.text = [NSString stringWithFormat:@"%@元/次",model.muchOnce];
        }

        _textLable.text = model.topicTitle;
        if ([_type isEqualToString:@"teacher"]) {
            [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.stuPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
        } else {
            [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.teacherPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
        }

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
