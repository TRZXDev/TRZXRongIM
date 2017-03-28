//
//  CTMediator+TRZXPersonalAppointment.m
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/15.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "CTMediator+TRZXPersonalAppointment.h"

@implementation CTMediator (TRZXPersonalAppointment)

-(UIViewController *)PersonalAppointment_MyExpertViewController{
    UIViewController *viewController = [self performTarget:@"TRZXPersonalAppointment"
                                                    action:@"PersonalAppointment_MyExpertViewController"
                                                    params:nil
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

-(UIViewController *)PersonalAppointment_MyStudensController{
    UIViewController *viewController = [self performTarget:@"TRZXPersonalAppointment"
                                                    action:@"PersonalAppointment_MyStudensController"
                                                    params:nil
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}
@end
