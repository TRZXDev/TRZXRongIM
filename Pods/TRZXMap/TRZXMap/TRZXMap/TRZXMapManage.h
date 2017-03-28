//
//  TRZXMapLocationManage.h
//  TRZXMap
//
//  Created by N年後 on 2017/3/7.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRZXMap.h"

typedef void(^locationManageBlock)(AMapLocationReGeocode *regeocode);

@interface TRZXMapManage : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, copy) locationManageBlock block;
//位置信息
@property (nonatomic,assign)  CLLocationCoordinate2D   curLocation;
- (void)startLocation:(locationManageBlock)block;

@end
