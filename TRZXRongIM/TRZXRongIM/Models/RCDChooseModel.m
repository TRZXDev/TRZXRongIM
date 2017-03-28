//
//  RCDChooseModel.m
//  TRZX
//
//  Created by 移动微 on 16/12/13.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDChooseModel.h"
#import "RCDCommonDefine.h"

@implementation RCDChooseModel

+(RCDChooseModel *)modelWithStr:(NSString *)str{
    RCDChooseModel *model = [[RCDChooseModel alloc] init];
    model.text = str;
    model.textColor = [UIColor trzx_TitleColor];
    model.type = ChooseModelTypeButton;
    return model;
}

+(RCDChooseModel *)modelWithStr:(NSString *)str textColor:(UIColor *)color{
    RCDChooseModel *model = [self modelWithStr:str];
    model.textColor = color;
    return model;
}

+(RCDChooseModel *)modelWithStr:(NSString *)str textColor:(UIColor *)color type:(ChooseModelType)type{
    RCDChooseModel *model = [self modelWithStr:str textColor:color];
    model.type = type;
    return model;
}

@end
