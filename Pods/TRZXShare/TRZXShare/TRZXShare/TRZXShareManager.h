//
//  TRZXShareManager.h
//  TRZXShare
//
//  Created by N年後 on 2017/3/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenShareHeader.h"

/**
 第三方分享类型
 */
typedef enum : NSUInteger {
    TRZXShareTypeToFriend, // 投融好友
    TRZXShareTypeToTRZX, // 投融圈
    TRZXShareTypeToWeixin, // 微信好友
    TRZXShareTypeToWeixinTimeline, // 微信时间线
    TRZXShareTypeToQQFriends, // QQ好友
    TRZXShareTypeToQQZone // QQ空间
} TRZXShareType;

@interface TRZXShareManager : NSObject
+ (instancetype)sharedManager;


-(void)showTRZXShareViewMessage:(OSMessage*)message handler:(void (^)(TRZXShareType type))handler;
- (void)hideTRZXShareViewMessage;

#pragma 邀请好友
-(void)showInvitationMessage:(OSMessage*)message index:(NSInteger)index;

@end
