//
//  RCDRedPacketsMessage.h
//  TRZX
//
//  Created by 移动微 on 16/11/3.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCDRedPacketsMessageTypeIdentifier @"RCDRedPacketsMessageTypeIdentifier"

/**
 红包消息
 */
@interface RCDRedPacketsMessage : RCMessageContent<NSCoding,RCMessageContentView>

/**
 标题
 */
@property(nonatomic, copy) NSString *title;

/**
 内容
 */
@property(nonatomic, copy) NSString *content;


+(instancetype)messageWithTitle:(NSString *)title content:(NSString *)content;

@end
