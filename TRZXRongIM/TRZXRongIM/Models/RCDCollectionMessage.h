//
//  RCDCollectionMessage.h
//  TRZX
//
//  Created by 移动微 on 16/11/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCCollectionMessageTypeIdentifier @"RCCollectionMessageTypeIdentifier"
/**
 收藏 的消息
 */
@interface RCDCollectionMessage : RCMessageContent<NSCoding,RCMessageContentView>

/**
 标题
 */
@property(nonatomic, copy) NSString *collectionTitle;

/**
 内容
 */
@property(nonatomic, copy) NSString *collectionContent;

/**
 配图
 */
@property(nonatomic, copy) NSString *collectionPicture;

/**
 分享类型
 */
@property(nonatomic, copy) NSString *collectionType;

/**
 跳转目标id
 */
@property(nonatomic, copy) NSString *collectionId;

/**
 根据参数创建文本消息对象

 @param title          标题
 @param content        内容
 @param picture        配图
 @param collectionType 分享类型
 @param mid            mid

 @return 返回创建实例对象
 */
+(instancetype)messageWithTitle:(NSString *)title content:(NSString *)content picture:(NSString *)picture collectionType:(NSString *)collectionType mid:(NSString *)mid;

@end
