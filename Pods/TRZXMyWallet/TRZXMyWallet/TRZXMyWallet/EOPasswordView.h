//
//  EOPasswordView.h
//  TRZX
//
//  Created by Rhino on 2016/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOPasswordView : UIView


/** 密码长度： 默认为6位 */
@property (nonatomic,assign) NSInteger passwordLength;

@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) void(^PasswordCompeleteBlock)(NSString *password);


/** 开始输入 */
-(void)beginInput;

/** 结束输入 */
-(void)endInput;

/** 清空密码 */
-(void)clearPassword;

@end
