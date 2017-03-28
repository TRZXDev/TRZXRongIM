//
//  TRZXInvestorDetailTableViewCoverHeaderView.h
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <TRZXNavigationTableViewHeaderView/TRZXTableViewCoverHeaderView.h>

@class TRZXInvestorDetailModel;

@interface TRZXInvestorDetailTableViewCoverHeaderView : TRZXTableViewCoverHeaderView

@property (nonatomic, strong) TRZXInvestorDetailModel *model;

@property (nonatomic, copy) void (^currentSelectidIsInvestor)(BOOL isSelectedInvestor);

@end
