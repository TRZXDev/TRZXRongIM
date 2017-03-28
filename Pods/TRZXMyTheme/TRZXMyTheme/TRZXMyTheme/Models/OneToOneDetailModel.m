//
//  OneToOneDetailModel.m
//  tourongzhuanjia
//
//  Created by 移动微 on 16/2/4.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "OneToOneDetailModel.h"


@implementation OneToOneDetailModel

//+ (NSDictionary *)objectClassInArray{
//    return @{
//             @"meet":[OneToOneInfoMeet class]
//             };
//}

@end

@implementation OneToOneInfoMeet

@end

@implementation OneToOneInfoOstList

@end

@implementation OneToOneInfoData1

+(NSDictionary *)objectClassInArray{
    return @{@"ostList":[OneToOneInfoOstList class]};
}

@end



