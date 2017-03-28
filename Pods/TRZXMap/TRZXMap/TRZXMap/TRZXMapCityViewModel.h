//
//  TRZXMapCityViewModel.h
//  TRZXMap
//
//  Created by N年後 on 2017/3/7.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"
@interface TRZXMapCityViewModel : NSObject


@property (strong, nonatomic) RACSignal *requestSignal_toAll; //地图城市数据
@property (readwrite, nonatomic, strong) NSMutableArray *list; // 地图股东用户列表


@end
