//
//  KPTableViewDataSourceMaker.m
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/26.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import "KPTableViewDataSourceMaker.h"
#import "KPTableViewSectionMaker.h"
#import "KPDataSourceSection.h"


#pragma mark -- Class KPTableViewDataSourceMaker

@implementation KPTableViewDataSourceMaker

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (KPTableViewDataSourceMaker * (^)(UIView * (^)()))headerView {
    return ^KPTableViewDataSourceMaker *(UIView * (^view)()) {
        UIView * headerView =  view();
        [self.tableView.tableHeaderView layoutIfNeeded];
        self.tableView.tableHeaderView = headerView;
        return self;
    };
}

- (KPTableViewDataSourceMaker * (^)(UIView * (^)()))footerView {
    return ^KPTableViewDataSourceMaker *(UIView * (^view)()) {
        UIView * footerView = view();
        [self.tableView.tableFooterView layoutIfNeeded];
        self.tableView.tableFooterView = footerView;
        return self;
    };
}

- (KPTableViewDataSourceMaker * (^)(CGFloat))height {
    return ^KPTableViewDataSourceMaker *(CGFloat height) {
        self.tableView.rowHeight = height;
        return self;
    };
}

- (void)commitEditing:(void (^)(UITableView * tableView,UITableViewCellEditingStyle * editingStyle, NSIndexPath * indexPath))block {
    self.commitEditingBlock = block;
}

- (void)scrollViewDidScroll:(void (^)(UIScrollView * scrollView))block {
    self.scrollViewDidScrollBlock = block;
}

- (void)makeSection:(void (^)(KPTableViewSectionMaker * section))block {
    KPTableViewSectionMaker * sectionMaker = [KPTableViewSectionMaker new];
    block(sectionMaker);
    if (sectionMaker.section.cell) {
        [self.tableView registerClass:sectionMaker.section.cell forCellReuseIdentifier:sectionMaker.section.identifier];
    }
    [self.sections addObject:sectionMaker.section];
}

- (NSMutableArray *)sections {
    if (! _sections) {
        _sections = [NSMutableArray new];
    }
    return _sections;
}

@end
