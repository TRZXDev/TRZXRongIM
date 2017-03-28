//
//  shoucangModel.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/18.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyData,Collectioned;
@interface ShoucangModel : NSObject
@property (nonatomic, copy) NSString *equipment;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSMutableArray<MyData *> *data;

@property (nonatomic, copy) NSString *status_code;

@property (nonatomic, assign) NSInteger pageNo;


@property (nonatomic, copy) NSString *status_dec;

@property (nonatomic, copy) NSString *requestType;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface MyData : NSObject<NSCoding>

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *collectionType;

@property (nonatomic, copy) NSString *deleted;


@property (nonatomic, copy) NSString *roadshowType;


@property (nonatomic, assign) long long createDate;

@property (nonatomic, strong) Collectioned *collectioned;

@end

@interface Collectioned : NSObject<NSCoding>

@property (nonatomic, copy) NSString *teachCompany;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *projectAbs;

@property (nonatomic, copy) NSString *individualResume;

@property (nonatomic, copy) NSString *head_img;

@property (nonatomic, copy) NSString *focusTrades;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *ePosition;

@property (nonatomic, copy) NSString *lookCount;

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *rate;



@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSArray *urls;


@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *meetCount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *href;

@property (nonatomic, copy) NSString *expertPhoto;

@property (nonatomic, copy) NSString *teachPosition;

@property (nonatomic, copy) NSString *teachName;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *userPic;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *clickRate;

@property (nonatomic, copy) NSString *financeAmount;

@property (nonatomic, copy) NSString *shareDealId;

@property (nonatomic, copy) NSString *shareDeal;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *tradeInfo;

@property (nonatomic, copy) NSString *otherName;

@property (nonatomic, copy) NSString *briefIntroduction;

@property (nonatomic, copy) NSString *areaName;//阶段

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *collectionStatus;



//@property (nonatomic, copy) NSString *otherName;
//
//@property (nonatomic, copy) NSString *briefIntroduction;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *headImg;

@end

