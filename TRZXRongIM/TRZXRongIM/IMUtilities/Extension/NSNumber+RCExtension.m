
//
//  NSNumber+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "NSNumber+RCExtension.h"

@implementation NSNumber (RCExtension)

/**
 时间戳比较
 
 @param compareTime 比较间隔 (秒)
 
 @return 返回比较结果
 */
-(BOOL)RC_timeCompareWithInterval:(NSTimeInterval)compareTime{
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]/ 1000.0];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    return compareTime > interval;
}

/**
 时间戳转换成字符串
 
 @return 返回字符串
 */
- (NSString *)RC_TimeIntervalConversionString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]/ 1000.0];
    
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 数字转换成符合规定的 字符串
 
 @return 字符串
 */
-(NSString *)RC_RegularToCountStr{
    
    NSUInteger count = [self integerValue];
    
    if (count <= 0) {
        return @"0";
    } else if (count < 10000) {
        return [NSString stringWithFormat:@" %zd", count];
    } else {
        float num = (float)(count / 1000) / 10;
        
        if ((count / 1000) % 10 == 0) {
            return [NSString stringWithFormat:@" %.0f 万", num];
        } else {
            return [NSString stringWithFormat:@" %.1f 万", num];
        }
    }
}

@end
