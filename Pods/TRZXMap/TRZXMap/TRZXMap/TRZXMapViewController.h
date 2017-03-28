//
//  TRZXMapViewController.h
//  TRZXMap
//
//  Created by N年後 on 2017/2/28.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXMapViewModel.h"

@interface TRZXMapViewController : UIViewController

@property (nonatomic, copy) void(^mapInitCompleteBlock)(TRZXMapViewModel *mapViewModel);

@property (nonatomic, strong) TRZXMapViewModel *mapViewModel;


//领域id数组  //阶段id数组
-(void)setTradeIds:(NSArray*)tradeIds stageIds:(NSArray *)stageIds;
-(void)setCity:(NSDictionary *)dic;

@end
