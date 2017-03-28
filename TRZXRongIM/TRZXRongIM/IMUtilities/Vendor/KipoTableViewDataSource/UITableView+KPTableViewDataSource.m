//
//  UITableView+KPTableViewDataSource.m
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/27.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+KPTableViewDataSource.h"
#import "KPTableViewSectionMaker.h"
#import "KPTableViewDataSourceMaker.h"
#import "KPBaseTableViewDataSource.h"
#import "KPDataSourceSection.h"

static NSString * getIdentifier (){
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * retStr = (__bridge NSString *) uuidStrRef;
    CFRelease(uuidStrRef);
    return retStr;
}

@implementation UITableView (KPTableViewDataSource)

- (KPBaseTableViewDataSource *)KPTableViewDataSource {
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setKPTableViewDataSource:(KPBaseTableViewDataSource *)KPTableViewDataSource {
    objc_setAssociatedObject(self,@selector(KPTableViewDataSource),KPTableViewDataSource,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)kipo_makeDataSource:(void(^)(KPTableViewDataSourceMaker * make))maker {
    KPTableViewDataSourceMaker * make = [[KPTableViewDataSourceMaker alloc] initWithTableView:self];
    maker(make);
    Class DataSourceClass = [KPBaseTableViewDataSource class];
    NSMutableDictionary * delegates = [[NSMutableDictionary alloc] init];
    if(make.commitEditingBlock||make.scrollViewDidScrollBlock) {
        DataSourceClass = objc_allocateClassPair([KPBaseTableViewDataSource class], [getIdentifier() UTF8String],0);
        if(make.commitEditingBlock) {
            class_addMethod(DataSourceClass,NSSelectorFromString(@"tableView:commitEditingStyle:forRowAtIndexPath:"),(IMP)commitEditing,"v@:@@@");
            delegates[@"tableView:commitEditingStyle:forRowAtIndexPath:"] = make.commitEditingBlock;
        }
        if(make.scrollViewDidScrollBlock) {
            class_addMethod(DataSourceClass,NSSelectorFromString(@"scrollViewDidScroll:"),(IMP)scrollViewDidScroll,"v@:@");
            delegates[@"scrollViewDidScroll:"] = make.scrollViewDidScrollBlock;
        }
    }
    
    if(!self.tableFooterView) {
        self.tableFooterView = [UIView new];
    }
    
    id<KPBaseTableViewDataSourceProtocol> ds = (id<KPBaseTableViewDataSourceProtocol>) [DataSourceClass  new];
    ds.sections = make.sections;
    ds.delegates = delegates;
    self.KPTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
}

- (void)kipo_makeSectionWithData:(NSArray *)data {
    
    NSMutableDictionary * delegates = [[NSMutableDictionary alloc] init];
    KPTableViewSectionMaker * make = [KPTableViewSectionMaker new];
    make.data(data);
    make.cell([UITableViewCell class]);
    [self registerClass:make.section.cell forCellReuseIdentifier:make.section.identifier];
    
    make.section.tableViewCellStyle = UITableViewCellStyleDefault;
    for(NSUInteger i = 0;i<data.count;i++) {
        if(data[i][@"detail"]) {
            make.section.tableViewCellStyle = UITableViewCellStyleSubtitle;
            break;
        }
        if(data[i][@"value"]) {
            make.section.tableViewCellStyle = UITableViewCellStyleValue1;
            break;
        }
    }
    id<KPBaseTableViewDataSourceProtocol> ds = (id<KPBaseTableViewDataSourceProtocol>) [KPSampleTableViewDataSource  new];
    
    if(!self.tableFooterView) {
        self.tableFooterView = [UIView new];
    }
    
    ds.sections = [@[make.section] mutableCopy];
    ds.delegates = delegates;
    self.KPTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)kipo_makeSectionWithData:(NSArray *)data andCellClass:(Class)cellClass {
    [self kipo_makeDataSource:^(KPTableViewDataSourceMaker * make) {
        [make makeSection:^(KPTableViewSectionMaker * section) {
            section.data(data);
            section.cell(cellClass);
            section.adapter(^(id cell,NSDictionary * row,NSUInteger index) {
                if([cell respondsToSelector:NSSelectorFromString(@"configure:")]) {
                    [cell performSelector:NSSelectorFromString(@"configure:") withObject:row];
                } else if([cell respondsToSelector:NSSelectorFromString(@"configure:index:")]) {
                    [cell performSelector:NSSelectorFromString(@"configure:index:") withObject:row withObject:@(index)];
                }
            });
            section.autoHeight();
        }];
    }];
}
#pragma clang diagnostic pop


@end

static void commitEditing(id self, SEL cmd, UITableView *tableView,UITableViewCellEditingStyle editingStyle,NSIndexPath * indexPath)
{
    KPBaseTableViewDataSource * ds = self;
    void(^block)(UITableView *,UITableViewCellEditingStyle ,NSIndexPath * ) = ds.delegates[NSStringFromSelector(cmd)];
    if(block) {
        block(tableView,editingStyle,indexPath);
    }
}

static void scrollViewDidScroll(id self, SEL cmd, UIScrollView * scrollView) {
    KPBaseTableViewDataSource * ds = self;
    void(^block)(UIScrollView *) = ds.delegates[NSStringFromSelector(cmd)];
    if(block) {
        block(scrollView);
    }
};

