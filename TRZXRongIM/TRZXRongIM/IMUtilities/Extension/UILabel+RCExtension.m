//
//  UILabel+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "UILabel+RCExtension.h"

@implementation UILabel (RCExtension)
////  构造方法
+(instancetype)RC_labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}

+(instancetype)RC_labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize aligment:(NSTextAlignment)aligment{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textAlignment = aligment;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    //    label.contentMode = UIViewContentModeBottom;
    label.clipsToBounds = YES;
    [label sizeToFit];
    return label;
}
@end
