//
//  LoadPaymentController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTimeController.h"
@protocol zhuangtai4Delegate <NSObject>
- (void)push1ZhuangTai;
@end

/**
 *  待学院付款
 */
@interface LoadPaymentController : UIViewController

@property (strong, nonatomic)ChooseTimeController *chooseTimeVC;
@property (strong, nonatomic) NSString *conventionId;
@property (nonatomic, weak) id<zhuangtai4Delegate>delegate;


@end
