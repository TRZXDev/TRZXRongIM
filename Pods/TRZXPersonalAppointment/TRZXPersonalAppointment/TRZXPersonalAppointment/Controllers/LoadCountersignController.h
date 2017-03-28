//
//  LoadCountersignController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CancelViewController;
@protocol zhuangtai2Delegate <NSObject>
- (void)push1ZhuangTai;
@end
@interface LoadCountersignController : UIViewController

@property (strong, nonatomic)CancelViewController *cancelVC;

@property (copy, nonatomic) NSString *superType;
@property (strong, nonatomic) NSString *conventionId;

@property(nonatomic,copy)NSString *titleName;
@property (nonatomic, weak) id<zhuangtai2Delegate>delegate;

@end
