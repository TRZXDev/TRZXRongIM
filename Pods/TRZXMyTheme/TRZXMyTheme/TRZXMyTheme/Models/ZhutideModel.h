////
////  ZhutideModel.h
////  tourongzhuanjia
////
////  Created by 移动微世界 on 16/1/6.
////  Copyright © 2016年 JWZhang. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//@class Areas,Childerlist;
//@interface ZhutideModel : NSObject
//


#import <Foundation/Foundation.h>

@class Childerlist;
@interface ZhutideModel : NSObject

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *name;

@end

@interface Childerlist : NSObject

@property (nonatomic, copy) NSString *childList;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *name;

@end

