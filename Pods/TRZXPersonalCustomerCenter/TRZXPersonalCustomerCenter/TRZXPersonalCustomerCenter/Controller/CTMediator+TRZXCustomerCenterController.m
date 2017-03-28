//
//  CTMediator+TRZXCustomerCenterController.m
//  TRZXPersonalCustomerCenter
//
//  Created by 张江威 on 2017/3/9.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "CTMediator+TRZXCustomerCenterController.h"

NSString * const kCustomerCenterControllerA = @"TRZXPersonalCustomerCenter";

NSString * const kCustomerCenterControllerAction          = @"TRZXPersonalCustomerCentert_TRZXPersonalCustomerCenter";

@implementation CTMediator (TRZXCustomerCenterController)

-(UIViewController *)TRZXCustomerCenterController_TRZXCustomerCenterController{
    UIViewController *viewController = [self performTarget:kCustomerCenterControllerA
                                                    action:kCustomerCenterControllerAction
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
