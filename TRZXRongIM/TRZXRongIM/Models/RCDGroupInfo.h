//
//  RCDGroupInfo.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/19.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RCGroup.h>
@class RCDUserInfo;
@interface RCDGroupInfo : RCGroup <NSCoding>
/** 人数 */
@property(nonatomic, strong) NSString* number;
/** 最大人数 */
@property(nonatomic, strong) NSString* maxNumber;
/** 群简介 */
@property(nonatomic, strong) NSString* introduce;
/** 创建者Id */
@property(nonatomic, strong) NSString* creatorId;
/** 创建日期 */
@property(nonatomic, strong) NSString* creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL  isJoin;

/**
 群组 id
 */
@property(nonatomic, copy) NSString *mid;

/**
 群名字状态 0 : 未起名字  1 : 起名字
 */
@property(nonatomic, copy) NSString *inName;


/**
 群名称
 */
@property(nonatomic, copy) NSString *name;

/**
 群成员
 */
@property(nonatomic, strong) NSArray <RCDUserInfo *> *users;

/**
 openInvitation 开放成员邀请状态 (1 表示开放,0未开放)
 */
@property(nonatomic, copy) NSString *openInvitation;

/**
 群管理(群主)
 */
@property(nonatomic, copy) NSString *adminId;

/**
 是否保存到通讯录
 */
@property(nonatomic, copy) NSString *isSave;

/**
 拼接好的群组头像二进制
 */
@property(nonatomic, strong) NSData *groupHeadData;

@end
