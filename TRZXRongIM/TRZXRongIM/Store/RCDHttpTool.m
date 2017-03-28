
//
//  RCDHttpTool.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDHttpTool.h"
#import "RCDGroupInfo.h"
#import "RCDUserInfo.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "RCDSearchUserInfo.h"
#import <MJExtension/MJExtension.h>
#import <TRZXLogin/Login.h>

@implementation RCDHttpTool

+ (RCDHttpTool*)shareInstance
{
    static RCDHttpTool* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        instance.allGroups = [NSMutableArray new];
    });
    return instance;
}

/**
 获取聊天Token
 */
-(void) getChatTokenCompletion:(void (^)(id data, NSError *error))block{
    NSDictionary *params = @{@"requestType":@"Chat_Api",
                             @"apiType":@"getToken"};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (response) {
            block(response, nil);
        }else{
            block(nil, error);
        }
    }];
    
    
}

-(void) isMyFriendWithUserInfo:(RCDUserInfo *)userInfo
                  completion:(void(^)(BOOL isFriend)) completion{

    
}

/**
 根据id获取单个群组
 */
-(void) getGroupByID:(NSString *) groupID
   successCompletion:(void (^)(RCDGroupInfo *group)) completion{
    
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"groupInfo",
                             @"groupId":groupID};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        
        RCDGroupInfo *groupInfo = [RCDGroupInfo mj_objectWithKeyValues:response[@"data"]];
        
        completion(groupInfo);
    }];
}

-(void) setGroupName:(NSString *)groupName groupId:(NSString *)groupId complete:(void (^)(BOOL result))result{
    
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"realName",
                             @"groupId":groupId,
                             @"name":groupName};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        
        result(YES);
    }];
}

-(void) getUserInfoByUserID:(NSString *) userID
                         completion:(void (^)(RCDUserInfo *user)) completion{
//    1.获取 自己 的 信息
    if ([userID isEqualToString:[Login curLoginUser].userId]) {
        
        // 用户头像
        RCDUserInfo *userInfo = [[RCDUserInfo alloc]initWithUserId:userID name:[Login curLoginUser].name portrait:@""];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(userInfo);
            });
        }
    }else{
    
        RCDUserInfo *RcUserInfo=[[RCDataBaseManager shareInstance] getUserByUserId:userID];
        if (RcUserInfo == nil || [RcUserInfo.name hasSuffix:@">"] || RcUserInfo.isAlso.length == 0) {
            //如果为空 请求 自己服务器获取 目标数据
            
            [[RCDHttpTool shareInstance]getUserInfoWithUserId:userID SuccessBlock:^(id response) {
                
                NSArray *tempArray = response[@"list"];
                if (tempArray.count) {
                    NSDictionary *dict = response[@"list"][0];
                    
                    RCDSearchUserInfo *chatInfo = [RCDSearchUserInfo mj_objectWithKeyValues:dict];
                    RCDUserInfo *userInfo = [[RCDUserInfo alloc]initWithUserId:chatInfo.mid name:chatInfo.realName portrait:chatInfo.photo];
                    userInfo.isAlso = dict[@"isAlso"];
                    userInfo.position = dict[@"position"];
                    userInfo.company = dict[@"company"];
                    userInfo.company = dict[@"userType"];
                    [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(userInfo);
                    });
                }
                
            } FailureBlick:^(NSError *error) {
                
            }];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(RcUserInfo);
            });
        }
    }
}

/**
 获取群组列表 注意 只能查询到 保存到通讯录的群聊 默认(没有保存的)
 */
- (void)getAllGroupsWithCompletion:(void (^)(NSMutableArray* result))completion{
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"list"};

    [TRZXNetwork requestWithUrl:nil params:params method:POST callbackBlock:^(id response, NSError *error) {
        if (!error) {
            NSMutableArray *temp = [RCDGroupInfo mj_objectArrayWithKeyValuesArray:response[@"data"]];
            completion(temp);
        }else{
            NSLog(@"%@",error);
        }
    }];
}


-(void) getMyGroupsWithBlock:(void(^)(NSMutableArray* result)) block{


}

/**
 加入群组
 */
-(void) joinGroupWithUserIds:(NSString *) userIds groupId:(NSString *)groupId complete:(void (^)(BOOL result))joinResult{
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"join",
                             @"userIds":userIds,
                             @"groupId":groupId};
    [TRZXNetwork requestWithUrl:nil params:params method:POST callbackBlock:^(id response, NSError *error) {
        if (!error) {
            joinResult(YES);
        }else{
            joinResult(NO);
        }
    }];
}

/**
 创建群组
 */
-(void) createGroupWithUserIds:(NSString *) userIds
                     groupName:(NSString *)groupName
                      complete:(void (^)(RCGroup *group))resultGroup{
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"create",
                             @"userIds":userIds,
                             @"groupName":groupName};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        NSDictionary *data = response[@"data"];
        NSArray *pics = data[@"pics"];
        RCGroup *group = [[RCGroup alloc] initWithGroupId:data[@"mid"] groupName:groupName portraitUri:pics.firstObject];
        resultGroup(group);
    }];
}

/**
 退出群组
 
 @param groupID    群组id
 @param uId        说明:uId  -- 被移除对象的id(不传这个参数标示自己主动退出群组)
 
 */
-(void) quitGroup:(NSString *) groupID userId:(NSString *)uId complete:(void (^)(BOOL result))quitResult{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"requestType":@"Group_Api",
                             @"apiType":@"remove",
                             @"groupId":groupID}];
    if (uId) {
        params[@"uId"] = uId;
    }
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (!error) {
            quitResult(YES);
        }else{
            quitResult(NO);
        }
    }];
}

/**
 群组 管理权转让
 
 @param groupID    群组id
 @param uId        转让的用户id
 */
-(void) transferGroup:(NSString *)groupID uId:(NSString *)uId complete:(void (^)(BOOL result))result{

    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"transfer",
                             @"groupId":groupID,
                             @"uId":uId};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if ([response[@"status_code"] isEqualToString:@"200"]) {
            result(YES);
        }else if(!error){
            result(NO);
        }
    }];
}

/**
 群组保存到通讯录
 */
-(void) saveGroupToList:(NSString *)groupID
           saveOrRemove:(BOOL)isSave
               complete:(void (^)(BOOL result))result{
    NSString *saveOrRemove = isSave?@"1":@"0";
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"saveToMailList",
                             @"groupId":groupID,
                             @"saveOrRemove":saveOrRemove};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if ([response[@"status_code"] isEqualToString:@"200"]) {
            result(YES);
        }else if(!error){
            result(NO);
        }
    }];
}

/**
 群组 开放关闭群邀请成员
 */
-(void)inviteGroupMemberById:(NSString *)groupID
                 closeOrOpen:(BOOL )isOpen
                    complete:(void (^)(BOOL result))result{
    
    NSString *closeOrOpen = isOpen?@"open":@"close";
    
    NSDictionary *params = @{@"requestType":@"Group_Api",
                             @"apiType":@"closeAndOpen",
                             @"groupId":groupID,
                             @"closeOrOpen":closeOrOpen};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if ([response[@"status_code"] isEqualToString:@"200"]) {
            result(YES);
        }else if(!error){
            result(NO);
        }
    }];
}


- (void)updateGroupById:(int)groupID withGroupName:(NSString*)groupName andintroduce:(NSString*)introduce complete:(void (^)(BOOL))result{
    
}


-(void) searchFriendListByName:(NSString*)name
                        pageNo:(NSUInteger)pageNo
                      complete:(void (^)(NSMutableArray* result,NSUInteger totalPage,NSUInteger pageNo))friendList{
    
    if (!name.length) {
        return  ;
    }
    
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"search",
                             @"key":name,
                             @"pageNo":[NSString stringWithFormat:@"%lu",(unsigned long)pageNo],
                             @"pageSize":@"15"};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        NSMutableArray *list = [RCDUserInfo mj_objectArrayWithKeyValuesArray:response[@"data"]];
        friendList(list,[response[@"totalPage"] integerValue],[response[@"pageNo"] integerValue]);
    }];
}

- (void)requestFriend:(NSString*)userId complete:(void (^)(BOOL))result{
    
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"apply",
                             @"otherId":userId};
      [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
            result(YES);
      }];
}

/**
 #pragma mark  获取我的好友列表
 */
-(void) requestMyFriendList:(void (^)(id data, NSError *error))block{
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"myFriend",
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST callbackBlock:^(id response, NSError *error) {
        if (response) {
            NSMutableArray *list = [RCDUserInfo mj_objectArrayWithKeyValuesArray:response[@"data"]];
            block(list, nil);
        }else{
            block(nil, error);
        }
    }];
}

/**
 查询请求的添加好友
 */
-(void)requestAddFriendListPageNo:(NSUInteger )pageNo complete:(void (^)(NSArray *addFriends, NSUInteger totalPageNo))result{

    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"applyList",
//                             @"pageNo":[NSString stringWithFormat:@"%ld",pageNo]
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST  
    callbackBlock:^(id response, NSError *error) {
        if (!error) {
            NSArray *friends = [RCDUserInfo mj_objectArrayWithKeyValuesArray:response[@"data"]];
            result(friends,[response[@"totalPage"] integerValue]);
        }else{
            NSLog(@"%@",error);
            result(nil,0);
        }
        
    }];
}

/**
 删除请求添加好友列表
 
 @param friendRelationshipId 添加id
 @param result               处理结果
 */
-(void)deleteAddFriendListWithId:(NSString *)friendRelationshipId complete:(void (^)(BOOL isSuccess))result{
    if (friendRelationshipId == nil) {
        return ;
    }
    
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"deleteApply",
                             @"friendRelationshipId":friendRelationshipId};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if ([response[@"status_code"] isEqualToString:@"200"]) {
            result(YES);
        }else if(error){
            NSLog(@"%@",error);
        }
    }];
}

// 搜索本地
-(void) searchLocal:(NSString *)key
           complete:(void (^)(id value))result{
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"searchLocal",
                             @"key":key};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (response) {
            result(response);
        }
    }];
}

//处理请求加好友
- (void)processRequestFriend:(NSString*)userId complete:(void (^)(BOOL))result{
    
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"handleApply",
                             @"friendRelationshipId":userId};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if ([response[@"status_code"] isEqualToString:@"200"]) {
            result(YES);
        }else{
            result(NO);
        }
    }];
}

- (void)deleteFriend:(NSString*)userId complete:(void (^)(BOOL))result{
    
    NSDictionary *params = @{@"requestType":@"Friend_Api",
                             @"apiType":@"delete",
                             @"otherId":userId};
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if ([response[@"status_code"] isEqualToString:@"200"]) {
            result(YES);
        }else{
            result(NO);
        }
    }];
}

- (void)updateName:(NSString*) userName
          success:(void (^)(id response))success
           failure:(void (^)(NSError* err))failure {

}

- (void)updateUserInfo:(NSString *) userID
               success:(void (^)(RCDUserInfo * user))success
               failure:(void (^)(NSError* err))failure{
    
    if(userID == nil)return;
    
    NSDictionary *params = @{@"requestType":@"Chat_Api",
                             @"apiType":@"getUserInfo",
                             @"id":userID};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if(!error){
            if ([response[@"list"] count]) {

                RCDUserInfo *user = [RCDUserInfo new];
                NSDictionary *dic = response[@"list"][0];
                user.userId = [dic objectForKey:@"mid"];
                user.portraitUri = [dic objectForKey:@"photo"];
                user.name = [dic objectForKey:@"realName"];
                user.isAlso = [dic objectForKey:@"isAlso"];
                user.position = [dic objectForKey:@"position"];
                user.userType = [dic objectForKey:@"userType"];
                user.company = [dic objectForKey:@"company"];
                [[RCDataBaseManager shareInstance] insertUserToDB:user];
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(user);
                    });
                }
            }
        }else{
            failure(error);
        }
    }];
}

//根据 ID 获取 对方信息
/**
 *  根据Id 查询对象信息
 *
 *  @param userId                  目标 userId (“id”:"用户id,id2" 多个逗号分隔开)
 *  @param SuccessBlock 成功回调
 *  @param failureBlick            失败回调
 */
-(void)getUserInfoWithUserId:(NSString *)userId SuccessBlock:(SuccessBlock)SuccessBlock FailureBlick:(FailureBlick)failureBlick{

    if (userId.length < 1)return;
    
    NSDictionary *params = @{@"requestType":@"Chat_Api",
                             @"apiType":@"getUserInfo",
                             @"id":userId};
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (response) {
            SuccessBlock(response);
        }
    }];
}

/**
 查询商业计划书
 
 @param mid                         mid
 *  @param SuccessBlock  成功回调
 *  @param failureBlick             失败回调
 */
-(void)getPlanApiDetailDataWithMid:(NSString *)mid SuccessBlock:(SuccessBlock)SuccessBlock FailureBlick:(FailureBlick)failureBlick{
    NSDictionary *params = @{
                            @"apiType":@"getPlan",
                            @"requestType":@"Business_Plan_Api",
                            @"planUser":mid,
                            };
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (!error) {
            SuccessBlock(response);
        }else{
            failureBlick(error);
        }
    }];
}


#pragma mark - 股东同意BP申请
/**
 *  股东同意BP申请
 *
 *  @param mainKeyId    主键Id
 *  @param successBlock 成功回调
 *  @param failureBlick 失败回调
 */
-(void)requestLoadData_updateByShare:(NSString *)mainKeyId SuccessBlock:(SuccessBlock)successBlock FailureBlick:(FailureBlick)failureBlick{
    
    NSDictionary *params = @{
                             @"requestType":@"ProjectzBPUser_Api",
                             @"apiType":@"updateByShare",
                             @"id":mainKeyId
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (!error) {
            successBlock(response);
        }else{
            failureBlick(error);
        }
    }];
}


#pragma mark - 投资人BP申请

/**
 投资人BP申请
 
 @param targetUserId 目标用户id
 @param successBlock 成功回调
 @param failureBlick 失败回调
 */
-(void)requestLoadData_saveByInvestor:(NSString *)targetUserId SuccessBlock:(SuccessBlock)successBlock FailureBlick:(FailureBlick)failureBlick{
    
    NSDictionary *params = @{
                             @"requestType":@"ProjectzBPUser_Api",
                             @"apiType":@"saveByInvestor",
                             @"targetUserId":targetUserId,
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST   callbackBlock:^(id response, NSError *error) {
        if (!error) {
            successBlock(response);
        }else{
            failureBlick(error);
        }
    }];
}


#pragma mark - 查询当前BP申请信息
/**
 *  投资人页面查询当前BP申请信息
 *
 *  @param targetUserId 目标用户id
 *  @param successBlock 成功回调
 *  @param failureBlick 失败回调
 */
-(void)requestLoadData_findInfo:(NSString *)targetUserId SuccessBlock:(SuccessBlock)successBlock FailureBlick:(FailureBlick)failureBlick{
    
    NSDictionary *params = @{@"requestType":@"ProjectzBPUser_Api",
                             @"apiType":@"findInfo",
                             @"targetUserId":targetUserId
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST callbackBlock:^(id response, NSError *error) {
        if (!error) {
            successBlock(response);
        }else{
            failureBlick(error);
        }
    }];
    
//    [[Kipo_NetAPIClient sharedJsonClient] requestJsonDataWithPath:[KipoServerConfig serverURL] withParams:params withMethodType:Post autoShowError:NO andBlock:^(id json, NSError *error) {
//        if (!error) {
//            NSArray *temp = [InvestorsBPInfo mj_objectArrayWithKeyValuesArray:json[@"data"]];
//            
//            [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                InvestorsBPInfo *bpInfo = (InvestorsBPInfo *)obj;
//                self.investorsData.BPInfo = bpInfo;
//            }];
//            successBlock(json);
//        }else{
//            NSLog(@"%@",error);
//        }
//        
//        
//    }];
}


@end
