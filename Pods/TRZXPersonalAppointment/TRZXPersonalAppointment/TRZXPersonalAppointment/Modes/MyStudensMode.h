//
//  MyStudensMode.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/24.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StudenData;
@interface MyStudensMode : NSObject


@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<StudenData *> *data;

@property (nonatomic, copy) NSString *status_code;

@property (nonatomic, copy) NSString *status_dec;

@property (nonatomic, copy) NSString *ingCount;

@property (nonatomic, copy) NSString *completeCount;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, assign) NSInteger totalPage;

@end
@interface StudenData : NSObject

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

@property (nonatomic, copy) NSString *isUpdated;

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

@property (nonatomic, copy) NSString *teacherName;

@property (nonatomic, copy) NSString *problem;

@end

