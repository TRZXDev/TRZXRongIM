//
//  ChooseMode.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/26.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChooseData;
@interface ChooseMode : NSObject


@property (nonatomic, copy) NSString *status_dec;

@property (nonatomic, strong) NSArray<ChooseData *> *data;

@property (nonatomic, copy) NSString *status_code;

@end
@interface ChooseData : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *meetDate;

@property (nonatomic, copy) NSString *meetAddr;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *meetAddrName;

@end

