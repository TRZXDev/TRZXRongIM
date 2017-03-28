//
//  TRZXProject.h
//  TRZXProject
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRZXProject : NSObject
@property (nonatomic, copy) NSString *mid;// 项目id
@property (nonatomic, copy) NSString *logo;// 项目logo
@property (nonatomic, copy) NSString *name;// 项目名称
@property (nonatomic, copy) NSString *areaName; // 融资阶段
@property (nonatomic, copy) NSString *tradeInfo; // 所属行业
@property (nonatomic, copy) NSString *companyName; // 公司名称
@property (nonatomic, copy) NSString *projectLevel; //
@property (nonatomic, copy) NSString *briefIntroduction; // 项目简介
@end
