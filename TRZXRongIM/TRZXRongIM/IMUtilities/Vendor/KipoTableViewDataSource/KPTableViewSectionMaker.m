//
//  KPTableViewSectionMaker.m
//  KipoTableViewDataSource
//
//  Created by 移动微 on 16/9/27.
//  Copyright © 2016年 移动微. All rights reserved.
//

#import "KPTableViewSectionMaker.h"
#import "KPDataSourceSection.h"

#pragma mark -- Class KPDataSourceSectionMaker

@implementation KPTableViewSectionMaker


-(KPTableViewSectionMaker *(^)(__unsafe_unretained Class))cell{
    return ^KPTableViewSectionMaker *(Class cell){
        self.section.cell = cell;
        if (!self.section.identifier) {
            self.section.identifier = [self getIdentifier];
        }
        return self;
    };
}

-(KPTableViewSectionMaker *(^)(NSArray *))data{
    return ^KPTableViewSectionMaker *(NSArray *data){
        self.section.data = data;
        return self;
    };
}

- (KPTableViewSectionMaker * (^)(AdapterBlock))adapter {
    return ^KPTableViewSectionMaker *(AdapterBlock adapterBlock) {
        self.section.adapter = adapterBlock;
        return self;
    };
}

-(KPTableViewSectionMaker *(^)(CGFloat))height{
    return ^KPTableViewSectionMaker *(CGFloat height){
        self.section.staticHeight = height;
        return self;
    };
}

-(KPTableViewSectionMaker *(^)())autoHeight{
    return ^KPTableViewSectionMaker *{
        self.section.isAutoHeight = YES;
        return self;
    };
}

-(KPTableViewSectionMaker *(^)(EventBlock))Event{
    return ^KPTableViewSectionMaker *(EventBlock event){
        self.section.event = event;
        return self;
    };
}
-(KPTableViewSectionMaker *(^)(NSString *))headerTitle{
    return ^KPTableViewSectionMaker *(NSString *headerTitle){
        self.section.headerTitle = headerTitle;
        return self;
    };
}

-(KPTableViewSectionMaker *(^)(NSString *))footerTitle{
    return ^KPTableViewSectionMaker *(NSString *footerTitle){
        self.section.footerTitle = footerTitle;
        return self;
    };
}

-(KPTableViewSectionMaker *(^)(UIView *(^)()))headerView{
    return ^KPTableViewSectionMaker *(UIView *(^view)()){
        self.section.headerView = view();
        return self;
    };
}

-(KPTableViewSectionMaker *(^)(UIView *(^)()))footerView{
    return ^KPTableViewSectionMaker *(UIView *(^view)()){
        self.section.footerView = view();
        return self;
    };
}


#pragma mark - Helper
-(NSString *)getIdentifier{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *refStr = (__bridge NSString *)(uuidStrRef);
    CFRelease(uuidStrRef);
    return refStr;
}


#pragma mark - properties
-(KPDataSourceSection *)section{
    if (!_section) {
        _section = [KPDataSourceSection new];
    }
    return _section;
}

@end
