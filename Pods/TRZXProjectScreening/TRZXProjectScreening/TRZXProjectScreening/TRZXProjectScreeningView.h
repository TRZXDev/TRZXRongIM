//
//  TRZXProjectScreeningView.h
//  TRZX
//
//  Created by 移动微 on 16/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TRZXProjectScreeningViewTypeInvestorDomain,       //按投资阶段筛选
    TRZXProjectScreeningViewTypeInvestorStage,        //按投资领域筛选
    TRZXProjectScreeningViewTypeProjectDomain,        //按融资阶段筛选
    TRZXProjectScreeningViewTypeProjectStage,         //按所属领域筛选
} TRZXProjectScreeningViewType;

@class FindTradeModel;
/**
 筛选视图
 */
@interface TRZXProjectScreeningView : UIView


@property (readwrite, nonatomic, strong) NSArray *trades; //领域列表
@property (readwrite, nonatomic, strong) NSArray *stages; // 阶段列表

@property(nonatomic, assign)TRZXProjectScreeningViewType type;


/**
 初始化构造方法
 */
+(instancetype)initWithType:(TRZXProjectScreeningViewType)type Frame:(CGRect)frame;

/**
 重置
 */
-(void)reset;

/**
 获取Mid

 @return mid数组
 */
-(NSString *)getMid;

@end
