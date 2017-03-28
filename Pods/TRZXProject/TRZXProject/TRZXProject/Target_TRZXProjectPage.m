//
//  Target_TRZXConfirmFinancing.m
//  TRZXConfirmFinancing
//
//  Created by N年後 on 2017/1/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "Target_TRZXProjectPage.h"
#import "TRZXProjectPageViewController.h"

@implementation Target_TRZXProjectPage

- (UIViewController *)Action_ProjectPageViewController:(NSDictionary *)params;
{
    TRZXProjectPageViewController *projectPageVC = [[TRZXProjectPageViewController alloc] init];
    projectPageVC.projectTitle = params[@"projectTitle"];
    return projectPageVC;
}

@end
