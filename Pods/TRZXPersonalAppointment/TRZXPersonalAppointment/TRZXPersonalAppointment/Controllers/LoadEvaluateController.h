//
//  LoadEvaluateController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YesEvaluateController;
@protocol zhuangtai3Delegate <NSObject>
- (void)push1ZhuangTai;
@end

/**
 *  评价
 */
@interface LoadEvaluateController : UIViewController

@property (strong, nonatomic)YesEvaluateController *YesEvaluateVc;

@property (copy, nonatomic) NSString *mid;
@property (nonatomic, weak) id<zhuangtai3Delegate>delegate;

@end
