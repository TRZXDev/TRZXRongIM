//
//  Target_TRZXPersonalAppointment.h
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/15.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Target_TRZXPersonalAppointment : NSObject

//我的专家
- (UIViewController *)Action_PersonalAppointment_MyExpertViewController:(NSDictionary *)parm;

//我的学员
- (UIViewController *)Action_PersonalAppointment_MyStudensController:(NSDictionary *)parm;


@end
