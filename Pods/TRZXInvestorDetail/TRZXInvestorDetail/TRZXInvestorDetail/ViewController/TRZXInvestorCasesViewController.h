//
//  TRZXInvestorCasesViewController.h
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestmentCases;

@interface TRZXInvestorCasesViewController : UIViewController
@property (nonatomic, strong) NSArray<InvestmentCases *> * investmentCases;
@end
