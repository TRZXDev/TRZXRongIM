
//
//  UIButton+Extension.m
//  TRZX
//
//  Created by 移动微 on 16/7/4.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "UIButton+Extension.h"
#define grayKColor [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1]



@implementation UIButton (Extension)

////  构造函数1 创建UIButton
+(instancetype)kipo_buttonWithTitle:(NSString *)title color:(UIColor *)color fontsize:(CGFloat)fontsize imageName:(NSString *)imageName selectedImagename:(NSString *)selectedImagename{

    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontsize];
    
    //图片
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    //选中图片
    if (selectedImagename != nil) {
        [button setBackgroundImage:[UIImage imageNamed:selectedImagename] forState:UIControlStateSelected];
    }
    
    return button;
}

///  构造函数2 创建UIButton
+(instancetype)kipo_buttonWithImageName:(NSString *)imageName highlighted:(NSString *)highlighted{
    UIButton *button = [[UIButton alloc]init];
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (highlighted != nil) {
        [button setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    }
    return button;
}

///  构造函数3 创建UIButton
+(instancetype)kipo_buttonWithTitle:(NSString *)title color:(UIColor *)color imageName:(NSString *)imageName target:(id)target action:(SEL)actino{
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:actino forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    return button;
}

///  构造函数4 创建UIButton
+(instancetype)kipo_buttonWithTitle:(NSString *)title color:(UIColor *)color selectedColor:(UIColor *)selectedColor imageName:(NSString *)imageName tag:(NSInteger)tag target:(id)target action:(SEL)actino{
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    [button addTarget:target action:actino forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (tag != 0) {
        button.tag = tag;
    }
    
    return button;
}



/**
 构造函数5 创建UIButton

 @param buttonNormalStr normal 图片名
 @param HighlightedStr  highlighted 图片名
 @param TitleString     title 文字
 @param action          方法
 @param buttonTag       标记

 @return UIButton
 */
+(instancetype)kipo_addButton:(NSString *)buttonNormalStr buttonHighlightedStr:(NSString *)HighlightedStr andTitleString:(NSString *)TitleString taget:(id)target action:(SEL)action ButtonTag:(NSInteger)buttonTag{
    
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:buttonNormalStr] forState:UIControlStateNormal];
    if (HighlightedStr != nil) {
        [button setImage:[UIImage imageNamed:HighlightedStr]forState:UIControlStateHighlighted];
    }
    
    [button setBackgroundImage:[UIImage imageNamed:@"Button_Image_Highlighted"] forState:UIControlStateHighlighted];

    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    button.tag = buttonTag;
    [button setTitle:TitleString forState:UIControlStateNormal];
    button.contentMode = UIViewContentModeScaleToFill;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:grayKColor forState:UIControlStateNormal];
    
    return button;
}



/**
 
 分类 扩大 UIButton 点击范围
 */
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//
//    CGRect bounds = self.bounds;
//    
//    CGFloat widthDelta = 44.0 - bounds.size.width;
//    
//    CGFloat heightDelta = 44.0 - bounds.size.height;
//    
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);//注意这里是负数，扩大了之前的bounds的范围
//    
//    return CGRectContainsPoint(bounds, point);
//}

@end
