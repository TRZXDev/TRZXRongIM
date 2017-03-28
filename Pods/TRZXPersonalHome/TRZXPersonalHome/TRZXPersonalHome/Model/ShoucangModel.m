//
//  shoucangModel.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/18.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ShoucangModel.h"
#import <objc/runtime.h>

@implementation ShoucangModel



+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [MyData class]};
}
@end


@implementation MyData
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
            Ivar const ivar = *p;
            
            //获取变量名
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

@end


@implementation Collectioned
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
            Ivar const ivar = *p;
            
            //获取变量名
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

//赋值给前面的

//+(NSDictionary *)replacedKeyFromPropertyName{
//    
//    return@{@"photo": @"userPic",@"photo": @"userPic"};
//    
//}

@end


