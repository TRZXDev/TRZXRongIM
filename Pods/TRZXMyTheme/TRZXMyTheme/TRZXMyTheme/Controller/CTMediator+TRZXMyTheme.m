
//
//  CTMediator+TRZXMyTheme.m
//  TRZXMyTheme
//
//  Created by 张江威 on 2017/3/17.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "CTMediator+TRZXMyTheme.h"

@implementation CTMediator (TRZXMyTheme)

-(UIViewController *)MyTheme_MyThemeViewController{
    UIViewController *viewController = [self performTarget:@"TRZXMyTheme"
                                                    action:@"MyTheme_MyThemeViewController"
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
