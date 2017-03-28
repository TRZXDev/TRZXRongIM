//
//  OneToOneDetailModel.h
//  tourongzhuanjia
//
//  Created by 移动微 on 16/2/4.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OneToOneInfoData1,OneToOneInfoOstList,OneToOneInfoMeet;


@interface OneToOneDetailModel : NSObject
// 专家列表


@property (nonatomic, copy) NSString *iosOnline;

@property (nonatomic, copy) NSString *totalPage;

@property (nonatomic, copy) NSString *status_dec;

@property (nonatomic, copy) NSArray *sessionUserType;

// 学员评价
@property (nonatomic, strong) OneToOneInfoMeet *meet;

@property (nonatomic, copy) NSString *canMeet;

// 专家头像数据
@property (nonatomic, strong) OneToOneInfoData1  *data;

@property (nonatomic, assign) NSInteger collectFlag;

@property (nonatomic, assign) NSInteger meetTotalCount;

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, assign) NSInteger status_code;

@property (nonatomic, copy) NSString *pageSize;

@property (nonatomic, copy) NSString *equipment;

@property (nonatomic, copy) NSString *requestType;

@property (nonatomic, copy) NSString *userId;

@end

@interface OneToOneInfoMeet : NSObject

@property (nonatomic, copy) NSString *teacherLoginName;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, copy) NSString *isUpdated;

@property (nonatomic, copy) NSString *authStatus;

@property (nonatomic, copy) NSString *meetWeek;

@property (nonatomic, copy) NSString *commentDateStr;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *commentDate;

@property (nonatomic, copy) NSString *qxReason;

@property (nonatomic, copy) NSString *qxDate;

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, copy) NSString *lastDateTime;

@property (nonatomic, copy) NSString *studentId;

@property (nonatomic, copy) NSString *stuPhoto;

@property (nonatomic, copy) NSString *createDateTime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *timeOnce;

@property (nonatomic, copy) NSString *meetAddr;

@property (nonatomic, copy) NSString *stuMobile;

@property (nonatomic, copy) NSString *commentContent;

@property (nonatomic, copy) NSString *teacherMobile;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *teacherId;

@property (nonatomic, copy) NSString *stuName;

@property (nonatomic, copy) NSString *stuPhone;

@property (nonatomic, copy) NSString *meetDate;

@property (nonatomic, copy) NSString *qxDateStr;

@property (nonatomic, copy) NSString *meetAddrName;

@property (nonatomic, copy) NSString *meetStatus;

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
// 专家头像信息
@interface OneToOneInfoData1 : NSObject

@property (nonatomic, copy) NSString *picTitle;

@property (nonatomic, copy) NSString *relatedLink;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *openMeetSign;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *epId;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *area;
//专家话题
@property (nonatomic, copy) NSArray<OneToOneInfoOstList *> *ostList;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) NSString *individualResume;

@property (nonatomic, copy) NSString *trade;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *expertPhoto;

@property (nonatomic, copy) NSString *meetCount;

@property (nonatomic, copy) NSString *collectFlag;

@property (nonatomic, copy) NSString *collectStatus;

@property (nonatomic, copy) NSString *defaultPic;

@end

@interface OneToOneInfoOstList : NSObject

@property (nonatomic, copy) NSString *vipOnce;
@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *openMeetSign;

@property (nonatomic, copy) NSString *oneAreaId;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *twoAreaId;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *muchOnce;

@property (nonatomic, copy) NSString *epId;

@property (nonatomic, copy) NSString *topicType;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, copy) NSString *timeOnce;

@property (nonatomic, copy) NSString *oneAreaStr;

@property (nonatomic, copy) NSString *twoAreaStr;

@property (nonatomic, copy) NSString *auditStatus;

@property (nonatomic, copy) NSString *auditOpinion;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *topicContent;

@property (nonatomic, copy) NSString *auditDate;

@property (nonatomic, copy) NSString *mentId;

@end

