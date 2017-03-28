//
//  DCPaymentView.h
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentView : UIViewController

@property (nonatomic, copy) NSString *titleStr, *detail;
@property (nonatomic, assign) CGFloat amount;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

@property (nonatomic,copy) void (^exit)();

@property (nonatomic,copy)NSString *firtPassword;



- (void)show;

@end
