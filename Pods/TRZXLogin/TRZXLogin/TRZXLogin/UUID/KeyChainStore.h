//
//  KeyChainStore.h
//  GetUUID-Demo
//
//  Created by ZD on 2016/11/8.
//  Copyright © 2016年 ZD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
