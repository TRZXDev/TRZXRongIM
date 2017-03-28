//
//  NSNumber+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (RCExtension)

/**
 时间戳比较
 
 @param compareTime 比较间隔 (秒)
 
 @return 返回比较结果
 */
-(BOOL)RC_timeCompareWithInterval:(NSTimeInterval)compareTime;


/**
 时间戳转换成字符串
 
 @return 返回字符串
 */
- (NSString *)RC_TimeIntervalConversionString;

/**
 数字转换成符合规定的 字符串
 
 @return 字符串
 */
-(NSString *)RC_RegularToCountStr;

@end
