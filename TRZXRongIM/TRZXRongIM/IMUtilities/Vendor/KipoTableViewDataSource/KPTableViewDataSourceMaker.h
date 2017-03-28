//
//  KPTableViewDataSourceMaker.h
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/26.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Class KPTableViewDataSourceMaker
@class KPTableViewSectionMaker;

@interface KPTableViewDataSourceMaker : NSObject

-(void)makeSection:(void(^)(KPTableViewSectionMaker *section))block;

@property(nonatomic, weak)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *sections;

-(instancetype)initWithTableView:(UITableView *)tableView;
-(KPTableViewDataSourceMaker * (^)(CGFloat))height;
-(KPTableViewDataSourceMaker * (^)(UIView *(^)()))headerView;
-(KPTableViewDataSourceMaker * (^)(UIView *(^)()))footerView;

-(void)commitEditing:(void(^)(UITableView *tableView,UITableViewCellEditingStyle *editingStyle, NSIndexPath *indexPath))block;
-(void)scrollViewDidScroll:(void(^)(UIScrollView *scrollView))block;

@property(nonatomic, copy) void(^commitEditingBlock)(UITableView *tableView,UITableViewCellEditingStyle *editingStyle , NSIndexPath *indexPath);
@property(nonatomic, copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);


@end
