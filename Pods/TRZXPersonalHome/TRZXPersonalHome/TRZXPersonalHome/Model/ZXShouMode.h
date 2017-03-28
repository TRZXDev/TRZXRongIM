//
//  ZXShouMode.h
//  tourongzhuanjia
//
//  Created by sweet luo on 15/10/23.
//  Copyright © 2015年 KristyFuWa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXShouMode : NSObject
@property (copy, nonatomic)NSString *mid;
@property (copy, nonatomic)NSString *otoId;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *href;
@property (copy, nonatomic)NSString *userPic;
@property (copy, nonatomic)NSString *videoImg;
@property (copy, nonatomic)NSString *logo;
@property (copy, nonatomic)NSString *otherName;
/**
 *  跳转类型
 */
@property (copy, nonatomic)NSString *type;
/**
 *  目标类型 id
 */
@property (copy, nonatomic)NSString *objectId;

@property (copy, nonatomic)NSString *photo;
@property (copy, nonatomic)NSString *teachPosition;
@property (copy, nonatomic)NSString *teachName;
@property (copy, nonatomic)NSString *teachCompany;
@property (copy, nonatomic)NSString *teachIntroduction;
@property (copy, nonatomic)NSString *companyIntroduction;
@property (copy, nonatomic)NSString *schoolIntroduction;
@property (copy, nonatomic)NSString *remarks;
@property (copy, nonatomic)NSString *lookCount;
@property (assign, nonatomic)int praiseCount;
@property (assign, nonatomic)int praiseStatus;//点赞状态
@property (assign, nonatomic)int collectStatus;//收藏状态

@property (copy, nonatomic)NSString *teachId;
@property (copy, nonatomic)NSString *episodeSum;
@property (copy, nonatomic)NSString *checkedCount;
@property (copy, nonatomic)NSString *viewImg;
@property (copy, nonatomic)NSString *viewUrl;
@property (copy, nonatomic)NSString *parentId;

@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *clickRate;
@property (copy, nonatomic)NSString *projectId;
@property (copy, nonatomic)NSString *projectLevel;
@property (copy, nonatomic)NSString *areaId;
@property (copy, nonatomic)NSString *tradeInfo;
@property (copy, nonatomic)NSString *companyName;
@property (copy, nonatomic)NSString *briefIntroduction;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *updateDate;


@property (nonatomic, copy) NSString *epId;

@property (nonatomic, copy) NSString *picTitle;

@property (nonatomic, copy) NSString *module;

@property (nonatomic, copy) NSString *topicTitle;


@property (nonatomic, copy) NSString *individualResume;

@property (nonatomic, copy) NSString *topicContent;

@property (nonatomic, copy) NSString *meetCount;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *expertPhoto;


@property (nonatomic, copy) NSString *createDate;



@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *ePosition;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *courseAbs;

@property (nonatomic, copy) NSString *user;


@property (nonatomic, copy) NSString *trade;



@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *liveByTitle;
@property (nonatomic, copy) NSString *liveByCompany;
@property (nonatomic, copy) NSString *liveByHeadImg;
@property (nonatomic, copy) NSString *liveTitle;


+(instancetype)ZXShouModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;


@end
