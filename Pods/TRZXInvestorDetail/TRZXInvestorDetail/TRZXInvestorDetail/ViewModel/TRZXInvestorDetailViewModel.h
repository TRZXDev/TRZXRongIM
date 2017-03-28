//
//  TRZXInvestorDetailViewModel.h
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/10.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class TRZXInvestorDetailModel;

@interface TRZXInvestorDetailViewModel : NSObject

@property (nonatomic, strong) TRZXInvestorDetailModel *investorDetailModel;

@property (nonatomic, strong) NSString *investorId;

@property (nonatomic, strong) RACSignal *requestSignal_InvestorDetail;

@property (nonatomic, strong) RACSignal *requestSignal_Organizatioin;

@end
