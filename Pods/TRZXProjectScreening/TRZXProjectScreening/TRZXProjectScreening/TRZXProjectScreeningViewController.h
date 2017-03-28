//
//  TRZXProjectScreeningViewController.h
//  TRZX
//
//  Created by 移动微 on 16/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 筛选控制器 
 产品需求:当前页面调用的时候请使其变成属性Property -->目的:之前点击过的时候数据还存在
 */
@interface TRZXProjectScreeningViewController : UIViewController

@property (nonatomic, copy) NSString *screeningType; // 筛选类型 0. 项目  1.投资人
@property (nonatomic, copy) NSString *projectTitle;
@property (nonatomic, copy) void(^confirmComplete)(NSString *trade,NSString *stage); // trade 领域  stage 阶段


@end
