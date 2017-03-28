//
//  MyExpertViewController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadCountersignController;
@class LoadEvaluateController;
@class LoadPaymentController;
@class YesEvaluateController;

@protocol MyView3Deledate <NSObject>

- (void)changeState;

@end
@interface MyExpertViewController : UIViewController

{
    NSArray *meetArr;
    NSArray *evaluateArr;
    NSArray *overArr;
}

@property (strong, nonatomic)LoadCountersignController *loadController;
@property (strong, nonatomic)LoadEvaluateController *LoadEvaluateController;
@property (strong, nonatomic)LoadPaymentController *LoadPaymentController;
@property (strong, nonatomic)NSString *status;


@property (strong, nonatomic)YesEvaluateController *zhaungtaiVC;

@property (strong, nonatomic)NSString *backStr;
@property (weak, nonatomic) id<MyView3Deledate>deledate;
@end
