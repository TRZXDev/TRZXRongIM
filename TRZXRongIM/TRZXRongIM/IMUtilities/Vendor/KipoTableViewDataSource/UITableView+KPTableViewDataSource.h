//
//  UITableView+KPTableViewDataSource.h
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/27.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

//      ============= 简介 ==============
//KPTableViewDataSource主要解决了以下几个问题：
//1.避免了书写各种乱七八糟的宏定义，自动注册cell类，自动设置identifier。
//2.提供了一套完美解决不同高度cell的计算问题，提供自动计算cell高度的接口。
//3.提供一套优雅的api，十分优雅并且有逻辑地书写dataSource。
//4.优化代码,缩减代码量.能有效解决代码逻辑复杂的问题
//-- 如不懂使用 或 有关了解实现原理 请咨询技术小闭
//      ================================

@class KPBaseTableViewDataSource,KPTableViewDataSourceMaker;
@interface UITableView (KPTableViewDataSource)

@property(nonatomic, strong) KPBaseTableViewDataSource *KPTableViewDataSource;

-(void)kipo_makeDataSource:(void (^)(KPTableViewDataSourceMaker *make))maker;
-(void)kipo_makeSectionWithData:(NSArray *)data;
-(void)kipo_makeSectionWithData:(NSArray *)data andCellClass:(Class)cellClass;

@end


__attribute__ ((unused)) static void commitEditing(id self, SEL cmd , UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);

__attribute__((unused)) static void scrollViewDidScroll(id self, SEL cmd, UIScrollView *scrollView);



