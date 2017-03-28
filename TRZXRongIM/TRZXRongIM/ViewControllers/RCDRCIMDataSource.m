//
//  RCDRCIMDelegateImplementation.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "RCDRCIMDataSource.h"
#import "RCDLoginInfo.h"
#import "RCDGroupInfo.h"
#import "RCDUserInfo.h"
#import "RCDHttpTool.h"
#import "DBHelper.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"
#import "RCDSearchUserInfo.h"

@interface RCDRCIMDataSource ()

@end

@implementation RCDRCIMDataSource

+ (RCDRCIMDataSource*)shareInstance
{
    static RCDRCIMDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];

    });
    return instance;
}


-(void) syncGroups
{
    //开发者调用自己的服务器接口获取所属群组信息，同步给融云服务器，也可以直接
    //客户端创建，然后同步
    [RCDHTTPTOOL getMyGroupsWithBlock:^(NSMutableArray *result) {
        if (result!=nil) {
            //同步群组
            [[RCIMClient sharedRCIMClient] syncGroups:result
                                         success:^{
            } error:^(RCErrorCode status) {
                
            }];
        }
    }];
    
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
    }];

}

-(void) syncFriendList:(void (^)(NSMutableArray* friends))completion{
    [RCDHTTPTOOL requestMyFriendList:^(id data, NSError *error) {
        if (data) {
            NSMutableArray *result = data;
            completion(result);
        }
    }];
}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion
{
    if ([groupId length] == 0)
        return;
    
    //开发者调自己的服务器接口根据userID异步请求数据
    [RCDHTTPTOOL getGroupByID:groupId
            successCompletion:^(RCGroup *group)
    {
                completion(group);
    }];
}

- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    
    [[RCDHttpTool shareInstance] getGroupByID:groupId successCompletion:^(RCDGroupInfo *group) {
       
        NSMutableArray *array = [NSMutableArray array];
        
        for (RCDUserInfo *userInfo in group.users) {
            if(![userInfo.userId isEqualToString:[Login curLoginUser].userId]){
                [array addObject:userInfo.userId];
            }
        }
        
        resultBlock(array);
    }];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
    {
        RCDUserInfo *user = [RCDUserInfo new];
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return ;
    }
    if([userId isEqualToString:@"kefu114"])
    {
        RCDUserInfo *user=[[RCDUserInfo alloc]initWithUserId:@"kefu114" name:@"客服" portrait:@""];
        completion(user);
        return;
    }
        //开发者调自己的服务器接口根据userID异步请求数据
        [RCDHTTPTOOL getUserInfoByUserID:userId
                              completion:^(RCDUserInfo *user) {
                                  if (user) {
                                      completion(user);
                                  }
                                  else
                                  {
                                      RCDUserInfo *user = [RCDUserInfo new];
                                      user.userId = userId;
                                      user.portraitUri = @"";
                                      user.name = [NSString stringWithFormat:@"name%@", userId];
                                      completion(user);

                                  }
                              }];
}

#pragma mark - RCIMGroupUserInfoDataSource
/**
 *  获取群组内的用户信息。
 *  如果群组内没有设置用户信息，请注意：1，不要调用别的接口返回全局用户信息，直接回调给我们nil就行，SDK会自己巧用用户信息提供者；2一定要调用completion(nil)，这样SDK才能继续往下操作。
 *
 *  @param groupId  群组ID.
 *  @param completion 获取完成调用的BLOCK.
 */
- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    //在这里查询该group内的群名片信息，如果能查到，调用completion返回。如果查询不到也一定要调用completion(nil)
    if ([groupId isEqualToString:@"22"] && [userId isEqualToString:@"30806"]) {
        completion([[RCDUserInfo alloc] initWithUserId:@"30806" name:@"我在22群中的名片" portrait:nil]);
    } else {
        RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:userId];
        
        if (userInfo) {
            completion(userInfo);
        }else{
            [[RCDHttpTool shareInstance]getUserInfoWithUserId:userId SuccessBlock:^(id json) {
                NSArray *tempArray = json[@"list"];
                if (tempArray.count) {
                    RCDSearchUserInfo *chatInfo = [RCDSearchUserInfo mj_objectWithKeyValues:json[@"list"][0]];
                    RCDUserInfo *userInfo = [[RCDUserInfo alloc]initWithUserId:chatInfo.mid name:chatInfo.realName portrait:chatInfo.photo];
                    userInfo.isAlso = chatInfo.isAlso;
                    userInfo.position = chatInfo.position;

                    [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                    completion(userInfo);
                }
            } FailureBlick:^(NSError *error) {}];
        }
        
//        }else{
//            completion(nil);//融云demo中暂时没有实现，以后会添加上该功能。app也可以自己实现该功能。
//        }
    }
}

- (void)cacheAllUserInfo:(void (^)())completion
{
    

}
- (void)cacheAllGroup:(void (^)())completion
{
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        [[RCDataBaseManager shareInstance] clearGroupsData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            for(int i = 0;i < result.count;i++){
                RCGroup *userInfo =[result objectAtIndex:i];
                [[RCDataBaseManager shareInstance] insertGroupToDB:userInfo];
            }
            completion();
        });
    }];
}

- (void)cacheAllFriends:(void (^)())completion{
    [RCDHTTPTOOL requestMyFriendList:^(id data, NSError *error) {
        if (data) {
            NSMutableArray *result = data;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [[RCDataBaseManager shareInstance] clearFriendsData];
                [result enumerateObjectsUsingBlock:^(RCDUserInfo *userInfo, NSUInteger idx, BOOL *stop) {
                    RCDUserInfo *friend = [[RCDUserInfo alloc] initWithUserId:userInfo.userId name:userInfo.name portrait:userInfo.portraitUri];
                    [[RCDataBaseManager shareInstance] insertFriendToDB:friend];
                }];
                completion();
            });
        }
    }];
}

- (void)cacheAllData:(void (^)())completion
{
    __weak RCDRCIMDataSource *weakSelf = self;
    [self cacheAllUserInfo:^{
        [weakSelf cacheAllGroup:^{
            [weakSelf cacheAllFriends:^{
                [DEFAULTS setBool:YES forKey:@"notFirstTimeLogin"];
                [DEFAULTS synchronize];
                completion();
            }];
        }];
    }];
}

- (NSArray *)getAllUserInfo:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllUserInfo];
    if (!allUserInfo.count) {
       [self cacheAllUserInfo:^{
           completion();
       }];
    }
    return allUserInfo;
}
/*
 * 获取所有群组信息
 */
- (NSArray *)getAllGroupInfo:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllGroup];
    if (!allUserInfo.count) {
        [self cacheAllGroup:^{
            completion();
        }];
    }
    return allUserInfo;
}

- (NSArray *)getAllFriends:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllFriends];
    if (!allUserInfo.count) {
        [self cacheAllFriends:^{
            completion();
        }];
    }
    return allUserInfo;
}
@end
