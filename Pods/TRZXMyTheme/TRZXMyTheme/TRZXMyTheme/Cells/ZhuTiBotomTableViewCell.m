//
//  ZhuTiBotomTableViewCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "ZhuTiBotomTableViewCell.h"

@implementation ZhuTiBotomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 200.0/255.0, 200.0/255.0, 210.0/255.0, 1 });
    [_time1Btn.layer setCornerRadius:15];
    [_time1Btn.layer setBorderWidth:1];
//    [_time2Btn.layer setCornerRadius:15];
//    [_time2Btn.layer setBorderWidth:1];
    [_time3Btn.layer setCornerRadius:15];
    [_time3Btn.layer setBorderWidth:1];
    [_time4Btn.layer setCornerRadius:15];
    [_time4Btn.layer setBorderWidth:1];
//    [_oneToOneBtn.layer setCornerRadius:15];
//    [_oneToOneBtn.layer setBorderWidth:1];
//    [_yuanchengBtn.layer setCornerRadius:15];
//    [_yuanchengBtn.layer setBorderWidth:1];
    
    [_time1Btn.layer setBorderColor:colorref];
//    [_time2Btn.layer setBorderColor:colorref];
    [_time3Btn.layer setBorderColor:colorref];
    [_time4Btn.layer setBorderColor:colorref];
//    [_oneToOneBtn.layer setBorderColor:colorref];
//    [_yuanchengBtn.layer setBorderColor:colorref];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
