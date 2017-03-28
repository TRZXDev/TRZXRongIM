//
//  NSString+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (RCExtension)

- (CGSize)RC_getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;


- (CGSize)RC_sizeWithViewWidth:(CGFloat)width FontSize:(float)fontSize;


/**
 *  汉字转拼音
 *
 *
 *  @return 转换后的拼音
 */
-(NSString *)RC_hanZiToPinYin;


/**
 纯中文判断
 */
-(BOOL)RC_isInputRuleZhongWen;


//字母、数字、中文正则判断（不包括空格）
+ (BOOL)RC_isInputRuleNotBlank:(NSString *)str;

- (BOOL)RC_isContainsEmoji;

- (NSUInteger)RC_utf8Length;

//字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
- (BOOL)RC_isInputRuleAndBlank;

@end
