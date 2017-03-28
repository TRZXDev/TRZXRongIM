//
//  CTMediator+PersonalProfile.m
//  TRZXPersonalProfile
//
//  Created by Rhino on 2017/3/1.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "CTMediator+PersonalProfile.h"

@implementation CTMediator (PersonalProfile)


NSString * const kPersonalProfileA                       = @"PersonalProfile";
NSString * const kPersonalProfileViewController          = @"PersonalProfile_TRZXPersonalProfileViewController";


- (UIViewController *)PersonalProfile_TRZXPersonalProfileViewController:(NSDictionary *)parms{
    UIViewController *viewController = [self performTarget:kPersonalProfileA
                                                    action:kPersonalProfileViewController
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
