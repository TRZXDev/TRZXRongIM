//
//  UIButton+Extension.h
//  TRZX
//
//  Created by 移动微 on 16/7/4.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)



////  构造函数1 创建UIButton
///  @param title               标题
///  @param color               标题颜色
///  @param fontsize            字体大小
///  @param imageName           正常图片名
///  @param selectedImagename   选中图片名
///  @return                    UIButton
+(instancetype)kipo_buttonWithTitle:(NSString *)title color:(UIColor *)color fontsize:(CGFloat)fontsize imageName:(NSString *)imageName selectedImagename:(NSString *)selectedImagename;

///  构造函数2 创建UIButton
///  @param imageName   正常图片名
///  @param highlighted 高亮图片名
///  @return            UIButton
+(instancetype)kipo_buttonWithImageName:(NSString *)imageName highlighted:(NSString *)highlighted;

///  构造函数3 创建UIButton
///  @param title       标题
///  @param color       标题颜色
///  @param imageName   图片名 (可选)
///  @param target      监听对象
///  @param actino      执行方法
///  @return            UIButton
+(instancetype)kipo_buttonWithTitle:(NSString *)title color:(UIColor *)color imageName:(NSString *)imageName target:(id)target action:(SEL)actino;


////  构造函数4 创建UIButton
///  @param title           标题
///  @param color           标题颜色
///  @param selectedColor   选中颜色
///  @param imageName       图片名 (可选)
///  @param tag             标记位 (可选)
///  @param target          监听对象
///  @param actino          执行方法
///  @return                UIButton
+(instancetype)kipo_buttonWithTitle:(NSString *)title color:(UIColor *)color selectedColor:(UIColor *)selectedColor imageName:(NSString *)imageName tag:(NSInteger)tag target:(id)target action:(SEL)actino;


/**
 构造函数5 创建UIButton
 
 @param buttonNormalStr normal 图片名
 @param HighlightedStr  highlighted 图片名
 @param TitleString     title 文字
 @param action          方法
 @param buttonTag       标记
 
 @return UIButton
 */
+(instancetype)kipo_addButton:(NSString *)buttonNormalStr buttonHighlightedStr:(NSString *)HighlightedStr andTitleString:(NSString *)TitleString taget:(id)target action:(SEL)action ButtonTag:(NSInteger)buttonTag;
@end
