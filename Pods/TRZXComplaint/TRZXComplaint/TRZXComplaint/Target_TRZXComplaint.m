//
//  Target_TRZXComplaint.m
//  TRZXComplaint
//
//  Created by Rhino on 2017/3/2.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "Target_TRZXComplaint.h"
#import "TRZXComplaintsViewController.h"

@implementation Target_TRZXComplaint


- (UIViewController *)Action_TRZXComplaint_TRZXComplaintViewController:(NSDictionary *)params{
    TRZXComplaintsViewController *complaints = [[TRZXComplaintsViewController alloc]init];
    complaints.type = [params[@"type"] integerValue];
    complaints.targetId = params[@"targetId"];
    complaints.userTitle = params[@"userTitle"];
    return complaints;
}


@end
