//
//  MiMaPopView.h
//  tourongzhuanjia
//
//  Created by 投融在线 on 16/2/24.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "payTool.h"

/**
 *  密码输入框
 */
@interface VerifyPasswordPopView : UIView

@property (nonatomic,copy)NSString *mid;

@property (nonatomic,copy)void (^paySuccess)();

/**
 *  action:meet or videoz or financingMargin or expert
 */
@property (nonatomic,copy)NSString *actionStr;

@property (nonatomic,copy)NSString *targetType;

@property(nonatomic,copy)NSString *amountStr;

@property(nonatomic,copy)NSString *typeStr;

- (instancetype)initWithFrame:(CGRect)frame requestType:(BOOL)is;

@end
