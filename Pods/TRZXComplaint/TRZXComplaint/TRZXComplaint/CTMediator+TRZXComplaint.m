//
//  CTMediator+TRZXComplaint.m
//  TRZXComplaint
//
//  Created by Rhino on 2017/3/2.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "CTMediator+TRZXComplaint.h"


NSString * const kTRZXComplaintA = @"TRZXComplaint";

NSString * const kTRZXComplaintController          = @"TRZXComplaint_TRZXComplaintViewController";

@implementation CTMediator (TRZXComplaint)


- (UIViewController *)TRZXComplaint_TRZXComplaintViewController:(NSDictionary *)parms{
    UIViewController *viewController = [self performTarget:kTRZXComplaintA
                                                    action:kTRZXComplaintController
                                                    params:parms
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
