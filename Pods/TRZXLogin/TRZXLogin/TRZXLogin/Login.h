//
//  TRZXLoginViewModel.h
//  TRZXLogin
//
//  Created by N年後 on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"
#import "User.h"
@interface Login : NSObject



// 1手机号登录 2.微信登录
-(void)setType:(NSString*)type mobile:(NSString*)mobile psd:(NSString*)psd;
@property (strong, nonatomic) RACSignal *requestSignal_login; ///< 网络请求信号量


+ (BOOL) isLogin; // 是否登录
+ (void) doLogin:(NSDictionary *)loginData; // 更新用户数据
+ (void) doLogout; // 退出登录
+ (User *)curLoginUser; // 当前登录用户
+ (void)setXGAccountWithCurUser;//
+ (NSMutableDictionary *)readLoginDataList; //读取登录用户数据
+(BOOL)isLoginUserToken:(NSString *)token; // 是否登录用户的token


/**
 *  注册推送
 */
+ (void)registerPush; //注册推送

@end
