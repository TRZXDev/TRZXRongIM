//
//  CTMediator+TRZXProjectDetail.m
//  TRZXProjectDetailCategory
//
//  Created by zhangbao on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "CTMediator+TRZXProjectDetail.h"

@implementation CTMediator (TRZXProjectDetail)

- (UIViewController *)projectDetailViewController:(NSString *)projectId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"projectId"] = projectId;
    return [self performTarget:@"TRZXProjectDetail" action:@"ProjectDetailViewController" params:params shouldCacheTarget:NO];
}

@end
