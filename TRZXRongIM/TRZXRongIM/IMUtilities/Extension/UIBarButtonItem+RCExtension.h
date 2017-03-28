//
//  UIBarButtonItem+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (RCExtension)


//// 构造函数1 创建 UIBarButtonItem
///  @param title       标题
///  @param color       颜色
///  @param imageName   图片名 (可选)
///  @param target      监听对象
///  @param action      执行方法
///  @return            UIBarButtonItem
+(instancetype)RC_barButtonWithTitle:(NSString *)title color:(UIColor *)color imageName:(NSString *)imageName target:(id)target action:(SEL)action;

///  返回灰色的 返回按钮 + 图片
///  @param target 监听对象
///  @param action 指定方法
///  @return UIBarButtonItem
+(instancetype)RC_LeftTarButtonItemDefaultTarget:(id)target titelabe:(NSString *)tittStr color:(UIColor *)color action:(SEL)action;


+(instancetype)RC_RightButtonItemWithImageName:(NSString *)imageName Target:(id)target action:(SEL)action;


/**
 参数化定制构造方法
 
 @param imageName  图片名
 @param buttonRect 底部ButtonRect
 @param imageRect  imgRect
 @param target     监听对象
 @param action     方法
 
 @return UIbarButtonItem
 */
+(instancetype)RC_RightButtonItemWithImageName:(NSString *)imageName buttonRect:(CGRect)buttonRect imageRect:(CGRect)imageRect Target:(id)target action:(SEL)action;

@end
