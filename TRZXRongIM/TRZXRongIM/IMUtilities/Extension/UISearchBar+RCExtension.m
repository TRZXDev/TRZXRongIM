
//
//  UISearchBar+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "UISearchBar+RCExtension.h"
#import "UIView+RCExtension.h"

@implementation UISearchBar (RCExtension)

-(void)RC_setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor{
    
    UIView *searchTextField = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0) {
        // 经过测试,需要设置BarTintColor 后, 才能拿到UISearchBarTextField对象
        self.barTintColor = [UIColor whiteColor];
        searchTextField = [[[self.subviews firstObject] subviews] lastObject];
        searchTextField.RC_cornerRadius = 6;
        [[searchTextField valueForKey:@"_systemBackgroundView"] setHidden:YES];
    }else{// iOS6 以下版本 searchBar内部子视图的结构不一样
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchTextField = subView;
            }
        }
    }
    searchTextField.layer.backgroundColor = backgroundColor.CGColor;
}

/**
 设置取消方法
 
 @param title      文字
 @param titleColor 文字颜色
 @param titleFont  文字字体
 */
-(void)RC_setSearchCancelButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont{
    
    UIButton *cancelButton;
    UIView *topView = self.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        if (title)
            [cancelButton setTitle:title forState:UIControlStateNormal];
        
        if (titleColor)
            [cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
        
        if (titleFont)
            cancelButton.titleLabel.font = titleFont;
    }
}

@end
