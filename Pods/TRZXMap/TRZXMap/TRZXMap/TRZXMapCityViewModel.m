//
//  TRZXMapCityViewModel.m
//  TRZXMap
//
//  Created by N年後 on 2017/3/7.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapCityViewModel.h"

@implementation TRZXMapCityViewModel






    // 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_toAll {

    if (!_requestSignal_toAll) {

        _requestSignal_toAll = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            [TRZXNetwork requestWithUrl:@"/api/map/city/findAllList" params:nil method:GET  callbackBlock:^(id response, NSError *error) {

                if (response) {
                    self.list = response[@"list"];
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
    return _requestSignal_toAll;
}
    

@end
