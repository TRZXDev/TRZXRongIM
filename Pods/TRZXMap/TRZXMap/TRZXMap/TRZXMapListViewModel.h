//
//  TRZXMapListViewModel.h
//  TRZXMap
//
//  Created by N年後 on 2017/3/1.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"
#import "TRZXMap.h"

@interface TRZXMapListViewModel : NSObject
@property (readwrite, nonatomic, strong) NSNumber *pageNo, *pageSize, *totalPage;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;



@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
///当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;


@property (readwrite, nonatomic, strong) NSString *citycode; // 城市code
@property (nonatomic, strong) NSString *locality;
@property (nonatomic) CGFloat zoomLevel; // 缩放级别
@property (nonatomic) NSInteger minDistance; // 距离
@property (nonatomic,strong) NSString* objId; //

@property (nonatomic,strong) NSArray* tradeIds; // 领域
@property (nonatomic,strong) NSArray* stageIds; // 阶段



@property (strong, nonatomic) RACSignal *requestSignal_toAll; //地图股东用户
@property (readwrite, nonatomic, strong) NSMutableArray *list; // 地图股东用户列表


-(NSDictionary *)toAllParams;
- (void)configWithObj:(TRZXMapListViewModel *)model;
@end
