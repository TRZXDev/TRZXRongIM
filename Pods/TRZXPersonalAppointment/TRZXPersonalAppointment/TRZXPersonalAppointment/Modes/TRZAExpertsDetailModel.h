//
//  ExpertsDetailModel.h
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/17.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data,Ostlist;
@interface TRZAExpertsDetailModel : NSObject

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) Data *data;

//@property (assign, nonatomic)int collectFlag;//收藏状态

@property (nonatomic, copy) NSString *iosOnline;

@property (nonatomic, copy) NSString *status_code;

@property (nonatomic, copy) NSString *collectFlag;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *status_dec;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) BOOL canMeet;





@end
@interface Data : NSObject

@property (nonatomic, copy) NSString *picTitle;

@property (nonatomic, copy) NSString *relatedLink;

@property (nonatomic, copy) NSString *realName;

//@property (nonatomic, copy) NSString *collectFlag;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *expertPhoto;

@property (nonatomic, copy) NSString *defaultPic;

@property (nonatomic, copy) NSString *headImg;


@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *epId;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, strong) NSArray<Ostlist *> *ostList;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) NSString *individualResume;

@property (nonatomic, copy) NSString *trade;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *meetCount;

@property (nonatomic, copy) NSString *openMeetSign;

@end

@interface Ostlist : NSObject

@property (nonatomic, copy) NSString *auditDate;

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *mentId;

@property (nonatomic, copy) NSString *topicType;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *muchOnce;
@property (nonatomic, copy) NSString *vipOnce;


@property (nonatomic, copy) NSString *epId;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, copy) NSString *timeOnce;

@property (nonatomic, copy) NSString *auditStatus;

@property (nonatomic, copy) NSString *auditOpinion;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *topicContent;

@property (nonatomic, copy) NSString *oneAreaId;

@property (nonatomic, copy) NSString *twoAreaId;

@end

