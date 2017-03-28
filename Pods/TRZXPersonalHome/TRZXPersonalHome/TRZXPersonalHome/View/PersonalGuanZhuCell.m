//
//  PersonalGuanZhuCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/12.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalGuanZhuCell.h"
#import "UIImageView+WebCache.h"


@implementation PersonalGuanZhuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icmImage.layer.cornerRadius = 6;
    self.icmImage.layer.masksToBounds = YES;
    // Initialization code
}

-(void)setModel:(Data *)model{
    if (_model!=model) {
        _model = model;
        
        [self.icmImage sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"展位图"]];
        self.nameLabel.text = model.name;
        self.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",model.company,model.position];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
