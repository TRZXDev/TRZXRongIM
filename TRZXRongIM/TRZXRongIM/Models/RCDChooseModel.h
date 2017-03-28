//
//  RCDChooseModel.h
//  TRZX
//
//  Created by 移动微 on 16/12/13.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

//创建样式
typedef enum : NSUInteger {
    ChooseModelTypeLabel,
    ChooseModelTypeButton, //默认
} ChooseModelType;

/**
 创建模型
 */
@interface RCDChooseModel : NSObject

@property(nonatomic, strong)NSString *text;

@property(nonatomic, strong)UIColor *textColor;

@property(nonatomic, assign)ChooseModelType type;

/**
 初始化构造方法1

 @param str 显示文字
 textColor : [UIColor trzx_TitleColor](默认)
 type : ChooseModelTypeButton(默认)
 */
+(RCDChooseModel *)modelWithStr:(NSString *)str;

/**
 初始化构造方法2
 
 @param str 显示文字
 @param color 文字颜色
 type : ChooseModelTypeButton(默认)
 */
+(RCDChooseModel *)modelWithStr:(NSString *)str textColor:(UIColor *)color;

/**
 初始化构造方法3
 
 @param str 显示文字
 @param color 文字颜色
 @param type 创建控件样式
 */
+(RCDChooseModel *)modelWithStr:(NSString *)str textColor:(UIColor *)color type:(ChooseModelType)type;

@end
