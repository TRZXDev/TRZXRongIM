//
//  TRZXRecommendModel.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/9.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXRecommendModel.h"

@implementation TRZXRecommendModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"coursezList"         : @"TRZXRecommendCoursez",
             @"expertTopicList"     : @"TRZXRecommendExpertTopic",
             @"investorList"        : @"TRZXRecommendInvestor"
             };
}


@end

@implementation TRZXRecommendCoursez

@end


@implementation TRZXRecommendExpertTopic

@end

@implementation TRZXRecommendInvestor 

@end
