//
//  Target_TRZXPersonalAppointment.m
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/15.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "Target_TRZXPersonalAppointment.h"
#import "MyExpertViewController.h"
#import "MyStudensController.h"

@implementation Target_TRZXPersonalAppointment

//我的专家
- (UIViewController *)Action_PersonalAppointment_MyExpertViewController:(NSDictionary *)parm{
    MyExpertViewController *ExpertViewC = [[MyExpertViewController alloc]init];
    return ExpertViewC;
}
//我的学员
- (UIViewController *)Action_PersonalAppointment_MyStudensController:(NSDictionary *)parm{
    MyStudensController *StudensController = [[MyStudensController alloc]init];
    return StudensController;
}

@end
