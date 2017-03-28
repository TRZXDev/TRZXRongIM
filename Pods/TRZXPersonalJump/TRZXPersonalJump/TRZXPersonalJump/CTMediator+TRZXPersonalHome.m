//
//  CTMediator+TRZXPersonalHome.m
//  TRZXPersonalJump
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "CTMediator+TRZXPersonalHome.h"

@implementation CTMediator (TRZXPersonalHome)

-(UIViewController *)personalHomeViewControllerWithOtherStr:(NSString *)otherStr midStrr:(NSString *)midStrr{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"otherStr"] = otherStr;
    params[@"midStrr"] = midStrr;
    UIViewController *viewController = [self performTarget:@"TRZXPersonalHome"
                                                    action:@"PersonalHomeViewController"
                                                    params:params
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

- (UIViewController *)CollectionViewController{

    UIViewController *viewController = [self performTarget:@"TRZXPersonalHome"
                                                    action:@"CollectionViewController"
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
