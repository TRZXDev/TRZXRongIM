//
//  CTMediator+TRZXFriendCircle.m
//  TRZXFriendCircle
//
//  Created by 张江威 on 2017/3/20.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "CTMediator+TRZXFriendCircle.h"

@implementation CTMediator (TRZXFriendCircle)


-(UIViewController *)FriendCircle_TRZXFriendLineTableViewController{
    UIViewController *viewController = [self performTarget:@"TRZXFriendCircle"
                                                    action:@"FriendCircle_TRZXFriendLineTableViewController"
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

-(UIViewController *)FriendCircle_PhotoTimeLineTableViewController{
    UIViewController *viewController = [self performTarget:@"TRZXFriendCircle"
                                                    action:@"FriendCircle_PhotoTimeLineTableViewController"
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
