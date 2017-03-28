//
//  TRZXScreeningViewModel.m
//  TRZXProjectScreening
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXScreeningViewModel.h"

@implementation TRZXScreeningViewModel


-(NSDictionary *)toAllParams{

    NSDictionary *params = @{@"requestType" :@"TradesAndStages_Api"};
    return params;
}

// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_screening {

    if (!_requestSignal_screening) {

        _requestSignal_screening = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {


            [TRZXNetwork requestWithUrl:nil params:self.toAllParams method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {

                if (response) {
                    self.trades = [NSArray arrayWithArray:response[@"trades"]] ;
                    self.stages = [NSArray arrayWithArray:response[@"stages"]] ;
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
    return _requestSignal_screening;
}

@end
