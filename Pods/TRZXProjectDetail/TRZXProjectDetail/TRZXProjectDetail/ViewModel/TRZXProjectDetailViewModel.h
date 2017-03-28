//
//  TRZXProjectDetailViewModel.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRZXProjectDetailMacro.h"
#import "TRZXProjectDetailModel.h"
#import "TRZXProjectDetailDataModel.h"
#import "TRZXRecommendModel.h"

@class TRZXProjectDetailModel;

@interface TRZXProjectDetailViewModel : NSObject

@property (nonatomic, strong) TRZXProjectDetailModel *projectDetailModel;

@property (nonatomic, strong) TRZXRecommendModel *recommendModel;

@property (nonatomic, strong) NSString *projectId;

@property (nonatomic, strong) RACSignal *requestSignal_projectDetail;

@end
