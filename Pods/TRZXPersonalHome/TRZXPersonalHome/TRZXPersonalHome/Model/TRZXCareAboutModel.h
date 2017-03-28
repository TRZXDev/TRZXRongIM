//
//  TRZXCareAboutModel.h
//  TRZXPersonalHome
//
//  Created by 张江威 on 2017/3/22.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data;
@interface TRZXCareAboutModel : NSObject

@property (nonatomic , strong) NSMutableArray<NSString *> * sessionUserType;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , assign) NSInteger              totalPage;
@property (nonatomic , copy) NSString              * status_dec;
@property (nonatomic , copy) NSString              * equipment;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * requestType;
@property (nonatomic , strong) NSMutableArray<Data *>              * data;
@property (nonatomic , copy) NSString              * apiType;
@property (nonatomic , copy) NSString              * sessionUserTypeStr;
@property (nonatomic , copy) NSString              * iosOnline;
@property (nonatomic , copy) NSString              * login_status;
@property (nonatomic , assign) NSInteger              pageNo;
@property (nonatomic , copy) NSString              * status_code;
@property (nonatomic , assign) NSInteger              pageSize;

@end


@interface Data :NSObject
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * position;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * collectionType;
@property (nonatomic , copy) NSString              * individualResume;
@property (nonatomic , copy) NSString              * company;
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , copy) NSString              * photo;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * nickName;

@end
