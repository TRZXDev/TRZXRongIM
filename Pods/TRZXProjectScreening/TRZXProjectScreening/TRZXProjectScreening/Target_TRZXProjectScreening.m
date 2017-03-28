//
//  Target_TRZXConfirmFinancing.m
//  TRZXConfirmFinancing
//
//  Created by N年後 on 2017/1/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "Target_TRZXProjectScreening.h"
#import "TRZXProjectScreeningViewController.h"

@implementation Target_TRZXProjectScreening

- (UIViewController *)Action_ProjectScreeningViewController:(NSDictionary *)params
{
    TRZXProjectScreeningViewController *confirmFinancingVC = [[TRZXProjectScreeningViewController alloc] init];
    confirmFinancingVC.projectTitle = params[@"projectTitle"];
    confirmFinancingVC.confirmComplete = params[@"completeBlock"];
    confirmFinancingVC.screeningType = params[@"screeningType"];
    return confirmFinancingVC;
}

@end
