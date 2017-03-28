//
//  Target_TRZXInvestorDetail.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "Target_TRZXInvestorDetail.h"
#import "TRZXInvestorDetailViewController.h"

@implementation Target_TRZXInvestorDetail

- (UIViewController *)Action_InvestorDetailViewController:(NSDictionary *)params
{
    TRZXInvestorDetailViewController *investorDetail_vc = [[TRZXInvestorDetailViewController alloc] init];
    investorDetail_vc.investorId = params[@"investorId"];
    return investorDetail_vc;
}

@end
