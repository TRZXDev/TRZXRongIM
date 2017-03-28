//
//  TRZXRecommendModel.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/9.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRZXRecommendCoursez, TRZXRecommendExpertTopic, TRZXRecommendInvestor;

@interface TRZXRecommendModel : NSObject

/**
 推荐课程
 */
@property (nonatomic, strong) NSArray <TRZXRecommendCoursez *> *coursezList;

/**
 推荐一对一咨询
 */
@property (nonatomic, strong) NSArray <TRZXRecommendExpertTopic *> *expertTopicList;

/**
 推荐投资人
 */
@property (nonatomic, strong) NSArray <TRZXRecommendInvestor *> *investorList;

@end


@interface TRZXRecommendCoursez :NSObject

@property (nonatomic, copy) NSString *collectionStatus;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *avgScore;

@property (nonatomic) int clickRate;

@property (nonatomic, copy) NSString *userPic;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger scoreStatus;

@property (nonatomic, assign) NSInteger commentStatus;

@property (nonatomic, assign) NSInteger totalComments;

@property (nonatomic, copy) NSString *individualResume;

@property (nonatomic, assign) NSInteger videoNum;

@property (nonatomic, copy) NSString *courseAbs;

@property (nonatomic, copy) NSString *user;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *defaultPic;

@end


@interface TRZXRecommendExpertTopic : NSObject

@property (nonatomic,copy)NSString *realName;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *ePosition;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *trade;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *individualResume;
@property (nonatomic,copy)NSString *topicTitle;
@property (nonatomic,copy)NSString *expertPhoto;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *photo;

@end

@interface TRZXRecommendInvestor : NSObject
@property (nonatomic, assign) NSInteger investorType;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, assign) NSInteger ipositionId;
@property (nonatomic, strong) NSString *investmentStages;
@property (nonatomic, strong) NSString *iposition;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *focusTradesName;
@property (nonatomic, strong) NSString *organizationId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *organization;
@end
