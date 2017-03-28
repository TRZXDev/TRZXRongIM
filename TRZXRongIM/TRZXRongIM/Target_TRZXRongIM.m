//
//  Target_TRZXRongIM.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/27.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "Target_TRZXRongIM.h"
#import <RongIMKit/RongIMKit.h>
//#import "RCDChatListViewController.h"
//#import "RCDChatViewController.h"

@implementation Target_TRZXRongIM
// 跳转融云聊天列表 页面
- (UIViewController *)Action_RCDChatListViewController:(NSDictionary *)params{
    Class cls = NSClassFromString([NSString stringWithFormat:@"RCDChatListViewController"]);
    UIViewController *RCDChatList = [cls new];
    NSString *title = params[@"vcTitle"];
    RCDChatList.title = title;
    RCDChatList.navigationItem.title = title;
    
    // TabBar 暂时不设置
//    RCDChatList.tabBarItem.title = title;
//    RCDChatList.tabBarItem.image = [UIImage imageNamed:@"tab4"];
//    RCDChatList.tabBarItem.selectedImage = [UIImage imageNamed:@"tab4sel"];
    return RCDChatList;
}

// 跳转融云聊天页面
- (UIViewController *)Action_RCDChatViewController:(NSDictionary *)params{
    
    NSString *userId = params[@"userId"];
    NSString *vcTitle = params[@"vcTitle"];
    
    id clz = NSClassFromString(@"RCDChatViewController");
    SEL sel = NSSelectorFromString(@"getStandardViewController:title:");
    
    UIViewController *viewController;
    if ([clz respondsToSelector:sel]) {
        viewController = [clz performSelector:sel withObject:userId withObject:vcTitle];
    }
    
    
    return viewController;
}

@end
