//
//  Target_TRZXWeb.m
//  TRZXWebViewController
//
//  Created by N年後 on 2017/2/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "Target_TRZXWeb.h"
#import "TRZXWebViewController.h"

@implementation Target_TRZXWeb
- (UIViewController *)Action_WebViewController:(NSDictionary *)params{
    TRZXWebViewController *webVC = [[TRZXWebViewController alloc] init];
    webVC.webURL = params[@"webURL"];
    return webVC;
}

@end
