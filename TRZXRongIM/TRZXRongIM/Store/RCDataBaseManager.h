//
//  RCDataBaseManager.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/6/3.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCDUserInfo,RCDGroupInfo;
// msgFlag 枚举
typedef enum : NSUInteger {
    msgFlagTypeVVRoadShow = 1111,  //("互动路演"),
    msgFlagTypeVVCourse,           //("互动课程"),
    msgFlagTypeStudent,            //("我的学员"),
    msgFlagTypeOTOMeet,            //("我的约见"), //暂时不用
    msgFlagTypeExpert,             //("我的专家"),
    msgFlagTypeTopic,              //("主题"),
    msgFlagTypeAuth,               //("一键认证"),
    msgFlagTypeMenu,               //("菜单"),
    msgFlagTypeWallet,             //("钱包"),
    msgFlagTypeMessage,            //("通知消息"),
    msgFlagTypeGuide,              //("指南");
    msgFlagTypeStrategy,           //("攻略");
    msgFlagTypey110,               //录制课程
    msgFlagTypey109,               //发布主题
    msgFlagTypey101,               //录制路演
    msgFlagTypey100,               //发布项目
    msgFlagTypey122,               //录制活动
    msgFlagTypey114,               //招商路演
    msgFlagTypey118,               //商业计划书
//    msgFlagTypey117,               //个人相册
    msgFlagTypey115,               //政策法规
    msgFlagTypey116,               //个人认证
    msgFlagTypey124,               //发起直播
    msgFlagTypey126,               //我的约见
    msgFlagTypeMyQA,               //我的问答
    msgFlagTypey129,               //我的客户
    msgFlagTypey130,               //我的团队
    msgFlagTypey131,               //我的业绩
    msgFlagTypey132,              //成为合伙人
    msgFlagTypey128
    
} msgFlagType;

@interface RCDataBaseManager : NSObject

+ (RCDataBaseManager*)shareInstance;

+(void)tearDown;

//存储用户信息
-(void)insertUserToDB:(RCDUserInfo*)user;

//插入黑名单列表
-(void)insertBlackListToDB:(RCDUserInfo*)user;

//获取黑名单列表
- (NSArray *)getBlackList;

//移除黑名单
- (void)removeBlackList:(NSString *)userId;

//清空黑名单缓存信息
-(void)clearBlackListData;

//插入群组头像
-(void)insertGroupHeaderIconToDB:(NSString *)groupId data:(NSData *)data;

///**
// 获取群组头像
// */
//-(NSData *) getGroupHeaderIconWithId:(NSString*)groupId;

/**
 删除群主头像
 */
-(void) deleteGroupInfoWithId:(NSString *)groupId;

/**
 插入添加好友列表消息
 */
-(void)insertAddFriendMessageToDB:(NSString *)message;
/**
 获取全部添加好友消息数量
 */
-(NSInteger)getAddFriendMessageCount;
/**
 删除添加好友列表消息
 */
-(void)deleteAddFriendMessage:(NSString *)message;
//清空添加好友数据
-(void)clearAddFriendMessage;

//从表中获取用户信息
-(RCDUserInfo*) getUserByUserId:(NSString*)userId;

//从表中获取所有用户信息
-(NSArray *) getAllUserInfo;

//存储群组信息
-(void)insertGroupToDB:(RCDGroupInfo *)group;

//从表中获取群组信息
-(RCDGroupInfo*) getGroupByGroupId:(NSString*)groupId;

//从表中获取所有群组信息
-(NSArray *) getAllGroup;

//存储好友信息
-(void)insertFriendToDB:(RCDUserInfo *)friend;

//获取好友信息
-(RCDUserInfo*) getFriendByUserId:(NSString*)userId;

//清空群组缓存数据
-(void)clearGroupsData;

//清空好友缓存数据
-(void)clearFriendsData;

//从表中获取所有好友信息 
-(NSArray *) getAllFriends;

//删除好友信息
-(void)deleteFriendFromDB:(NSString *)userId;

/**
 *  存储 msgFlag
 *
 *  @param msgFlagStr msgFlag
 */
-(void)insertMsgFlag:(NSString *)msgFlagStr;

///  便利存储 Msg Flag
///  @param msgFlagStr msg字符串
-(void)saveMsgFlag:(NSString *)msgFlagStr;

/// 成为合伙人钱包改变
-(void)OperatorWalletChange;

/**
 *  删除 msgFlag
 *
 *  @param msgFlagStr msgFlag
 */
-(void)removeMsgFlag:(msgFlagType)msgFlagType;



/**
 *  获取 msgFlag
 *
 *  @param msgFlagStr msgFlag
 */
-(BOOL)getMsgFlag:(msgFlagType)msgFlagType;

-(void)saveSpecialMsgFlag:(msgFlagType)msgFlagType;

//查询
-(BOOL)queryMsgFlag:(NSString *)msgFlag;

@property(nonatomic,assign)BOOL isCreate;

/**
 *  更新 内容
 *
 *  @param msgFlagStr
 */
-(void)updateMsgFlag:(NSString *)msgFlagStr;

///  获取消息数量
///  @return 获取消息数
-(int)getMsgFlagNumber;

///  删除所有的msgFlag
-(void)removeAllMsgFlag;

//VoiceRecordMessageId
-(void)insertVoiceRecordMessageId:(NSString *)messageId;

-(BOOL)getVoiceRecordMessageId:(NSString *)messageId;
///  保存问答语音路径
///  @param voiceId 问答语音id
///  @param voicePath 问答语音路径
-(void)insertQuestionVoiceId:(NSString *)voiceId voicePath:(NSString *)voicePath;
///  获取问答语音路径
///  @param VoiceId 问答语音id
///  @return 问答语音语音路径
-(NSString *)getQuestionVoiceId:(NSString *)VoiceId;


@end
///接收友盟消息 会处理:1.更新RCDChatListViewController页面 2.会更新其他的页面
extern NSString * const RCDUmengNotification;
///接收到朋友圈评论通知后,内部进行转发通知
extern NSString * const RCDCommentCircleNotification;
///接收到好友发投融圈通知后,内部进行转发通知
extern NSString * const RCDFriendCircleNotification;
///接收到后台发送的群信息更新通知后,内部进行转发通知
extern NSString * const RCDGroupRefreshNotification;
///接收到后台发送删除好友通知后,内部进行转发通知
extern NSString * const RCDDeleteFriendNotification;
///后台命令通知, 更新自己身份
extern NSString * const RCDRefreshAuthKey;
///后台命令通知, 添加好友
extern NSString * const RCDAddFriendKey;
///后台命令通知, 好友发投融圈
extern NSString * const RCDCommentCircleKey;
///后台命令通知, 推送评论朋友圈
extern NSString * const RCDFriendCircleKey;
///后台命令通知, 群组名字和头像更新
extern NSString * const RCDGroupNameChangeKey;
///后台命令通知, 对方删除好友通知自己也删除
extern NSString * const RCDDeleteFriendKey;
