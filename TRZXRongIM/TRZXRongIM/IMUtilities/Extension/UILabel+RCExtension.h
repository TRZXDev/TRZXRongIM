//
//  UILabel+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RCExtension)
///  构造函数            创建label
///  @param title       标题
///  @param color       颜色
///  @param fontSize    字体大小
///  @return            UILabel
+(instancetype)RC_labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize;

///  构造函数            创建label
///  @param title       标题
///  @param color       颜色
///  @param fontSize    字体大小
///  @param aligment    对其方式
///  @return            UILabel
+(instancetype)RC_labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize aligment:(NSTextAlignment)aligment;

@end
