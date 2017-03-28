//
//  EOMyWalletViewModel.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOMyWalletViewModel.h"
#import "TRZXNetwork.h"


@implementation EOMyWalletViewModel


//================================================================================================

/**
 *  我的钱包
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getWalletSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *param = @{
                            @"apiType":@"myUserWallet",
                            @"requestType":@"AppPay_Api"
                            };
    
    [TRZXNetwork configHttpHeaders:@{@"equipment":@"ios",
                                     @"token":@"9bfc515a2fc0ea364a4340f38f7f47ff",
                                     @"userId":@"60a121b25cb34088987041b3b7632098"}];
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}

/**
 忘记支付密码
 
 @param oldPassword ..
 @param newPassword ..
 @param success ..
 @param failure ..
 */
+ (void)forgetPasswordWithPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSDictionary *param = @{
                          @"apiType":@"forgetPayPassword",
                          @"requestType":@"AppPay_Api",
                          @"payPassword":newPassword?newPassword:@"",
                          @"code":oldPassword?oldPassword:@""
                          };
    [TRZXNetwork configHttpHeaders:@{@"equipment":@"ios",
                                     @"token":@"9bfc515a2fc0ea364a4340f38f7f47ff",
                                     @"userId":@"60a121b25cb34088987041b3b7632098"}];
    [TRZXNetwork requestWithUrl:nil params:param method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}

/**
 忘记支付密码验证
 
 @param success ..
 @param failure ..
 */
+ (void)forgetPassSmsSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSDictionary *param = @{
                            @"apiType":@"forgetPassSms",
                            @"requestType":@"AppPay_Api"
                            };
    [TRZXNetwork configHttpHeaders:@{@"equipment":@"ios",
                                     @"token":@"9bfc515a2fc0ea364a4340f38f7f47ff",
                                     @"userId":@"60a121b25cb34088987041b3b7632098"}];
    [TRZXNetwork requestWithUrl:nil params:param method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}
/**
 *  流水记录
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getWallet_RecordListPage:(NSString *)page inOut:(NSString *)inOut Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{

    NSDictionary *param = @{
                            @"apiType":@"userPayDetails",
                            @"requestType":@"UserPayDetails_Api",
                            @"inOut":inOut?inOut:@""
                            };
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}


/**
 *  设置银行卡密码
 *
 *  @param password 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)setPasswordWithPassword:(NSString *)password Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *param = @{
                            @"apiType":@"setPayPassword",
                            @"requestType":@"AppPay_Api",
                            @"payPassword":password?password:@"",
                            };
    
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}


/**
 *  获取银行卡属性
 *
 *  @param cardNo  卡号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getCardMsgNo:(NSString *)cardNo Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSDictionary *param = @{
                            @"apiType":@"checkCard",
                            @"requestType":@"UserCard_Api",
                            @"accNo":cardNo?cardNo:@"",
                            };
    
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}

/**
 *  银行卡列表
 *
 */
+ (void)isHadCardSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 判断当前用户是否有银行卡
    NSDictionary *params = @{
                             @"requestType":@"UserCard_Api",
                             @"apiType":@"findListByPage"
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}

/**
 验证卡号
 
 @param account 卡号
 @param success ..
 @param failure ..
 */
+ (void)checkCard:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *param = @{
                            @"apiType":@"checkCard",
                            @"requestType":@"UserCard_Api",
                            @"accNo":account
                            };
    [TRZXNetwork configHttpHeaders:@{@"equipment":@"ios",
                                     @"token":@"9bfc515a2fc0ea364a4340f38f7f47ff",
                                     @"userId":@"60a121b25cb34088987041b3b7632098"}];
    [TRZXNetwork requestWithUrl:nil params:param method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}

/**
 验证支付密码
 
 @param pwd 密码
 @param success ..
 @param failure ..
 */
+ (void)checkCardPassword:(NSString *)pwd success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *param = @{
                            @"apiType":@"validatePayPwd",
                            @"requestType":@"AppPay_Api",
                            @"payPwd":pwd?pwd:@""
                            };
    [TRZXNetwork configHttpHeaders:@{@"equipment":@"ios",
                                     @"token":@"9bfc515a2fc0ea364a4340f38f7f47ff",
                                     @"userId":@"60a121b25cb34088987041b3b7632098"}];
    [TRZXNetwork requestWithUrl:nil params:param method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}
/**
 *  修改密码
 *
 *  @param password    原密码
 *  @param newPassword 新密码
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+ (void)updatePasswordWithPassword:(NSString *)password newPassword:(NSString *)newPassword Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{
                             @"requestType":@"AppPay_Api",
                             @"apiType":@"updatePayPassword",
                             @"oldPassword":password?password:@"123456",
                             @"payPassword":newPassword?newPassword:@"123456"
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}

/**
 *  提现
 *
 *  @param cardId  卡号
 *  @param amount  金额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)postCashCardId:(NSString *)cardId amount:(NSString *)amount Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    cardId = [cardId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *param = @{@"requestType":@"AppPay_Api",
                            @"apiType":@"cashApply",
                            @"cardId":cardId?cardId:@"",
                            @"amount":amount?amount:@""
                            };
    
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}



/**
 * 解除绑定银行卡
 *
 *  @param cardId  true	String	银行卡绑定生成的id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)postWallet_deleteCardId:(NSString *)cardId Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    
    NSDictionary *param = @{@"requestType":@"UserCard_Api",
                            @"apiType":@"deleteUserCard",
                            @"id":cardId?cardId:@""
                            };
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
    
}

/**
 *  绑定银行卡
 *
 *  @param accNo   银行卡号
 *  @param bankName true	String	银行名称
 *  @param success  成功回调
 *  @param failure  失败会掉
 */
+ (void)postAddBankCardNo:(NSString *)accNo bankName:(NSString *)bankName Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{

    accNo = [accNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *param = @{@"requestType":@"UserCard_Api",
                            @"apiType":@"saveUserCard",
                            @"bankName":bankName?bankName:@"",
                            @"accNo":accNo?accNo:@""
                            };
    
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}
/**
 *  开始银联支付
 *
 *  @param amount  金额
 */
+ (void)rechargeableAccount:(NSString *)amount Success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *param = @{@"requestType":@"AppPay_Api",
                            @"apiType":@"accountRecharge",
                            @"amount":amount?amount:@""
                            };
    [TRZXNetwork requestWithUrl:nil params:param method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
        if (response) {
            success(response);
        }else{
            failure(error);
        }
    }];
}

@end
