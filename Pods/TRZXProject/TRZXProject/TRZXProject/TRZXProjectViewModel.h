//
//  TRZXProjectViewModel.h
//  TRZXProject
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"
#import "TRZXProject.h"
@interface TRZXProjectViewModel : NSObject
@property (readwrite, nonatomic, strong) NSNumber *pageNo, *pageSize, *totalPage;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

@property (strong, nonatomic) NSString *trade; //领域
@property (strong, nonatomic) NSString *stage; //阶段


@property (strong, nonatomic) RACSignal *requestSignal_hotProject; ///< 网络请求信号量
@property (strong, nonatomic) RACSignal *requestSignal_allProject; ///< 全部项目


@property (readwrite, nonatomic, strong) NSMutableArray *list; // 市场项目列表



-(NSDictionary *)toHotParams;
-(NSDictionary *)toAllParams;
- (void)configWithObj:(TRZXProjectViewModel *)model;
@end
