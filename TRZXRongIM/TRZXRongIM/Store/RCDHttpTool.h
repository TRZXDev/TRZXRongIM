//
//  RCDHttpTool.h
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RCUserInfo.h>
#import <RongIMLib/RCGroup.h>
#import "RCDUserInfo.h"

@class RCDGroupInfo;
typedef void(^SuccessBlock)(id json);
typedef void(^FailureBlick)(NSError *error);

#define RCDHTTPTOOL [RCDHttpTool shareInstance]

@interface RCDHttpTool : NSObject


@property (nonatomic,strong) NSMutableArray *allFriends;
@property (nonatomic,strong) NSMutableArray *allGroups;

+ (RCDHttpTool*)shareInstance;

/**
 获取聊天Token
 */
-(void) getChatTokenCompletion:(void (^)(id data, NSError *error))block;

//查看是否好友
-(void) isMyFriendWithUserInfo:(RCDUserInfo *)userInfo
                  completion:(void(^)(BOOL isFriend)) completion;

//获取个人信息
-(void) getUserInfoByUserID:(NSString *) userID
                         completion:(void (^)(RCDUserInfo *user)) completion;

//获取我的群组
-(void) getMyGroupsWithBlock:(void(^)(NSMutableArray* result)) block;


/**
 获取群组列表 注意 只能查询到 保存到通讯录的群聊 默认(没有保存的)
 */
- (void) getAllGroupsWithCompletion:(void(^)(NSMutableArray *result)) completion;


/**
 设置群组id
 */
-(void) setGroupName:(NSString *)groupName groupId:(NSString *)groupId complete:(void (^)(BOOL result))result;

/**
 根据id获取单个群组

 @param groupID    群组id
 */
-(void) getGroupByID:(NSString *) groupID
          successCompletion:(void (^)(RCDGroupInfo *group)) completion;

/**
 加入群组

 @param userIds    用户id (被拉入群的人id 以逗号分割 ,只有一个也要在末尾加逗号)
 @param groupId    群id
 */
-(void) joinGroupWithUserIds:(NSString *) userIds
                     groupId:(NSString *)groupId
        complete:(void (^)(BOOL result))joinResult;

/**
 创建群组

 @param userIds    用户id ( 用 , 分割 )
 */
-(void) createGroupWithUserIds:(NSString *) userIds
                     groupName:(NSString *)groupName
                      complete:(void (^)(RCGroup *group))resultGroup;

/**
 退出群组

 @param groupID    群组id
 @param uId        说明:uId  -- 被移除对象的id(不传这个参数标示自己主动退出群组) 可以传 nil
 @param quitResult 结果
 */
-(void) quitGroup:(NSString *) groupID
           userId:(NSString *)uId
        complete:(void (^)(BOOL result))quitResult;


/**
 群组 管理权转让

 @param groupID    群组id
 @param uId        转让的用户id
 */
-(void) transferGroup:(NSString *)groupID
                  uId:(NSString *)uId
             complete:(void (^)(BOOL result))result;


/**
 群组保存到通讯录
 
 @param isSave  保存或者删除 YES : 保存   NO : 删除
 @param groupID 群组id
 */
-(void) saveGroupToList:(NSString *)groupID
           saveOrRemove:(BOOL)isSave
               complete:(void (^)(BOOL result))result;


/**
 搜索本地

 @param key    key 值
 @param result 结果
 */
-(void) searchLocal:(NSString *)key
           complete:(void (^)(id value))result;

/**
 群组 开放关闭群邀请成员

 @param groupID 群组id
 @param isOpen  是否打开 YES : 打开  close : 关闭
 */
-(void)inviteGroupMemberById:(NSString *)groupID
          closeOrOpen:(BOOL )isOpen
              complete:(void (^)(BOOL result))result;

/**
 更新群组信息
 */
-(void)updateGroupById:(int) groupID
         withGroupName:(NSString*)groupName
          andintroduce:(NSString*)introduce
              complete:(void (^)(BOOL result))result;




/**
 按昵称搜素好友
 */
-(void) searchFriendListByName:(NSString*)name
                        pageNo:(NSUInteger)pageNo
                      complete:(void (^)(NSMutableArray* result,NSUInteger totalPage,NSUInteger pageNo))friendList;

/**
 请求加好友

 @param userId 用户id
 */
-(void) requestFriend:(NSString*) userId
            complete:(void (^)(BOOL result))result;


/**
 #pragma mark  获取我的好友列表
 */
-(void) requestMyFriendList:(void (^)(id data, NSError *error))block;

/**
 查询请求的添加好友

 @param pageNo 分页
 @param result 添加好友数组
 */
-(void)requestAddFriendListPageNo:(NSUInteger )pageNo complete:(void (^)(NSArray *addFriends, NSUInteger totalPageNo))result;
/**
 删除请求添加好友列表

 @param friendRelationshipId 添加id
 @param result               处理结果
 */
-(void)deleteAddFriendListWithId:(NSString *)friendRelationshipId complete:(void (^)(BOOL isSuccess))result;

//处理请求加好友
-(void) processRequestFriend:(NSString*) userId
                   complete:(void (^)(BOOL result))result;
//删除好友
-(void) deleteFriend:(NSString*) userId
           complete:(void (^)(BOOL result))result;
//更新自己的用户名
- (void)updateName:(NSString*) userName
           success:(void (^)(id response))success
           failure:(void (^)(NSError* err))failure;

//从demo server 获取用户的信息，更新本地数据库
- (void)updateUserInfo:(NSString *) userID
           success:(void (^)(RCDUserInfo * user))success
           failure:(void (^)(NSError* err))failure;


//根据 ID 获取 对方信息
/**
 *  根据Id 查询对象信息
 *
 *  @param userId                  目标 userId (“id”:"用户id,id2" 多个逗号分隔开)
 *  @param SuccessBlock 成功回调
 *  @param failureBlick            失败回调
 */
-(void)getUserInfoWithUserId:(NSString *)userId SuccessBlock:(SuccessBlock)SuccessBlock FailureBlick:(FailureBlick)failureBlick;


/**
 查询商业计划书
 
 @param mid                         mid
 *  @param SuccessBlock  成功回调
 *  @param failureBlick             失败回调
 */
-(void)getPlanApiDetailDataWithMid:(NSString *)mid SuccessBlock:(SuccessBlock)SuccessBlock FailureBlick:(FailureBlick)failureBlick;


#pragma mark - 股东同意BP申请
/**
 *  股东同意BP申请
 *
 *  @param mainKeyId    主键Id
 *  @param successBlock 成功回调
 *  @param failureBlick 失败回调
 */
-(void)requestLoadData_updateByShare:(NSString *)mainKeyId SuccessBlock:(SuccessBlock)successBlock FailureBlick:(FailureBlick)failureBlick;

#pragma mark - 投资人BP申请

/**
 投资人BP申请
 
 @param targetUserId 目标用户id
 @param successBlock 成功回调
 @param failureBlick 失败回调
 */
-(void)requestLoadData_saveByInvestor:(NSString *)targetUserId SuccessBlock:(SuccessBlock)successBlock FailureBlick:(FailureBlick)failureBlick;


#pragma mark - 查询当前BP申请信息
/**
 *  投资人页面查询当前BP申请信息
 *
 *  @param targetUserId 目标用户id
 *  @param successBlock 成功回调
 *  @param failureBlick 失败回调
 */
-(void)requestLoadData_findInfo:(NSString *)targetUserId SuccessBlock:(SuccessBlock)successBlock FailureBlick:(FailureBlick)failureBlick;

@end
