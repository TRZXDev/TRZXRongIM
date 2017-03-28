//
//  TRZXUser.h
//  TRZXLogin
//
//  Created by N年後 on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name; //用户姓名
@property (strong, nonatomic) NSString *mobile; //手机号码
@property (strong, nonatomic) NSString *token; //
@property (strong, nonatomic) NSString *userId; //用户id
@property (strong, nonatomic) NSString *login_status; //登录状态 1.已登录 2.未登陆



@end
