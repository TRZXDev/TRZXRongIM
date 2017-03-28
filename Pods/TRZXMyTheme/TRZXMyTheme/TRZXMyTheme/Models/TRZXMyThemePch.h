//
//  TRZXPersonalAppointmentPch.h
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/14.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MJRefresh/MJRefresh.h>
#import <TRZXNetwork/TRZXNetwork.h>
#import <MJExtension/MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import <DVSwitch/DVSwitch.h>
#import "UIImage+MyThemeLoad.h"

#define  zjself __weak __typeof(self) sfself = self

#define purseTag 20009
#define weiXinTag 20010
#define unionpayTag 20011

#define POINTY(view) view.frame.origin.y
#define POINTX(view) view.frame.origin.x
#define HEIGTH(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width
#define xiandeColor [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define grayKColor [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define NSNotificationMeet @"meet"
#define NSNotificationTheme @"ThemeRevise"



#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



@interface TRZXMyThemePch : NSObject

#pragma mark 邮箱验证
+(BOOL)isValidateEmail:(NSString *)email;
+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine currIndex:(int)currIndex;

+(int)currentDateHour;

+(int)currentDateMinute;

+(NSString *)displayedSummaryTimeUsingString:(NSString *)string;
+(NSString *)summaryTimeUsingDate2;

@end
