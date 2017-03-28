//
//  TRZXMapViewModel.h
//  TRZXMap
//
//  Created by N年後 on 2017/2/28.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"
#import "TRZXMap.h"
#import "TRZXMapAnnotation.h"

@interface TRZXMapViewModel : NSObject
@property (assign, nonatomic) BOOL isLoading;


@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) NSString *locality;
///当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CGFloat zoomLevel; // 缩放级别
@property (readwrite, nonatomic, strong) NSString *citycode; // 城市code
@property (nonatomic,strong) NSArray* tradeIds; // 领域
@property (nonatomic,strong) NSArray* stageIds; // 阶段
@property (nonatomic,strong) NSMutableArray* list; //


@property (strong, nonatomic) RACSignal *requestSignal_list; ///< 网络请求信号量


-(NSDictionary *)toTipsParams;

@end
