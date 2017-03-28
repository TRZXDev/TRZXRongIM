//
//  TRZXPersonalNModel.h
//  TRZXPersonalHome
//
//  Created by 张江威 on 2017/3/22.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Menus,UserWorkExperience,Achievements,UserEducationExperiences,personalData;

@interface TRZXPersonalNModel : NSObject

@property (nonatomic , copy) NSString              * myBusinessPlan;
@property (nonatomic , strong) NSMutableArray<Menus *>              * menus;
@property (nonatomic , strong) NSArray<NSString *>              * sessionUserType;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , copy) NSString              * twoCode;
@property (nonatomic , copy) NSString              * status_dec;
@property (nonatomic , copy) NSString              * inviteUrl;
@property (nonatomic , copy) NSString              * equipment;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * requestType;
@property (nonatomic , strong) personalData              * data;
@property (nonatomic , copy) NSString              * apiType;
@property (nonatomic , copy) NSString              * smsInviteUrl;
@property (nonatomic , copy) NSString              * iosOnline;
@property (nonatomic , strong) NSArray<NSString *>              * picList;
@property (nonatomic , copy) NSString              * login_status;
@property (nonatomic , copy) NSString              * sessionUserTypeStr;
@property (nonatomic , copy) NSString              * status_code;
@property (nonatomic , copy) NSString              * isAlso;

@property (nonatomic , copy) NSString              * exchangeId;
@property (nonatomic , copy) NSString              * currentUser;



@end

@interface personalData :NSObject
@property (nonatomic , assign) NSInteger              sangCount;
@property (nonatomic , assign) NSInteger              followCount;
@property (nonatomic , copy) NSString              * logo;
@property (nonatomic , copy) NSString              * company;
@property (nonatomic , copy) NSString              * cAbstractz;
@property (nonatomic , assign) NSInteger              seeCount;
@property (nonatomic , assign) NSInteger              seeUserCount;
@property (nonatomic , copy) NSString              * mobileBandingStatus;
@property (nonatomic , copy) NSString              * photo;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , assign) NSInteger              meetCount;
@property (nonatomic , copy) NSString              * abstractz;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * position;
@property (nonatomic , strong) NSArray<UserWorkExperience *>              * userWorkExperience;
@property (nonatomic , copy) NSString              * shareUrl;
@property (nonatomic , copy) NSString              * bgImage;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) NSArray<Achievements *>              * achievements;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * positionId;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * cityId;
@property (nonatomic , strong) NSArray<UserEducationExperiences *>              * userEducationExperiences;
@property (nonatomic , assign) NSInteger              fansCount;
@property (nonatomic , assign) NSInteger              followFlag;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , assign) NSInteger              roadCount;
@property (nonatomic , assign) NSInteger              roadSeeCount;
@property (nonatomic , copy) NSString              * userType;
@property (nonatomic , copy) NSString              * wechatBangdingStatus;
@property (nonatomic , copy) NSString              * maxPhoto;
@property (nonatomic , copy) NSString              * passwordStatus;
@property (nonatomic , copy) NSString              * perfect;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , copy) NSString              * orgId;

@property (nonatomic , copy) NSString              * currentUser;
@property (nonatomic , copy) NSString              * userId;

@property (nonatomic , copy) NSString              * isAlso;

@property (nonatomic , copy) NSString              * bpFlag;
@property (nonatomic , copy) NSString              * d4aFlag;
@property (nonatomic , copy) NSString              * bpApply;


@end

@interface Menus :NSObject
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * name;

@end

@interface UserWorkExperience :NSObject
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * position;
@property (nonatomic , copy) NSString              * endDate;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * startDate;
@property (nonatomic , copy) NSString              * company;
@property (nonatomic , copy) NSString              * userName;

@end

@interface Achievements :NSObject
@property (nonatomic , copy) NSString              * relatedLink;
@property (nonatomic , copy) NSString              * meetCount;
@property (nonatomic , copy) NSString              * position;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * individualResume;
@property (nonatomic , copy) NSString              * company;
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , copy) NSString              * openMeetSign;
@property (nonatomic , copy) NSString              * updateDate;
@property (nonatomic , copy) NSString              * expertPhoto;
@property (nonatomic , copy) NSString              * index;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * topicContent;
@property (nonatomic , copy) NSString              * headImg;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * epId;
@property (nonatomic , copy) NSString              * trade;
@property (nonatomic , copy) NSString              * timeOnce;
@property (nonatomic , copy) NSString              * defaultPic;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * picTitle;
@property (nonatomic , copy) NSString              * area;
@property (nonatomic , copy) NSString              * commentCount;
@property (nonatomic , copy) NSString              * ostList;
@property (nonatomic , copy) NSString              * dataModelType;
@property (nonatomic , copy) NSString              * muchOnce;

@property (nonatomic , copy) NSString              * topicTitle;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * userPic;
@property (nonatomic , copy) NSString              * carouselImg;
@property (nonatomic , copy) NSString              * logo;
@property (nonatomic , copy) NSString              * videoImg;


@end

@interface UserEducationExperiences :NSObject
@property (nonatomic , copy) NSString              * school;
@property (nonatomic , copy) NSString              * major;
@property (nonatomic , copy) NSString              * endDate;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * startDate;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * education;


@end





