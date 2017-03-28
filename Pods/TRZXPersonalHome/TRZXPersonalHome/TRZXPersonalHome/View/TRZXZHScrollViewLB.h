//
//  ZHScrollViewLB.h
//  ScrollView——test
//
//  Created by 牛方路 on 15/5/6.
//  Copyright (c) 2015年 蓝鸥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRZXZHScrollViewLB : UIScrollView

@property (nonatomic, assign)NSInteger time;


@property (nonatomic, strong)NSArray *imageArray;


//初始化方法。
- (instancetype)initWithFrame:(CGRect)frame WithImageName:(NSArray *)imageNames WithTime:(NSInteger)time;


@end
