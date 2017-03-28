//
//  UISearchBar+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (RCExtension)

/**
 提供设置 searchBar TextField的背景颜色 (UISearchBar iOS7以上和iOS6的内部结构不一样)
 */
-(void)RC_setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor;


/**
 设置取消方法
 
 @param title      文字     (可不传)
 @param titleColor 文字颜色  (可不传)
 @param titleFont  文字字体  (可不传)
 */
-(void)RC_setSearchCancelButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;

@end
