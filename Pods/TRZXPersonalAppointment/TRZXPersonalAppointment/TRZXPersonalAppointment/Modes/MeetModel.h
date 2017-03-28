//
//  MeetModel.h
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/24.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetModel : NSObject

@property (nonatomic, copy) NSString *teacherLoginName;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, assign) NSInteger authStatus;

@property (nonatomic, copy) NSString *commentDateStr;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *commentDate;

@property (nonatomic, copy) NSString *qxReason;

@property (nonatomic, copy) NSString *qxDate;

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, copy) NSString *studentId;

@property (nonatomic, copy) NSString *stuPhoto;

@property (nonatomic, copy) NSString *createDateTime;

@property (nonatomic, copy) NSString *lastDateTime;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *meetAddr;

@property (nonatomic, copy) NSString *timeOnce;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *commentContent;

@property (nonatomic, copy) NSString *teacherId;

@property (nonatomic, copy) NSString *stuName;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *meetDate;//时间

@property (nonatomic, copy) NSString *qxDateStr;

@property (nonatomic, copy) NSString *meetAddrName;//地点

@property (nonatomic, assign) NSInteger meetStatus;

@property (nonatomic, copy) NSString *stuPhone;

@property (nonatomic, copy) NSString *stuMobile;

@property (nonatomic, copy) NSString *teacherMobile;//专家手机

@property (nonatomic, copy) NSString *teacherPhoto;

@property (nonatomic, copy) NSString *topicContent;

@property (nonatomic, copy) NSString *myIntroduce;//我的介绍

@property (nonatomic, copy) NSString *teacherPhone;

@property (nonatomic, copy) NSString *problem;//学员问题

@property (nonatomic, copy) NSString *muchOnce;

@property (nonatomic, copy) NSString *vipPrice;

@property (nonatomic, copy) NSString *stuLoginName;

@property (nonatomic, copy) NSString *teacherName;

@end
