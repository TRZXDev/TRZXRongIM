//
//  ZXShouMode.m
//  tourongzhuanjia
//
//  Created by sweet luo on 15/10/23.
//  Copyright © 2015年 KristyFuWa. All rights reserved.
//

#import "ZXShouMode.h"
#import <objc/runtime.h>

@implementation ZXShouMode
+(instancetype)ZXShouModelWithDict:(NSDictionary *)dict{
    return [[ZXShouMode alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    
    NSArray *array = [self getClassProperties];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString *key = obj;
        
        if (dict[key]) {
            [self setValue:dict[key] forKey:key];
        }
    }];
    
    return self;
}

- (NSArray *)getClassProperties

{
    
    unsigned int count;
    
    
    
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    
    
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t pro = properties[i];
        
        
        
        const char *name = property_getName(pro);
        
        
        
        NSString *property = [NSString stringWithUTF8String:name];
        
        
        
        [array addObject:property];
        
        
        
    }
    
    return array;
    
}



@end


