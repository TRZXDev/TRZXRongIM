//
//  TRZXProjectViewModel.m
//  TRZXProject
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectViewModel.h"
#import "MJExtension.h"

@implementation TRZXProjectViewModel

+(NSDictionary *)objectClassInArray{
    return @{@"list":[TRZXProject class]};
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        _canLoadMore = NO;
        _isLoading = _willLoadMore = NO;
        _pageNo = [NSNumber numberWithInteger:1];
        _pageSize = [NSNumber numberWithInteger:15];

        _trade = @"";
        _stage = @"";
    }
    return self;
}


-(NSDictionary *)toHotParams{

    NSDictionary *params = @{@"requestType" :@"NewRoadShow_Api",
                             @"apiType" :@"projectRoadShow",
                             @"trade" :_trade, //领域
                             @"stage" :_stage, // 阶段
                             @"pLevel" :@"recommend", // 推荐项目
                             @"pageNo" : _willLoadMore? [NSNumber numberWithInteger:_pageNo.integerValue +1]: [NSNumber numberWithInteger:1],
                             @"pageSize" : _pageSize};
    return params;
}


// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_hotProject {

    if (!_requestSignal_hotProject) {

        _requestSignal_hotProject = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {


            [TRZXNetwork requestWithUrl:nil params:self.toHotParams method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {

                if (response) {

                    TRZXProjectViewModel *projectModel = [TRZXProjectViewModel mj_objectWithKeyValues:response];
                    [self configWithObj:projectModel];

                    [subscriber sendNext:self];
                    [subscriber sendCompleted];

                }else{
                    [subscriber sendError:error];
                }
            }];

            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{

                [TRZXNetwork cancelRequestWithURL:@""];
            }];
        }];
    }
    return _requestSignal_hotProject;
}


- (void)configWithObj:(TRZXProjectViewModel *)model{

    self.pageNo = model.pageNo;
    self.pageSize = model.pageSize;
    self.totalPage = model.totalPage;

    if (_willLoadMore) {
        [self.list addObjectsFromArray:model.list];
    }else{
        self.list = [NSMutableArray arrayWithArray:model.list];
    }
    _canLoadMore = _pageNo.intValue < _totalPage.intValue&&_totalPage.intValue>1;
    
}





-(NSDictionary *)toAllParams{

    NSDictionary *params = @{@"requestType" :@"NewRoadShow_Api",
                             @"apiType" :@"projectRoadShow",
                             @"trade" :_trade, //领域
                             @"stage" :_stage, // 阶段
                             @"pLevel" :@"projectcarousel", // 全部项目
                             @"pageNo" : _willLoadMore? [NSNumber numberWithInteger:_pageNo.integerValue +1]: [NSNumber numberWithInteger:1],
                             @"pageSize" : _pageSize};
    return params;
}

// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_allProject {

    if (!_requestSignal_allProject) {

        _requestSignal_allProject = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {


            [TRZXNetwork requestWithUrl:nil params:self.toAllParams method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {

                if (response) {
                    TRZXProjectViewModel *projectModel = [TRZXProjectViewModel mj_objectWithKeyValues:response];
                    [self configWithObj:projectModel];
                    [subscriber sendNext:self];
                    [subscriber sendCompleted];

                }else{
                    [subscriber sendError:error];
                }
            }];

            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{

                [TRZXNetwork cancelRequestWithURL:@""];
            }];
        }];
    }
    return _requestSignal_allProject;
}




@end
