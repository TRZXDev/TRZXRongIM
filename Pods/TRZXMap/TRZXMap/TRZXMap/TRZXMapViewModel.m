//
//  TRZXMapViewModel.m
//  TRZXMap
//
//  Created by N年後 on 2017/2/28.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapViewModel.h"
#import "MJExtension.h"
@implementation TRZXMapViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.zoomLevel = 16;
    }
    return self;
}


+(NSDictionary *)objectClassInArray{
    return @{@"list":[TRZXMapAnnotation class]};
}

-(NSDictionary *)toTipsParams{


    NSDictionary * userCoordinate = @{@"latitude":[NSString stringWithFormat:@"%f",self.currentCoordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",self.currentCoordinate.longitude]};  //当前用户所在位置
    NSDictionary * coordinate = @{@"latitude":[NSString stringWithFormat:@"%f",self.centerCoordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",self.centerCoordinate.longitude]};  //屏幕中心位置
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:userCoordinate, @"userCoordinate", coordinate, @"coordinate", nil];


    [params setObject: [NSString stringWithFormat:@"%0.f",self.zoomLevel] forKey:@"level"];

    if (self.tradeIds.count>0) {
        [params setObject:self.tradeIds forKey:@"tradeId"];
    }
    if (self.stageIds.count>0) {
        [params setObject:self.stageIds forKey:@"stageId"];
    }

    return params;
}


// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_list {

    if (!_requestSignal_list) {

        _requestSignal_list = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            self.isLoading = YES;
            [TRZXNetwork requestWithUrl:@"/api/map/places/findNearByShare" params:self.toTipsParams method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
                self.isLoading = NO;

                if (response) {
                    self.list = [TRZXMapAnnotation mj_objectArrayWithKeyValuesArray:response[@"list"]];
                    for (int i=0;i<self.list.count;i++) {
                        TRZXMapAnnotation *model = self.list[i];
                        model.index=i;
                    }

                    [subscriber sendNext:self.list];
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
    return _requestSignal_list;
}


@end
