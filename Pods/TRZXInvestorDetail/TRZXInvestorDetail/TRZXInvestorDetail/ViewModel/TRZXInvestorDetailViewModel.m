//
//  TRZXInvestorDetailViewModel.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/10.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailViewModel.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailModel.h"

@implementation TRZXInvestorDetailViewModel

#pragma mark - <Setter/Getter>
- (RACSignal *)requestSignal_InvestorDetail
{
    if (!_requestSignal_InvestorDetail) {
        _requestSignal_InvestorDetail = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[@"requestType"] = @"InvestorNew_Api";
            params[@"apiType"] = @"orgInvestorInfo";
            params[@"id"] = self.investorId;
            
            
            // 请求数据
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
                
                if (!response) {
                    
                    [subscriber sendError:error];
                    
                }else {
                    
                    self.investorDetailModel = [TRZXInvestorDetailModel mj_objectWithKeyValues:response];
                    
                    [subscriber sendNext:self];
                    [subscriber sendCompleted];
                    
                }
                
            }];
            
            
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{
                [TRZXNetwork cancelRequestWithURL:@""];
            }];
        }];
    }
    return _requestSignal_InvestorDetail;
}

- (RACSignal *)requestSignal_Organizatioin
{
    if (!_requestSignal_Organizatioin) {
        _requestSignal_Organizatioin = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[@"requestType"] = @"InvestorNew_Api";
            params[@"apiType"] = @"orgInfo";
            params[@"orgId"] = self.investorDetailModel.data.organizationId;
            
            // 请求数据
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
                
                if (!response) {
                    
                    [subscriber sendError:error];
                    
                }else {
                    
                    self.investorDetailModel = [TRZXInvestorDetailModel mj_objectWithKeyValues:response];
                    
                    [subscriber sendNext:self];
                    [subscriber sendCompleted];
                    
                }
                
            }];
            
            
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{
                [TRZXNetwork cancelRequestWithURL:@""];
            }];
            
        }];
    }
    return _requestSignal_Organizatioin;
}

@end
