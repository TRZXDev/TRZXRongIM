//
//  Target_TRZXRongIM.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/27.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Target_TRZXRongIM : NSObject

// 跳转融云聊天列表 页面
- (UIViewController *)Action_RCDChatListViewController:(NSDictionary *)params;

// 跳转融云聊天页面
- (UIViewController *)Action_RCDChatViewController:(NSDictionary *)params;


@end
