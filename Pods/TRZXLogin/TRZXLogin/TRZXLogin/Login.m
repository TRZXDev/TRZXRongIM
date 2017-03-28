//
//  TRZXLoginViewModel.m
//  TRZXLogin
//
//  Created by N年後 on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "Login.h"
#import "GetUUID.h"
#import <CommonCrypto/CommonDigest.h>
#import "MJExtension.h"
#define kLoginStatus @"login_status"
#define kLoginUserDict @"user_dict"
#define kLoginDataListPath @"login_data_list_path.plist"
static User *curLoginUser;


@interface Login ()
@property (readwrite, nonatomic, strong) NSString *loginType;// 1手机号登录 2.微信登录
@property (readwrite, nonatomic, strong) NSString *loginCode;// 登录账号
@property (readwrite, nonatomic, strong) NSString *password;// 登录密码
@end

@implementation Login




-(void)setType:(NSString*)type mobile:(NSString*)mobile psd:(NSString*)psd{
    self.loginType = type;
    self.loginCode = mobile;
    self.password = psd;
}

//支持双加密方式
//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString isUppercase:(BOOL)isUppercase{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    //    CC_MD5( cStr, strlen(cStr), digest );
    CC_MD5(cStr, (uint32_t)strlen(cStr), digest);

    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];

    if (isUppercase) {
        return   [result uppercaseString];
    }else{
        return result;
    }
    
}


-(NSDictionary *)toLoginParams{

    NSString*password=[self getMd5_32Bit_String:self.password isUppercase:NO];
    NSDictionary *params = @{@"requestType" :@"Login_Api",
                             @"loginType" :self.loginType,
                             @"loginCode" :self.loginCode,
                             @"password" :password,
                             @"deviceToken" :[GetUUID getUUID]};

    NSLog(@">>>>>>>>>>>>>>UUID=%@",[GetUUID getUUID]);

    return params;
}





// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_login {

    if (!_requestSignal_login) {
        _requestSignal_login = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            [TRZXNetwork requestWithUrl:nil params:self.toLoginParams method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {

                if (response) {
                    [[self class] doLogin:response];
                    [subscriber sendNext:self];
                    [subscriber sendCompleted];

                }else{
                    [subscriber sendError:error];
                }
            }];
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{

                [TRZXNetwork cancelRequestWithURL:@""];
            }];
        }];
    }
    return _requestSignal_login;
}


+ (BOOL)isLogin{
    NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
    if (loginStatus.boolValue && [Login curLoginUser]) {
        User *loginUser = [Login curLoginUser];
        if (loginUser.login_status && loginUser.login_status.integerValue == 0) {
            return NO;
        }
        return YES;
    }else{
        return NO;
    }
}


+ (void)doLogin:(NSDictionary *)loginData{



    if (loginData) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];
        [defaults setObject:loginData forKey:kLoginUserDict];
        curLoginUser = [User mj_objectWithKeyValues:loginData];
        [defaults synchronize];
        [Login setXGAccountWithCurUser];

        [self saveLoginData:loginData];
    }else{
        [Login doLogout];
    }
}
// 退出登录
+ (void) doLogout{

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
    [defaults synchronize];


    //删掉 coding 的 cookie
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.domain hasSuffix:@".mmwipo.com"]) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
//        }
//    }];
    [Login setXGAccountWithCurUser];

}

+ (void)setXGAccountWithCurUser{
    if ([self isLogin]) {
        User *user = [Login curLoginUser];
        if (user && user.token.length > 0) {
            NSString *global_key = user.token;
            
            // 设置推送的token
            [self registerPush];
        }
    }else{
        // 设置推送token为nil
        //注销设备，设备不再进行推送

    }
}

// 获取登录数据路径
+ (NSString *)loginDataListPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:kLoginDataListPath];
}

// 读取登录数据
+ (NSMutableDictionary *)readLoginDataList{
    NSMutableDictionary *loginDataList = [NSMutableDictionary dictionaryWithContentsOfFile:[self loginDataListPath]];
    if (!loginDataList) {
        loginDataList = [NSMutableDictionary dictionary];
    }
    return loginDataList;
}
// 保存数据也
+ (BOOL)saveLoginData:(NSDictionary *)loginData{
    BOOL saved = NO;
    if (loginData) {
        NSMutableDictionary *loginDataList = [self readLoginDataList];
        User *curUser = [User mj_objectWithKeyValues:loginData];
        if (curUser.token.length > 0) {
            [loginDataList setObject:loginData forKey:curUser.token];
            saved = YES;
        }
        if (curUser.userId.length > 0) {
            [loginDataList setObject:loginData forKey:curUser.userId];
            saved = YES;
        }
        if (curUser.mobile.length > 0) {
            [loginDataList setObject:loginData forKey:curUser.mobile];
            saved = YES;
        }
        if (saved) {
            saved = [loginDataList writeToFile:[self loginDataListPath] atomically:YES];
        }
    }
    return saved;
}




+ (User *)curLoginUser{
    if (!curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        curLoginUser = loginData? [User mj_objectWithKeyValues:loginData]: nil;
    }
    return curLoginUser;
}
+(BOOL)isLoginUserToken:(NSString *)token{
    if (token.length <= 0) {
        return NO;
    }
    return [[self curLoginUser].token isEqualToString:token];
}

#pragma mark XGPush
+ (void)registerPush{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    }
}


@end
