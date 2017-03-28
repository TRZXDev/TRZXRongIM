//
//  PasswordEnterView.h
//  FJF
//
//  Created by fengjiefeng on 15/8/8.
//  Copyright (c) 2015年 fengjiefeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordTextField.h"

typedef void (^ClickedHandler)(PasswordTextField *textField);

typedef void (^ClickedTextDetail)(NSString *textDetail);

@interface PasswordEnterView : UIView

-(id)initWithFrame:(CGRect)frame count:(NSInteger)count isCiphertext:(BOOL)isCiphertext textField:(ClickedHandler)textField;

///输出内容
@property (nonatomic,copy)ClickedTextDetail textDetail;

/** 清空密码 */
-(void)clearPassword;
@end
