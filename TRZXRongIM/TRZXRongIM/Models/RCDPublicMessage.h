//
//  RCDPublicMessage.h
//  TRZX
//
//  Created by 移动微 on 16/11/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCPublicServiceMessageTypeIdentifier @"RCPublicServiceMessage"
/**
 公众号消息
 */
@interface RCDPublicMessage : RCMessageContent<NSCoding,RCMessageContentView>

/**
 公众号名称
 */
@property(nonatomic, copy) NSString *publicName;

/**
 头像
 */
@property(nonatomic, copy) NSString *photo;

/**
 公众号id
 */
@property(nonatomic, copy) NSString *publicId;

@property(nonatomic, copy) NSString *introduction;


/**
 附加消息
 */
@property(nonatomic, copy) NSString *extra;


/**
 根据参数创建公众号消息对象

 @param name  名称
 @param mid   公众号id
 @param photo 图片

 @return 返回创建公众号消息实例
 */
+(instancetype)messageWithName:(NSString *)name mid:(NSString *)mid photo:(NSString *)photo introduction:(NSString *)introduction;

@end
