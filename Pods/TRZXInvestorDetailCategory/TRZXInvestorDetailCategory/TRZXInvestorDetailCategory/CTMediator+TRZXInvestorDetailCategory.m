//
//  CTMediator+TRZXTRZXInvestorDetailCategory.m
//  TRZXInvestorDetailCategory
//
//  Created by zhangbao on 2017/3/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "CTMediator+TRZXInvestorDetailCategory.h"

@implementation CTMediator (TRZXInvestorDetailCategory)

- (UIViewController *)investorDetailViewController:(NSString *)investorId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"investorId"] = investorId;
    return [self performTarget:@"TRZXInvestorDetail" action:@"InvestorDetailViewController" params:params shouldCacheTarget:NO];
}
@end
