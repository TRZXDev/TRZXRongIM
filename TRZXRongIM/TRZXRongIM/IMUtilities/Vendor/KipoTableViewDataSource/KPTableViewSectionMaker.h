//
//  KPTableViewSectionMaker.h
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/27.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Class KPDataSourceSectionMaker
@class KPDataSourceSection;
@interface KPTableViewSectionMaker : NSObject

-(KPTableViewSectionMaker * (^)(Class))cell;

-(KPTableViewSectionMaker * (^)(NSArray *))data;

-(KPTableViewSectionMaker * (^)(void(^)(id cell, id data, NSUInteger index)))adapter;

-(KPTableViewSectionMaker * (^)(CGFloat))height;

-(KPTableViewSectionMaker * (^)())autoHeight;

-(KPTableViewSectionMaker * (^)(void (^)(NSUInteger index, id data)))Event;

-(KPTableViewSectionMaker * (^)(NSString *))headerTitle;
-(KPTableViewSectionMaker * (^)(NSString *))footerTitle;


-(KPTableViewSectionMaker * (^)(UIView *(^)()))headerView;
-(KPTableViewSectionMaker * (^)(UIView *(^)()))footerView;

@property(nonatomic,strong) KPDataSourceSection *section;

@end
