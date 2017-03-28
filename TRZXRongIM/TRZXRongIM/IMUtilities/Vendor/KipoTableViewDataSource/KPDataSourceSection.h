//
//  KPDataSourceSection.h
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/24.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBaseTableViewDataSource.h"


@interface KPDataSourceSection : NSObject

@property(nonatomic ,strong) NSArray *data;
@property(nonatomic ,strong) Class cell;
@property(nonatomic ,copy) NSString *identifier;
@property(nonatomic ,copy) AdapterBlock adapter;
@property(nonatomic ,copy) EventBlock event;
@property(nonatomic ,copy) NSString *headerTitle;
@property(nonatomic ,copy) NSString *footerTitle;
@property(nonatomic ,strong)UIView *headerView;
@property(nonatomic ,strong)UIView *footerView;
@property(nonatomic ,assign)BOOL isAutoHeight;
@property(nonatomic ,assign)CGFloat staticHeight;

@property(nonatomic ,assign)UITableViewCellStyle tableViewCellStyle;

@end
