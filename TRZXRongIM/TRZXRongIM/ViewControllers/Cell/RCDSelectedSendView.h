//
//  RCDSelectedSendView.h
//  TRZX
//
//  Created by 移动微 on 16/11/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@class RCDUserInfo,MyData,RCDGroupInfo;
/**
 发送给:   视图
 */
@interface RCDSelectedSendView : UIView

@property(nonatomic, copy) void (^sendButtonDidBlock)(RCDUserInfo *userInfo , NSString  *leaveString);

@property(nonatomic, strong)RCDUserInfo *userInfo;

@property(nonatomic, strong)RCDGroupInfo *groupInfo;

@property(nonatomic, strong)MyData *dataMode;


/**
 发送给用户的 初始化构造方法

 @param userInfo        用户信息
 @param sendButtonBlock 发送回调
 */
+(void)selectedSendView:(RCDUserInfo *)userInfo messageContent:(RCMessageContent *)message sendButtonBlock:(void (^)(RCDUserInfo *userInfo , NSString  *leaveString))sendButtonBlock;

/**
 发送给群组的 初始化构造方法
 
 @param sendButtonBlock 发送回调
 */
+(void)selectedSendViewToGroupInfo:(RCDGroupInfo *)groupInfo messageContent:(RCMessageContent *)message sendButtonBlock:(void (^)(RCDUserInfo *userInfo , NSString  *leaveString))sendButtonBlock;

@end
