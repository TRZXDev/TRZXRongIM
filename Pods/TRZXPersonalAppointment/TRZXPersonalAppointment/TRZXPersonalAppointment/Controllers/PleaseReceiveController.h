//
//  PleaseReceiveController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/22.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RefuseController;
@class CreateTimeController;
@protocol zhuangtai5Delegate <NSObject>
- (void)push1ZhuangTai;
@end
/**
 *  请专家确认
 */
@interface PleaseReceiveController : UIViewController

@property (strong, nonatomic)RefuseController *refuseVC;
@property (strong, nonatomic)CreateTimeController *createTimeVC;

@property (copy, nonatomic)NSString *mid;
@property (nonatomic, weak) id<zhuangtai5Delegate>delegate;

@end
