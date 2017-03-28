//
//  PhotoTimeModel.h
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/26.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoTimeModel : NSObject
@property (readwrite, nonatomic, strong) NSNumber *pageNo, *pageSize, *totalPage;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

@property (readwrite, nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *thisUser;


-(NSDictionary *)toTipsParams:(NSString*)thisUser;

- (void)configWithObj:(PhotoTimeModel *)model;


@end
