//
//  EOMyWalletViewModel.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOMyWalletViewModel : NSObject



//================================================================================================

/**
 *  我的钱包
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getWalletSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;



/**
 忘记支付密码

 @param oldPassword ..
 @param newPassword ..
 @param success ..
 @param failure ..
 */
+ (void)forgetPasswordWithPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 忘记支付密码验证

 @param success ..
 @param failure ..
 */
+ (void)forgetPassSmsSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 *  流水记录
 */
+ (void)getWallet_RecordListPage:(NSString *)page inOut:(NSString *)inOut Success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  获取银行卡属性
 *
 *  @param cardNo  卡号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getCardMsgNo:(NSString *)cardNo Success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  获取用户银行卡
 *
 */
+ (void)isHadCardSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;



/**
 验证卡号

 @param account 卡号
 @param success ..
 @param failure ..
 */
+ (void)checkCard:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 验证支付密码

 @param pwd 密码
 @param success ..
 @param failure ..
 */
+ (void)checkCardPassword:(NSString *)pwd success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 *  修改密码
 *
 *  @param password    原密码
 *  @param newPassword 新密码
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+ (void)updatePasswordWithPassword:(NSString *)password newPassword:(NSString *)newPassword Success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 *  设置银行卡密码
 *
 *  @param password 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)setPasswordWithPassword:(NSString *)password Success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 *  提现
 *
 *  @param cardId  卡号
 *  @param amount  金额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)postCashCardId:(NSString *)cardId amount:(NSString *)amount Success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 解除绑定银行卡
 *
 *  @param cardId  true	String	银行卡绑定生成的id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)postWallet_deleteCardId:(NSString *)cardId Success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  绑定银行卡
 *
 *         银行卡号
 *  @param bankName true	String	银行名称
 *  @param success  成功回调
 *  @param failure  失败会掉
 */
+ (void)postAddBankCardNo:(NSString *)accNo bankName:(NSString *)bankName Success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  开始银联支付
 *
 *  @param amount  金额
 */
+ (void)rechargeableAccount:(NSString *)amount Success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end
