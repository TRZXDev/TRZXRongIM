//
//  EOUpdatePasswordTableViewCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  修改密码
 */
@interface EOUpdatePasswordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTF;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *lineView0;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;


@end
