//
//  RCDUserInfo.h
//  tourongzhuanjia
//
//  Created by 移动微 on 16/5/17.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDSearchUserInfo : NSObject
/**
 *  姓名
 */
@property(nonatomic,copy)NSString *name;
/**
 *  用户Id
 */
@property(nonatomic,copy)NSString *mid;
/**
 *  用户头像
 */
@property(nonatomic,copy)NSString *photo;

/**
 *  职位
 */
@property(nonatomic,copy)NSString *position;

/**
 *  真实姓名
 */
@property(nonatomic,copy)NSString *realName;

@property(nonatomic,copy)NSString *isAlso;

@end
