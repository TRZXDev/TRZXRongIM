//
//  TiHuanYuanWenView.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "TiHuanYuanWenView.h"

@implementation TiHuanYuanWenView


- (void)awakeFromNib
{
    [super awakeFromNib];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 200.0/255.0, 200.0/255.0, 210.0/255.0, 1 });
    [self.oneBtn.layer setCornerRadius:15];
    [self.oneBtn.layer setBorderWidth:1];
    [self.twoBtn.layer setCornerRadius:15];
    [self.twoBtn.layer setBorderWidth:1];
    [self.oneBtn.layer setBorderColor:colorref];
    [self.twoBtn.layer setBorderColor:colorref];
}


@end
