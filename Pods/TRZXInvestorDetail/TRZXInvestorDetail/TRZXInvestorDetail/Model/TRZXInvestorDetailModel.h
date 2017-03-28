//
//  TRZXInvestorDetailModel.h
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/10.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InvestorData, InvestmentStages, OrgUserAuthList, FocusTrades, InvestmentCases;


@interface TRZXInvestorDetailModel : NSObject

@property (nonatomic , copy) NSString              * apiType;
@property (nonatomic , strong) NSArray<NSString *>              * sessionUserType;
@property (nonatomic , copy) NSString              * focus;
@property (nonatomic , copy) NSString              * bpFlag;
@property (nonatomic , copy) NSString              * sessionUserTypeStr;
@property (nonatomic , assign) NSInteger              bpApply;
@property (nonatomic , copy) NSString              * isAlso;
@property (nonatomic , copy) NSString              * topPic;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * d4aFlag;
@property (nonatomic , copy) NSString              * iosOnline;
@property (nonatomic , copy) NSString              * equipment;
@property (nonatomic , copy) NSString              * requestType;
@property (nonatomic , copy) NSString              * status_dec;
@property (nonatomic , copy) NSString              * login_status;
@property (nonatomic , copy) NSString              * bpUrl;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , strong) InvestorData              * data;
@property (nonatomic , copy) NSString              * status_code;
@property (nonatomic , copy) NSString              * userId;

@end

@interface UserTitleViews :NSObject
@property (nonatomic , copy) NSString              * abstractz;
@property (nonatomic , copy) NSString              * flag;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * type;

@end

@interface PositionViews :NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * abstractz;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * flag;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * type;

@end

@interface ForTrades :NSObject

@end

@interface FocusTradesSelf :NSObject
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * updateDate;
@property (nonatomic , copy) NSString              * remarks;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , copy) NSString              * parentIds;
@property (nonatomic , copy) NSString              * trade;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * abstractz;

@end

@interface InvestorData :NSObject
@property (nonatomic , copy) NSString              * ipositionId;
@property (nonatomic , copy) NSString              * cpositionId;
@property (nonatomic , copy) NSString              * ccity;
@property (nonatomic , copy) NSString              * tradeId;
@property (nonatomic , copy) NSString              * investorType;
@property (nonatomic , copy) NSString              * authExpStatus;
@property (nonatomic , copy) NSString              * ccompany;
@property (nonatomic , copy) NSString              * head_img;
@property (nonatomic , strong) NSArray<FocusTrades *>              * focusTrades;
@property (nonatomic , copy) NSString              * authFcFlag;
@property (nonatomic , copy) NSString              * ecity;
@property (nonatomic , copy) NSString              * logo;
@property (nonatomic , strong) NSArray<UserTitleViews *>              * userTitleViews;
@property (nonatomic , copy) NSString              * userTitle;
@property (nonatomic , copy) NSString              * authFcStatus;
@property (nonatomic , copy) NSString              * abstractz;
@property (nonatomic , copy) NSString              * operatingCity;
@property (nonatomic , copy) NSString              * position;
@property (nonatomic , copy) NSString              * authExpFlag;
@property (nonatomic , copy) NSString              * organization;
@property (nonatomic , copy) NSString              * authExpOpnion;
@property (nonatomic , copy) NSString              * iWebSite;
@property (nonatomic , copy) NSString              * privateEquity;
@property (nonatomic , copy) NSString              * exchangeLicence;
@property (nonatomic , strong) NSArray<PositionViews *>              * positionViews;
@property (nonatomic , copy) NSString              * myResources;
@property (nonatomic , copy) NSString              * ecityId;
@property (nonatomic , copy) NSString              * authInStatus;
@property (nonatomic , copy) NSString              * meetCount;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * businessLicence;
@property (nonatomic , copy) NSString              * ccityId;
@property (nonatomic , copy) NSString              * authPrFlag;
@property (nonatomic , copy) NSString              * eabstractz;
@property (nonatomic , copy) NSString              * userLink;
@property (nonatomic , copy) NSString              * authFcOpnion;
@property (nonatomic , copy) NSString              * stockholderLicence;
@property (nonatomic , copy) NSString              * authPrStatus;
@property (nonatomic , copy) NSString              * iposition;
@property (nonatomic , copy) NSString              * d4aFlag;
@property (nonatomic , copy) NSString              * cposition;
@property (nonatomic , strong) NSArray<InvestmentCases *>              * investmentCases;
@property (nonatomic , copy) NSString              * authInOpnion;
@property (nonatomic , copy) NSString              * operatingCityId;
@property (nonatomic , copy) NSString              * focus;
@property (nonatomic , strong) NSArray<OrgUserAuthList *>              * orgUserAuthList;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , strong) NSArray<InvestmentStages *>              * investmentStages;
@property (nonatomic , copy) NSString              * companyLicence;
@property (nonatomic , copy) NSString              * practiceCertificateLicence;
@property (nonatomic , copy) NSString              * foundSize;
@property (nonatomic , copy) NSString              * positionId;
@property (nonatomic , copy) NSString              * idCardBack;
@property (nonatomic , copy) NSString              * trade;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * cityId;
@property (nonatomic , copy) NSString              * planInvest;
@property (nonatomic , copy) NSString              * openMeetSign;
@property (nonatomic , copy) NSString              * authPrOpnion;
@property (nonatomic , copy) NSString              * sWebSite;
@property (nonatomic , strong) NSArray<ForTrades *>              * forTrades;
@property (nonatomic , copy) NSString              * idImgInHand;
@property (nonatomic , copy) NSString              * icompany;
@property (nonatomic , copy) NSString              * organizationId;
@property (nonatomic , copy) NSString              * idNum;
@property (nonatomic , copy) NSString              * eposition;
@property (nonatomic , copy) NSString              * identificationLicence;
@property (nonatomic , copy) NSString              * userTitleId;
@property (nonatomic , copy) NSString              * iPublicNum;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * otoSchoolTopics;
@property (nonatomic , copy) NSString              * authInFlag;
@property (nonatomic , copy) NSString              * userPic;
@property (nonatomic , copy) NSString              * icAbstractz;
@property (nonatomic , copy) NSString              * ecAbstractz;
@property (nonatomic , copy) NSString              * ccAbstractz;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * sPublicNum;
@property (nonatomic , copy) NSString              * idCardFace;
@property (nonatomic , copy) NSString              * ecompany;
@property (nonatomic , strong) NSArray<FocusTradesSelf *>              * focusTradesSelf;
@property (nonatomic , copy) NSString              * needResources;

#pragma mark - <投资机构>
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * photo;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * registerMoney;

@end

@interface InvestmentStages :NSObject
@property (nonatomic , copy) NSString              * selfFlag;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * areaId;
@property (nonatomic , copy) NSString              * checked;
@property (nonatomic , copy) NSString              * abstractz;
@property (nonatomic , copy) NSString              * minInvestmentAmount;
@property (nonatomic , copy) NSString              * maxInvestmentAmount;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * organizationId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * organization;

@end

@interface OrgUserAuthList :NSObject
@property (nonatomic , copy) NSString              * abstractz;
@property (nonatomic , copy) NSString              * photo;
@property (nonatomic , copy) NSString              * userTitle;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * position;

@end

@interface FocusTrades :NSObject
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * updateDate;
@property (nonatomic , copy) NSString              * remarks;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , copy) NSString              * parentIds;
@property (nonatomic , copy) NSString              * trade;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * abstractz;

@end

@interface InvestmentCases :NSObject
@property (nonatomic , copy) NSString              * selfFlag;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * areaId;
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * assessment;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * areaName;
@property (nonatomic , copy) NSString              * orgId;
@property (nonatomic , copy) NSString              * orgName;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * investmentTime;

@end
