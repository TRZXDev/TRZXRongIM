//
//  TRZXInvestorDetailModel.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/10.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailModel.h"


@implementation TRZXInvestorDetailModel

@end

@implementation InvestorData


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"focusTrades" : @"FocusTrades",
             @"userTitleViews"     : @"UserTitleViews",
             @"positionViews"     : @"PositionViews",
             @"orgUserAuthList"     : @"OrgUserAuthList",
             @"investmentStages"     : @"InvestmentStages",
             @"forTrades"     : @"ForTrades",
             @"focusTradesSelf"     : @"FocusTradesSelf",
             @"investmentCases"     : @"InvestmentCases",
             };
}

@end
@implementation UserTitleViews

@end

@implementation PositionViews

@end

@implementation ForTrades

@end

@implementation FocusTradesSelf

@end


@implementation InvestmentStages

@end
@implementation OrgUserAuthList

@end
@implementation FocusTrades

@end
@implementation InvestmentCases

@end
