//
//  TRZPersonalModell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/14.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRZPersonalModell : NSObject

@property (copy, nonatomic) NSString *isAlso;
@property (copy, nonatomic) NSString *myBusinessPlan;
@property (copy, nonatomic) NSString *userType;
@property (copy, nonatomic) NSString *d4aFlag;
@property (copy, nonatomic) NSString *bpFlag;
@property (copy, nonatomic) NSString *bpApply;
@property (copy, nonatomic) NSString *achievements;
@property (copy, nonatomic) NSString *invCompany;
@property (copy, nonatomic) NSString *orgId;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *userCompany;
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *ecAbstractz;

@property (copy, nonatomic) NSString *currentUser;//登录用户的身份

@property (copy, nonatomic) NSString *ccompany;
@property (copy, nonatomic) NSString *ccAbstractz;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *cityId;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *msgView;

@property (copy, nonatomic) NSString *mid;
@property (copy, nonatomic) NSString *epId;
@property (copy, nonatomic) NSString *projectLevel;
@property (copy, nonatomic) NSString *name;
//问答的
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *userPhoto;
@property (copy, nonatomic) NSString *userNmae;
@property (copy, nonatomic) NSString *answerRate;
@property (copy, nonatomic) NSString *totalRate;
@property (copy, nonatomic) NSString *totalGood;
@property (copy, nonatomic) NSString *totalRateAudio;
@property (copy, nonatomic) NSString *totalRateVideo;
@property (copy, nonatomic) NSString *creatDate;

@property (copy, nonatomic) NSString *tradeInfo;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *realName;
@property (copy, nonatomic) NSString *meetCount;
@property (copy, nonatomic) NSString *seeCount;
@property (copy, nonatomic) NSString *followCount;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *wechatBangdingStatus;
@property (copy, nonatomic) NSString *passwordStatus;

@property (copy, nonatomic) NSString *vip;
@property (copy, nonatomic) NSString *fansCount;
@property (copy, nonatomic) NSString *abstractz;

@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *myResources;
@property (copy, nonatomic) NSString *needResources;
@property (copy, nonatomic) NSString *uri;


@property (copy, nonatomic) NSString *projectImg;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *carouselImg;
@property (copy, nonatomic) NSString *userPic;
@property (copy, nonatomic) NSString *expertPhoto;
@property (copy, nonatomic) NSString *photo;
@property (copy, nonatomic) NSString *bgImage;
@property (copy, nonatomic) NSString *headImg;
@property (copy, nonatomic) NSString *videoImg;
@property (copy, nonatomic) NSString *firstImg;


@property (copy, nonatomic) NSString *topicTitle;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *picTitle;
@property (copy, nonatomic) NSString *user;
@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *businessPlan;
@property (copy, nonatomic) NSString *dataModelType;
@property (copy, nonatomic) NSString *updateDate;



@property (copy, nonatomic) NSString *userEducationExperiences;
@property (copy, nonatomic) NSString *noticeList;
@property (copy, nonatomic) NSString *userWorkExperience;
@property (copy, nonatomic) NSString *followFlag;
@property (copy, nonatomic) NSString *startDate;
@property (copy, nonatomic) NSString *endDate;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *major;
@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *education;


@property (copy, nonatomic) NSString *createById;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *isRemind;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *auditOpinion;
@property (nonatomic, copy) NSString *exchangeName;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorAbs;
@property (nonatomic, copy) NSString *questionName;
@property (nonatomic, copy) NSString *briefIntroduction;
@property (nonatomic, copy) NSString *questinCotent;
@property (nonatomic, copy) NSString *questionType;
@property (nonatomic, copy) NSString *msgTitle;

@property (nonatomic, copy) NSString *msgDigest;
@property (nonatomic, copy)NSString *msgzPic;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *authName;


/**
 *  用于放大的图片
 */
@property (nonatomic, copy) NSString *maxPhoto;

/**
 *  润桑次数
 */
@property (nonatomic, copy) NSString *sangCount;

/**
 *  看过别人的视频次数
 */
@property (nonatomic, copy) NSString *seeUserCount;

/**
 *  观看路演次数
 */
@property (nonatomic, copy) NSString *roadSeeCount;

/**
 *  被观看路演次数
 */
@property (nonatomic, copy) NSString *roadCount;

@end
