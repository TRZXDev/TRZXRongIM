//
//  RCDBusinessCardMessage.h
//  TRZX
//
//  Created by 移动微 on 16/10/31.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCBusinessCardMessageTypeIdentifier @"RCBusinessCardMessageTypeIdentifier"
/**
 个人名片消息
 */
@interface RCDBusinessCardMessage : RCMessageContent<NSCoding,RCMessageContentView>

/**
 文本消息内容
 */
@property(nonatomic, copy) NSString *businessContent;

/**
 姓名
 */
@property(nonatomic, copy) NSString *businessName;

/**
 头像
 */
@property(nonatomic, copy) NSString *portrait;

/**
 用户id
 */
@property(nonatomic, copy) NSString *userId;

/**
 附加消息
 */
@property(nonatomic, copy) NSString *extra;


/**
 根据参数创建名片消息对象

 @param content  文本内容
 @param name     姓名
 @param portrait 头像
 @param userId   用户id

 @return 返回创建名片消息实例
 */
+(instancetype)messageWithContent:(NSString *)content andName:(NSString *)name portrait:(NSString *)portrait userId:(NSString *)userId;

@end
