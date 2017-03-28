//
//  RongImUserLogin.m
//  tourongzhuanjia
//
//  Created by 移动微 on 16/3/15.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "TRZXRongIMLogin.h"

#import "RCDTestMessage.h"
#import "RCDRCIMDataSource.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "RCDLoginInfo.h"
#import "RCDChatViewController.h"
#import "RCDataBaseManager.h"
//#import "InvestorsNetworkTool.h"
#import "RCDBusinessCardMessage.h"
#import "RCDSearchUserInfo.h"
#import "RCDCollectionCell.h"
#import "RCDCollectionMessage.h"
//#import "KipoUpLocationManage.h"
#import "RCDRedPacketsMessage.h"
#import "RCDPublicMessage.h"
#import "RCDCommonDefine.h"

@interface TRZXRongIMLogin()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,UIAlertViewDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
// 判断用户是否登录
@property(nonatomic,assign)BOOL isUserLogin;
@end

@implementation TRZXRongIMLogin

static TRZXRongIMLogin *instance;
static dispatch_once_t oneToken;
/**
 *  创建单例
 *
 *  @return 返回实例对象
 */
+(instancetype)shreadInstance{
    
    dispatch_once(&oneToken, ^{
        instance = [[TRZXRongIMLogin alloc]init];
    });
    
    return instance;
}

-(void)tearDown{
    instance = nil;
    
    oneToken=0;
}

/**
 *  封装的自动登录
 */
-(void)login:(LoginBlock)loginBlock{
    if (self.isUserLogin) {
        loginBlock(YES);
    }else{
        [self RongIMLogin:loginBlock];
        [self romgCloundConfigure];
    }
}

- (void)logout{
    [[RCIM sharedRCIM] logout];
    [self tearDown];
}

// 融云设置
-(void)romgCloundConfigure{

    // 注册自定义测试消息
    [[RCIM sharedRCIM] registerMessageType:[RCDTestMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCDBusinessCardMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCDCollectionMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCRealTimeLocationStartMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCRealTimeLocationEndMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCDRedPacketsMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCDPublicMessage class]];
    
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(50, 50);
    // 在 RCIM.h 中通过设置 enableMessageMentioned 开启 @ 消息功能，默认为关闭状态。
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    [RCCall sharedRCCall].groupMemberDataSource = RCDDataSource;
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
    //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    // 设置当前 头像圆角
    
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus=YES;
    //开启发送已读回执（只支持单聊）
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];    
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    if ([userId containsString:@","]) {
        NSArray *array = [userId componentsSeparatedByString:@","];
        BOOL isPull = NO;
        for (NSString *newUserId in array) {
            RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:newUserId];
            if (userInfo == nil) {
                isPull = YES;
            }
        }
        if (isPull) {
            NSString *lastString = array.lastObject;
            for (NSString *newUserId in array) {
                [[RCDHttpTool shareInstance]getUserInfoWithUserId:newUserId SuccessBlock:^(id json) {
                    
                    NSArray *tempArray = json[@"list"];
                    if (tempArray.count) {
                        RCDSearchUserInfo *chatInfo = [RCDSearchUserInfo mj_objectWithKeyValues:json[@"list"][0]];
                        RCDUserInfo *userInfo = [[RCDUserInfo alloc]initWithUserId:chatInfo.mid name:chatInfo.realName portrait:chatInfo.photo];
                        
                        [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                        if ([lastString isEqualToString:newUserId]) {
                            [self pullCallBackWithUserId:userId Completion:completion];
                        }
                    }
                    
                } FailureBlick:^(NSError *error) {
                    RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:userId];
                    completion(userInfo);
                }];
            }
        }else{
            [self pullCallBackWithUserId:userId Completion:completion];
        }
        
    }else{
        
        RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:userId];
        if (userInfo == nil) {
            
            [[RCDHttpTool shareInstance]getUserInfoWithUserId:userId SuccessBlock:^(id json) {
                
                NSArray *tempArray = json[@"list"];
                if (tempArray.count) {
                    RCDSearchUserInfo *chatInfo = [RCDSearchUserInfo mj_objectWithKeyValues:json[@"list"][0]];
                    RCDUserInfo *userInfo = [[RCDUserInfo alloc]initWithUserId:chatInfo.mid name:chatInfo.realName portrait:chatInfo.photo];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                        completion(userInfo);
                    });
                }
                
            } FailureBlick:^(NSError *error) {}];
        }else{
            completion(userInfo);
        }
    }
}


-(void)pullCallBackWithUserId:(NSString *)userId Completion:(void (^)(RCDUserInfo *))completion{
    
    NSString *userName = @"";
    NSArray *array = [userId componentsSeparatedByString:@","];
    for (NSString *newUserId in array) {
        RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:newUserId];
        userName = [NSString stringWithFormat:@"%@,%@",userName,userInfo.name.length?userInfo.name:@""];
    }
    if (userName.length > 1) {
        userName = [userName substringFromIndex:1];
    }
    RCDUserInfo *userInfo = [[RCDUserInfo alloc] initWithUserId:userId name:userName portrait:nil];
    completion(userInfo);
}

//自己后台融云登录
-(void)RongIMLogin:(LoginBlock)loginBlock{
    
    [RCDHTTPTOOL getChatTokenCompletion:^(id data, NSError *error) {

        if (data) {
            [[RCIM sharedRCIM] connectWithToken:data[@"token"] success:^(NSString *userId) {

                RCDUserInfo *user = [[RCDataBaseManager shareInstance] getUserByUserId:[Login curLoginUser].userId];
                if (![user.name hasSuffix:@">"] && user.name.length) {
                    [RCIM sharedRCIM].currentUserInfo = [[RCDataBaseManager shareInstance] getUserByUserId:[Login curLoginUser].userId];
                    [RCIMClient sharedRCIMClient].currentUserInfo = [[RCDataBaseManager shareInstance] getUserByUserId:[Login curLoginUser].userId];
                }else{
                    [[RCDHttpTool shareInstance] updateUserInfo:[Login curLoginUser].userId success:^(RCDUserInfo *user) {
                        [RCIM sharedRCIM].currentUserInfo = user;
                        [RCIMClient sharedRCIMClient].currentUserInfo = user;
                    } failure:^(NSError *err) {
                    }];
                }

                loginBlock(YES);
                self.isUserLogin = YES;
            [RCDHTTPTOOL requestMyFriendList:^(id data, NSError *error) {
                if (data) {
                    NSMutableArray *result = data;
                    for (RCDUserInfo *userInfo in result) {
                        [[RCDataBaseManager shareInstance] insertFriendToDB:userInfo];
                    }
                }
            }];

            } error:^(RCConnectErrorCode status) {

            } tokenIncorrect:^{



            }];
        }
    }];
}

#pragma mark - 融云登录 ︾︾︾︾︾︾︾︾︾︾︾︾︾︾︾︾
/**
 *  登陆
 */
- (void)login:(NSString *)userName password:(NSString *)password loginBlock:(LoginBlock)gobackBLock
{
    RCNetworkStatus stauts=[[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    
    if (RC_NotReachable == stauts) {
        // 融云提示
//        [LCProgressHUD showInfoMsg:@"当前网络不可用，请检查！"]; // 显示提示
        return;
    } else {

    }



    
}





/**
 *  融云登录登录完成回调 获取了 token值方法
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param token    token 值
 *  @param userId   用户ID
 */
- (void)loginSuccess:(NSString *)userName password:(NSString *)password token:(NSString *)token userId:(NSString *)userId loginBlock:(LoginBlock)gobackBLock
{
    //保存默认用户
//    [DEFAULTS setObject:userName forKey:@"RongIMuserName"];
//    [DEFAULTS setObject:password forKey:@"RongIMuserPwd"];
//    [DEFAULTS setObject:token forKey:@"RongIMuserToken"];
//    [DEFAULTS setObject:userId forKey:@"RongIMuserId"];
//    [DEFAULTS synchronize];
    
    //设置当前的用户信息
    RCDUserInfo *_currentUserInfo = [[RCDUserInfo alloc]initWithUserId:userId name:userName portrait:nil];
    [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
    
    [RCDHTTPTOOL getUserInfoByUserID:userId
                          completion:^(RCDUserInfo* user) {
                              [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:userId];
                              [DEFAULTS setObject:user.portraitUri forKey:@"RongIMuserPortraitUri"];
                              [DEFAULTS setObject:user.name forKey:@"RongIMuserNickName"];
                              [DEFAULTS synchronize];
                          }];
    //同步群组
    [RCDDataSource syncGroups];
    [RCDDataSource syncFriendList:^(NSMutableArray *friends) {}];
    BOOL notFirstTimeLogin = [DEFAULTS boolForKey:@"notFirstTimeLogin"];
    if (!notFirstTimeLogin) {
        [RCDDataSource cacheAllData:^{ //auto saved after completion.
            //                                                   [DEFAULTS setBool:YES forKey:@"notFirstTimeLogin"];
            //                                                   [DEFAULTS synchronize];
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
//        UINavigationController *rootNavi = [storyboard instantiateViewControllerWithIdentifier:@"rootNavi"];
////        [ShareApplicationDelegate window].rootViewController = rootNavi;
        
        gobackBLock(YES);
    });
}



#pragma mark - RCIMConnectionStatusDelegate 融云网络连接状态代理
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_TOKEN_INCORRECT||
        status == RC_MSG_RESPONSE_TIMEOUT) {
        [self RongIMLogin:nil];
        
//        NSDictionary *params = @{@"requestType":@"LogFromApp_Api",
//                                 @"apiType":@"save",
//                                 @"code":[NSString stringWithFormat:@"%ld",status]};
//        [[Kipo_NetAPIClient sharedJsonClient] requestJsonDataWithPath:[KipoServerConfig serverURL] withParams:params withMethodType:Post autoShowError:NO andBlock:^(id json, NSError *error) {
//            
//            if (!error) {
//                NSLog(@"成功了");
//            }else{
//                NSLog(@"失败了");
//            }
//        }];
        
    }
}


// 点击确定 重新登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{


}


-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg=(RCInformationNotificationMessage *)message.content;
        //NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        if ([msg.message rangeOfString:@"你已添加了"].location!=NSNotFound) {
            [RCDDataSource syncFriendList:^(NSMutableArray *friends) {
            }];
        }
    }
}


/**
 *  直接跳转融云聊天方法
 *
 *  @param ViewController 传入当前控制器
 *  @param targetId       目标对象id
 */
+(void)jumpRongCloudChatVCWithViewController:(UIViewController *)ViewController TargetId:(NSString *)targetId{

//    身份判断
//    if ([KPOUserDefaults currentSessionUserTypeIsUser]) {
//        [self isUserLimit];
//    }

    if ([targetId isEqualToString:[Login curLoginUser].userId]) {
//     融云提示
//        [LCProgressHUD showInfoMsg:@"不能和自己聊天"]; // 显示提示
        return;
    }

    [[self shreadInstance] jumpRongCloudChatVCWithViewController:ViewController TargetId:targetId];

    
}
/**
 *  跳转控制器 (拿到目标Id 进行查询)
 *
 *  @param ViewController 目标控制器
 *  @param targetId       目标Id
 */
-(void)jumpRongCloudChatVCWithViewController:(UIViewController *)ViewController TargetId:(NSString *)targetId{
    
    __block RCDUserInfo *RcUserInfo=[[RCDataBaseManager shareInstance] getUserByUserId:targetId];
    if (RcUserInfo == nil) {
        //如果为空 请求 自己服务器获取 目标数据
        // 查询目标 id 信息
        [[RCDHttpTool shareInstance] getUserInfoWithUserId:targetId SuccessBlock:^(id json) {
            if ([json[@"list"] count] == 0) {
                return;
            }
            RCDSearchUserInfo * chatInfo = [RCDSearchUserInfo mj_objectWithKeyValues:json[@"list"][0]];
            
            RcUserInfo = [[RCDUserInfo alloc]initWithUserId:chatInfo.mid name:chatInfo.realName  portrait:chatInfo.photo];
            
            if (!RcUserInfo.userId) {
                return;
            }
            
            [[RCDataBaseManager shareInstance] insertUserToDB:RcUserInfo];
            [self jumpRongCloudChatVCWithViewController:ViewController RCUserInfo:RcUserInfo];
            
        } FailureBlick:^(NSError *error) {
            
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self jumpRongCloudChatVCWithViewController:ViewController RCUserInfo:RcUserInfo];
        });
    }
}

/**
 *  跳转控制器
 *
 *  @param ViewController 目标控制器
 *  @param UserInfo       数据库里的用户数据
 */
-(void)jumpRongCloudChatVCWithViewController:(UIViewController *)ViewController RCUserInfo:(RCDUserInfo*)UserInfo{

    // 用户权限设置
//    __block BOOL isUser;
    // 身份判断
//    [[KPOUserDefaults sessionUserType] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isEqualToString:@"User"]) {
//            isUser = YES;
//        }
//    }];
    
    RCConversation *conversation = [[RCConversation alloc]init];
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = UserInfo.userId;
    conversation.conversationTitle = UserInfo.name;
    
    RCConversationModel *model = [[RCConversationModel alloc]init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:conversation extend:nil];
    model.isTop = false;
    model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_NORMAL;
    model.conversationType = ConversationType_PRIVATE;
    model.objectName = @"RC:TxtMsg";
    
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    _conversationVC.conversationType = model.conversationType;
    _conversationVC.targetId = model.targetId;
    _conversationVC.userName = model.conversationTitle;
    _conversationVC.title = model.conversationTitle;
    _conversationVC.conversation = model;
    _conversationVC.unReadMessage = model.unreadMessageCount;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
    if (model.conversationType == ConversationType_SYSTEM) {
        _conversationVC.userName = @"系统消息";
        _conversationVC.title = @"系统消息";
    }
    _conversationVC.isChangeEdgeTopBool = YES;
//    _conversationVC.closeInputBool = YES;
    [ViewController.navigationController pushViewController:_conversationVC animated:YES];
    
}


/**
 *  程序系统的时候 根据 token 登录融云
 */
+(void)RongCloudLoginWithToken{
    [[self shreadInstance] RongCloudLoginWithToken];
}
-(void)RongCloudLoginWithToken{
    
    NSString *keyStr = [Login curLoginUser].userId;
    if (keyStr != nil) {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:keyStr];
    
        if (token != nil) {
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                self.isUserLogin = YES;
                
                
            } error:^(RCConnectErrorCode status) {

            } tokenIncorrect:^{
            }];
        }
    }
}

+(void)isUserLimit{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未认证用户,禁止使用私信功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

@end
