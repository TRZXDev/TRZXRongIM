//
//  RCDGroupInfo.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/19.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDGroupInfo.h"
#import "RCDUserInfo.h"
#import <objc/runtime.h>

@implementation RCDGroupInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"users":[RCDUserInfo class]};
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        
        unsigned int outCount = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
            
            Ivar const ivar = *p;
            //获取变量名
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            id value = [decoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    unsigned int outCount = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (const Ivar *p; p < ivars + outCount; ++p) {
        
        Ivar const ivar = *p;
        //获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //获取值
        id value = [self valueForKey:key];
        //设置编码
        [encoder encodeObject:value forKey:key];
    }
}

#pragma mark - Properties
-(void)setName:(NSString *)name{
    _name = name;
    self.groupName = name;
}

-(void)setMid:(NSString *)mid{
    _mid = mid;
    self.groupId = mid;
}

@end
