//
//  RCDUserInfo.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RCUserInfo.h>
typedef enum : NSUInteger {
    FriendTypeNotFriend         = 0,//NotFriend("0","无对应关系"),
    FriendTypeComplete          = 1,//Complete("1","互加好友"),
    FriendTypeAlreadyApply      = 2,//AlreadyApply("2","已经申请加对方为好友"),
    FriendTypeOtherSideApply    = 3,//OtherSideApply("3","对方已经申请加好友"),
    FriendTypeOtherDelete       = 4,//OtherDelete("4","被对方删除好友"),
    FriendTypeOwnDelete         = 5,//OwnDelete("5","主动删除对方好友"),
    FriendTypeTimeOut           = 6,//TimeOut("6","对方申请为加你为好友但是已经过期了");
} FriendType;


@interface RCDUserInfo : RCUserInfo<NSCoding>

/**
 职位
 */
@property(nonatomic, copy) NSString *position;

/**
 公司
 */
@property(nonatomic, copy) NSString *company;

/**
 好友状态,详细见枚举统一说明
 */
@property(nonatomic, copy) NSString *isAlso;

/**
 用户身份
 */
@property(nonatomic, copy) NSString *userType;

/**
 用户id
 */
@property(nonatomic, copy) NSString *mid;

/**
 头像
 */
@property(nonatomic, copy) NSString *headImg;

@property(nonatomic, copy) NSString *photo;

@property(nonatomic, copy) NSString *displayName;

/**
 申请添加好友处理的Id
 */
@property(nonatomic, copy) NSString *friendRelationshipId;

@end
