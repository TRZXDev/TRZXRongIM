//
//  RCDAnnouncementModel.h
//  TRZX
//
//  Created by 移动微 on 16/9/2.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>
///  投融公告数据模型
@interface RCDAnnouncementModel : NSObject

@property(nonatomic,copy)NSString *msgTitle;

@property(nonatomic,copy)NSString *msgDigest;

@property(nonatomic,assign)long long updateTime;

@property(nonatomic,strong)NSArray *sessionUserType;

@property(nonatomic,strong)NSString *time;

@property(nonatomic,strong)NSString *sessionUserTypeStr;

@property(nonatomic,strong)NSString *vip;

@property(nonatomic,strong)NSString *iosOnline;

@end
