//
//  RCDChatViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@protocol RCDChatViewControllerDelegate <NSObject>

-(void)onDeleteMessage:(RCMessageModel *)model;

-(void)onCopyMessage:(RCMessageModel *)model;

@end

//更换背景图片 通知
#define replaceRCDChatViewControllerBakcground @"replaceRCDChatViewControllerBakcground"
@interface RCDChatViewController : RCConversationViewController

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

@property (nonatomic,assign) BOOL isChangeEdgeTopBool;

@property (nonatomic,assign) BOOL closeInputBool;

@property (nonatomic,assign) BOOL isPopRootNav;

@property (nonatomic,assign) BOOL collectionHeightChange;

    
/**
 获取 标准的私信聊天页面

 @param userId 用户ID
 @param title  title
 */
+ (UIViewController *)getStandardViewController:(NSString *)userId title:(NSString *)title;
    
@end
