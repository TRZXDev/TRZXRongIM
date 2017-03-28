//
//  RongImUserLogin.h
//  tourongzhuanjia
//
//  Created by 移动微 on 16/3/15.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RongImUserLoginNotifi @"RongImUserLoginNotifi"

typedef void(^LoginBlock)(BOOL Success);

/**
 *  登录融云
 */
@interface TRZXRongIMLogin : NSObject

/**
 *  创建单例
 *
 *  @return 返回实例对象
 */
+(instancetype)shreadInstance;

/**
 *  融云用户登录
 */
- (void)login:(LoginBlock)loginBlock;

/**
 推出登录
 */
- (void)logout;

@end
