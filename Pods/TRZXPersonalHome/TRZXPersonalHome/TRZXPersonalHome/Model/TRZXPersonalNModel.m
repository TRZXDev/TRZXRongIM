//
//  TRZXPersonalNModel.m
//  TRZXPersonalHome
//
//  Created by 张江威 on 2017/3/22.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPersonalNModel.h"

@implementation TRZXPersonalNModel

+ (NSDictionary *)objectClassInArray{
    return @{@"menus" : [Menus class]};
}


@end

@implementation Menus

@end

@implementation UserWorkExperience

@end

@implementation Achievements

@end

@implementation UserEducationExperiences

@end

@implementation personalData

+ (NSDictionary *)objectClassInArray{
    return @{
             @"userWorkExperience" : [UserEducationExperiences class],
             @"achievements" : [Achievements class],
             @"userWorkExperience" : [UserWorkExperience class],
             };
}

@end
