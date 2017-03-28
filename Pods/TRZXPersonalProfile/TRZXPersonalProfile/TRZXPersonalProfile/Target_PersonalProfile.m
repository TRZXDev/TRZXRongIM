//
//  Target_PersonalProfile.m
//  TRZXPersonalProfile
//
//  Created by Rhino on 2017/3/1.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "Target_PersonalProfile.h"
#import "TRZXPersonalProfileViewController.h"

@implementation Target_PersonalProfile

- (UIViewController *)Action_PersonalProfile_TRZXPersonalProfileViewController:(NSDictionary *)params{
    TRZXPersonalProfileViewController *vc = [[TRZXPersonalProfileViewController alloc]init];
    vc.titleStr = params[@"titleStr"];
    vc.workArray = params[@"workArray"];
    vc.eduArray =params[@"eduArray"];
    vc.userType = params[@"type"];
    vc.abstractz = params[@"abstractz"];
    return vc;
}




@end
