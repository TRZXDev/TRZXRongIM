//
//  PhotoTimeModel.m
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/26.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PhotoTimeModel.h"
#import "TRZXPhotoTextModel.h"
@implementation PhotoTimeModel

+(NSDictionary *)objectClassInArray{
    return @{@"data":[TRZXPhotoTextModel class]};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _canLoadMore = NO;
        _isLoading = _willLoadMore = NO;
        _pageNo = [NSNumber numberWithInteger:1];
        _pageSize = [NSNumber numberWithInteger:10];
    }
    return self;
}

-(NSDictionary *)toTipsParams:(NSString*)thisUser{

    _thisUser = thisUser;
    NSDictionary *params = @{@"pageNo" : _willLoadMore? [NSNumber numberWithInteger:_pageNo.integerValue +1]: [NSNumber numberWithInteger:1],@"pageSize" : _pageSize,@"thisUser" : thisUser};
    return params;
}


- (void)configWithObj:(PhotoTimeModel *)model{

    self.pageNo = model.pageNo;
    self.pageSize = model.pageSize;
    self.totalPage = model.totalPage;

    if (_willLoadMore) {
        [self.data addObjectsFromArray:model.data];
    }else{
        self.data = [NSMutableArray arrayWithArray:model.data];
        if ([_thisUser isEqualToString:@""]) {//默认自己的ID
            TRZXPhotoTextModel *model = [[TRZXPhotoTextModel alloc]init];
            model.type = @"my";
            [self.data insertObject:model atIndex:0];
        }
    }
    _canLoadMore = _pageNo.intValue < _totalPage.intValue;
    
}

@end
