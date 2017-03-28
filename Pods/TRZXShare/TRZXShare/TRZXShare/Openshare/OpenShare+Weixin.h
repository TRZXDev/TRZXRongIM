//
//  OpenShare+Weixin.h
//  openshare
//
//  Created by LiuLogan on 15/5/18.
//  Copyright (c) 2015年 OpenShare <http://openshare.gfzj.us/>. All rights reserved.
//

#import "OpenShare.h"

@interface OpenShare (Weixin)
/**
 *  https://open.weixin.qq.com 在这里申请
 *
 *  @param appId AppID
 */
+(void)connectWeixinWithAppId:(NSString *)appId secret:(NSString *)secret;
+(BOOL)isWeixinInstalled;

+(void)shareToWeixinSession:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)shareToWeixinTimeline:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)shareToWeixinFavorite:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)WeixinAuth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail;
+(void)WeixinPay:(NSString*)link Success:(paySuccess)success Fail:(payFail)fail;

/**
 *  扩展微信登录返回微信信息
 *
 */
+ (void)WeixinAuth:(void (^)(NSDictionary *data, NSError *error))completionHandler;


@end
