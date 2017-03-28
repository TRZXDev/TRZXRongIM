//
//  RCDChooseView.h
//  TRZX
//
//  Created by 移动微 on 16/12/2.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDChooseModel.h"

/**
 选择视图
 */
@interface RCDChooseView : UIView

/**
 构造方法并显示在 window

 @param array         包含RCDChooseModel的数组
 @param didClickBlock 点击Button返回下标回调
 */
+(void)ChooseViewWithArray:(NSArray<RCDChooseModel *> *)array didClickBlock:(void(^)(NSUInteger index))didClickBlock;

@end
