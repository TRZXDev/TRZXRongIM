//
//  KPBaseTableViewDataSource.h
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/24.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPDataSourceSection;

@protocol KPBaseTableViewDataSourceProtocol <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)NSMutableArray<KPDataSourceSection *>*sections;
@property(nonatomic ,strong)NSMutableDictionary *delegates;

@end

typedef void (^AdapterBlock)(id cell, id data, NSUInteger index);
typedef void (^EventBlock)(NSUInteger index, id data);

@interface KPBaseTableViewDataSource : NSObject<KPBaseTableViewDataSourceProtocol>

@property(nonatomic, strong)NSMutableArray<KPDataSourceSection *>*sections;

@end

@interface KPSampleTableViewDataSource : KPBaseTableViewDataSource


@end

