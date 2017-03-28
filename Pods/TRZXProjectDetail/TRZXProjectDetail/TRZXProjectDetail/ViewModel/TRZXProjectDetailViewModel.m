//
//  TRZXProjectDetailViewModel.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailViewModel.h"
#import "TRZXProjectDetailMacro.h"

@interface TRZXProjectDetailViewModel()

@property (nonatomic, strong) RACSignal *requestSignal_project;

@property (nonatomic, strong) RACSignal *requestSignal_recommend;

@end

@implementation TRZXProjectDetailViewModel


#pragma mark - <Setter/Getter>
- (RACSignal *)requestSignal_project
{
    if (!_requestSignal_project) {
        _requestSignal_project = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[@"requestType"] = @"NewRoadShow_Api";
            params[@"apiType"] = @"investorProjectInfo";
            params[@"projectzId"] = self.projectId;
            
            // 请求数据
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
                
                if (!response) {
                    
                    [subscriber sendError:error];
                    
                }else {
                    
                    self.projectDetailModel = [TRZXProjectDetailModel mj_objectWithKeyValues:response];
                    
                    [subscriber sendCompleted];
                    
                }
                
            }];
            
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{
                
                [TRZXNetwork cancelRequestWithURL:@""];
            }];
            
        }];
    }
    return _requestSignal_project;
}

- (RACSignal *)requestSignal_recommend
{
    if (!_requestSignal_recommend) {
        _requestSignal_recommend = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[@"requestType"] = @"Recommend_Api";
            params[@"apiType"] = @"findData";
            params[@"dataType"] = @"";
            
            // 请求数据
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
                
                if (!response) {
                    
                    [subscriber sendError:error];
                    
                }else {
                    
                    self.recommendModel = [TRZXRecommendModel mj_objectWithKeyValues:response];
                    
                    [subscriber sendNext:self];
                    
                }
                
            }];
            
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{
                
                [TRZXNetwork cancelRequestWithURL:@""];
            }];
            
        }];
    }
    return _requestSignal_recommend;
}

- (RACSignal *)requestSignal_projectDetail
{
    if (!_requestSignal_projectDetail) {
        _requestSignal_projectDetail = [self.requestSignal_project concat:self.requestSignal_recommend];
    }
    return _requestSignal_projectDetail;
}

- (TRZXProjectDetailModel *)projectDetailModel
{
    if (!_projectDetailModel) {
        _projectDetailModel = [[TRZXProjectDetailModel alloc] init];
    }
    return _projectDetailModel;
}

- (TRZXRecommendModel *)recommendModel
{
    if (!_recommendModel) {
        _recommendModel = [[TRZXRecommendModel alloc] init];
    }
    return _recommendModel;
}

@end
