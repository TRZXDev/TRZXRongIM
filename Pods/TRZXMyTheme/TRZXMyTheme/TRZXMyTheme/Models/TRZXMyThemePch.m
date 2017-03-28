//
//  TRZXPersonalAppointmentPch.m
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/14.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXMyThemePch.h"

#define MAXCOUNTDAYS 100

@implementation TRZXMyThemePch


#pragma mark 邮箱验证
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine currIndex:(int)currIndex{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMdd"];
    NSDate *startDate = [f dateFromString:[self summaryTimeUsingDate:[NSDate date]]];
    NSDate *endDate = [f dateFromString:deadLine];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    NSInteger diffDays = components.day;
    if(diffDays==0) return @[[self summaryTimeUsingDate:[NSDate date]]];
    NSMutableArray *dayArray = [NSMutableArray array];
    if(diffDays > MAXCOUNTDAYS) diffDays = MAXCOUNTDAYS;
    for (int i = currIndex; i <= diffDays; i++) {
        NSTimeInterval  iDay = 24*60*60*i;  //1天的长度
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:iDay];
        [dayArray addObject:[self summaryTimeUsingDate:date]];
    }
    return dayArray;
}

+(int)currentDateHour{
    return (int)[self dateComponents].hour;
}

+(int)currentDateMinute{
    return (int)[self dateComponents].minute;
}

+(NSDateComponents *)dateComponents{
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    return dateComponent;
}

+(NSString *)summaryTimeUsingDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)summaryTimeUsingDate1:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)summaryTimeUsingDate2
{
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval  interval =24*60*60*7; //1:天数
    NSDate*date1 = [currentDate initWithTimeIntervalSinceNow:+interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date1];
    return dateString;
}

+(NSString *)displayedSummaryTimeUsingString:(NSString *)string
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:[string substringWithRange:NSMakeRange(0, 4)]];
    [result appendString:@"-"];
    [result appendString:[string substringWithRange:NSMakeRange(4, 2)]];
    [result appendString:@"-"];
    [result appendString:[string substringWithRange:NSMakeRange(6, 2)]];
    return result;
}
@end
