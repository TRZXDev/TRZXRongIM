//
//  SrudensDetailed.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/24.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data1;
@interface SrudensDetailed : NSObject

@property (nonatomic, copy) NSString *status_dec;

@property (nonatomic, strong) Data1 *data;

@property (nonatomic, copy) NSString *status_code;

@property (nonatomic, copy) NSString *vip;


@end
@interface Data1 : NSObject

@property (nonatomic, copy) NSString *teacherLoginName;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, assign) NSInteger authStatus;

@property (nonatomic, copy) NSString *commentDateStr;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *commentDate;

@property (nonatomic, copy) NSString *qxReason;

@property (nonatomic, copy) NSString *qxDate;

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, copy) NSString *studentId;

@property (nonatomic, copy) NSString *stuPhoto;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *timeOnce;

@property (nonatomic, copy) NSString *meetAddr;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *commentContent;

@property (nonatomic, copy) NSString *teacherId;

@property (nonatomic, copy) NSString *stuName;

@property (nonatomic, copy) NSString *stuPhone;

@property (nonatomic, copy) NSString *meetDate;

@property (nonatomic, copy) NSString *qxDateStr;

@property (nonatomic, copy) NSString *meetAddrName;

@property (nonatomic, assign) NSInteger meetStatus;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *teacherPhoto;

@property (nonatomic, copy) NSString *topicContent;

@property (nonatomic, copy) NSString *myIntroduce;

@property (nonatomic, copy) NSString *teacherPhone;

@property (nonatomic, copy) NSString *stuLoginName;

@property (nonatomic, copy) NSString *muchOnce;

@property (nonatomic, copy) NSString *vipPrice;

@property (nonatomic, copy) NSString *teacherName;

@property (nonatomic, copy) NSString *problem;

@property (nonatomic, copy) NSString *stuMobile;

@end

