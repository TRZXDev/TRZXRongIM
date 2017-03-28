//
//  ZaixianerjiyedeCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/1/19.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "ZaixianerjiyedeCell.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]

@implementation ZaixianerjiyedeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius =   5;
    self.iconImageView.layer.masksToBounds = YES;
    CALayer *lay = self.bgView.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:6.0];//值越大，角度越圆
    [[self.bgView layer] setShadowOffset:CGSizeMake(0, 2)]; // 阴影的范围
    [[self.bgView layer] setShadowRadius:1]; // 阴影扩散的范围控制
    [[self.bgView layer] setShadowOpacity:1]; // 阴影透明度
    [[self.bgView layer] setShadowColor:zideColor.CGColor]; // 阴影的颜色

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
