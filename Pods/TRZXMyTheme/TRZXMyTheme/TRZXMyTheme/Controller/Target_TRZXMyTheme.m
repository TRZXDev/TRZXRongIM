//
//  Target_TRZXPersonalAppointment.m
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/15.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "Target_TRZXMyTheme.h"
#import "MyThemeViewController.h"

@implementation Target_TRZXMyTheme

//我的主题
- (UIViewController *)Action_MyTheme_MyThemeViewController:(NSDictionary *)parm{
    MyThemeViewController *ExpertViewC = [[MyThemeViewController alloc]init];
    return ExpertViewC;
}


@end
