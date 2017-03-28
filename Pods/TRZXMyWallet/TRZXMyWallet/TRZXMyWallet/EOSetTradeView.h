//
//  EOSetTradeView.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/24.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOSetTradeView : UIViewController
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;

@property (nonatomic, copy) NSString *titleStr, *detail;
@property (nonatomic, assign) CGFloat amount;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

@property (nonatomic,copy) void (^exit)();

@property (nonatomic,copy)NSString *firtPassword;



- (void)show;
- (void)dismiss;
@end
