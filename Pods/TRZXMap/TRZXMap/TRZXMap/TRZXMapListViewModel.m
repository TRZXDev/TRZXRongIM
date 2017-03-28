//
//  TRZXMapListViewModel.m
//  TRZXMap
//
//  Created by N年後 on 2017/3/1.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapListViewModel.h"
#import "MJExtension.h"
#import "TRZXMapAnnotation.h"
@implementation TRZXMapListViewModel


+(NSDictionary *)objectClassInArray{
    return @{@"list":[TRZXMapAnnotation class]};
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        _canLoadMore = NO;
        _isLoading = _willLoadMore = NO;
        _minDistance = 0;
        _objId = @"";
    }
    return self;
}



-(NSDictionary *)toAllParams{


    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentCoordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentCoordinate.longitude];

    NSDictionary * userCoordinate = @{@"latitude":latitude,@"longitude":longitude};  //当前用户所在位置
    NSDictionary * coordinate = @{@"latitude":[NSString stringWithFormat:@"%f",self.centerCoordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",self.centerCoordinate.longitude]};  //屏幕中心位置

    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:userCoordinate, @"userCoordinate", coordinate, @"coordinate", nil];

    if (_citycode.length>0) {
        [params setObject:_citycode forKey:@"citycode"];
    }
    [params setObject:_willLoadMore?[NSString stringWithFormat:@"%zd",_minDistance]:@"0" forKey:@"minDistance"];
    [params setObject:_willLoadMore?_objId:@"" forKey:@"objId"];


    if (self.tradeIds.count>0) {
        [params setObject:self.tradeIds forKey:@"tradeId"];
    }
    if (self.stageIds.count>0) {
        [params setObject:self.stageIds forKey:@"stageId"];
    }

    return params;
}


// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_toAll {

    if (!_requestSignal_toAll) {

        _requestSignal_toAll = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {


            [TRZXNetwork requestWithUrl:@"/api/map/places/findListByShare" params:self.toAllParams method:POST  callbackBlock:^(id response, NSError *error) {

                if (response) {
                    TRZXMapListViewModel *projectModel = [TRZXMapListViewModel mj_objectWithKeyValues:response];
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
    return _requestSignal_toAll;
}


- (void)configWithObj:(TRZXMapListViewModel *)model{



    if (_willLoadMore) {
        [self.list addObjectsFromArray:model.list];
    }else{
        self.list = [NSMutableArray arrayWithArray:model.list];
    }

    if (self.list.count>0) {
        TRZXMapAnnotation *model = self.list[self.list.count-1];
        _minDistance = model.distance;
        _objId = model.objId;

    }

    _canLoadMore = model.list.count>0;


}




@end
