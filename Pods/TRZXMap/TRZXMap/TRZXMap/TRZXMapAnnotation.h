//
//  MapUser.h
//  TRZX
//
//  Created by N年後 on 2017/1/4.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRZXMap.h"
@interface TRZXMapAnnotation : MAPointAnnotation
@property (nonatomic) NSInteger index;
@property (nonatomic, copy) NSString *name; //姓名
@property (nonatomic, copy) NSString *position;  // 职位
@property (nonatomic, copy) NSString *sex; // 性别
@property (nonatomic, copy) NSString *company; // 机构
@property (nonatomic, copy) NSString *distanceStr; // 距离
@property (nonatomic) NSInteger distance; // 距离
@property (nonatomic, copy) NSString *photo; // 图片
@property (nonatomic, copy) NSString *userId; // 股东用户id
@property (nonatomic, copy) NSString *objId;
@property (nonatomic, copy) NSString *isOnline; // 是否在线


// 地图上显示数据
@property (nonatomic, copy) NSString *longitude; // 大头针纬度坐标
@property (nonatomic, copy) NSString *latitude; // 大头针经度坐标
@property (nonatomic, copy) NSString *adcode; // 城市Code
@property (nonatomic, copy) NSString *mid; //
@property (nonatomic, copy) NSString *level; // 级别
@property (nonatomic, copy) NSString *count; // 当前级别地图显示用户数

@property (nonatomic, copy) NSString *locaLongitude; // 当前用户经度坐标
@property (nonatomic, copy) NSString *localLatitude; // 当前用户纬度坐标

@property (nonatomic, assign) CLLocationCoordinate2D locaCoordinate;


@end
