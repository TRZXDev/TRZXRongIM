//
//  RCDBPInfo.h
//  TRZXRongIM
//
//  Created by 移动微 on 17/3/20.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 BP 信息
 */
@interface RCDBPInfo : NSObject

@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSString *targetCompany;

@property(nonatomic,copy)NSString *position;

@property(nonatomic,copy)NSString *targetPhoto;

//自己公司
@property(nonatomic,copy)NSString *company;

@property(nonatomic,copy)NSString *targetPosition;

@property(nonatomic,copy)NSString *photo;

@property(nonatomic,copy)NSString *userId;//自己的 usreId

@property(nonatomic,copy)NSString *businessPlan;

@property(nonatomic,copy)NSString *mid;

@property(nonatomic,copy)NSString *logo;// 项目图片

@property(nonatomic,copy)NSString *projectzId;

@property(nonatomic,copy)NSString *targetUserId;//对象的 userId

// 0=投资人申请BP，1=股东投递BP
@property(nonatomic,assign)int type;

@property(nonatomic,copy)NSString *targetNickName;

@property(nonatomic,copy)NSString *nickName;

@property(nonatomic,copy)NSString *projectzName;

@property(nonatomic,copy)NSString *briefIntroduction;

@property(nonatomic,copy)NSString *userType;//用户类型

@property(nonatomic,copy)NSString *targetUserType;//目标用户类型

@property(nonatomic,copy)NSString *targetRealName;

@property(nonatomic,copy)NSString *realName;
/**
 *  项目简介
 */
@property(nonatomic,copy)NSString *projectAbs;

/**
 *  项目创建者
 */
@property(nonatomic,copy)NSString *createById;

@end
