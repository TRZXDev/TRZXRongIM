//
//  TRZXScreeningViewModel.h
//  TRZXProjectScreening
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"
@interface TRZXScreeningViewModel : NSObject
@property (strong, nonatomic) RACSignal *requestSignal_screening; ///< 网络请求信号量

@property (readwrite, nonatomic, strong) NSArray *trades; //领域列表
@property (readwrite, nonatomic, strong) NSArray *stages; // 阶段列表



@end
