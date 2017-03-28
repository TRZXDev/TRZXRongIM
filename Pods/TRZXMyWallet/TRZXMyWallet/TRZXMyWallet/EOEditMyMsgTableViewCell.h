//
//  EOEditMyMsgTableViewCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOEditMyMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *bankPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *userNumberTF;
@property (weak, nonatomic) IBOutlet UIView *bankNameBgView;

@end
