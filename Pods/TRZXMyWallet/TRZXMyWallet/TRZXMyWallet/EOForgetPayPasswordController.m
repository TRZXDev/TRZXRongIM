//
//  EOForgetPayPasswordController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOForgetPayPasswordController.h"
#import "EOUpdatePasswordTableViewCell.h"
#import "EOWalletAddCardTableViewCell.h"
#import "EOWalletNoteDetailHeaderView.h"


#import "TRZXWalletMacro.h"



static  NSString *deatilIdentifier = @"EOUpdatePasswordTableViewCell";
static  NSString *addIdentifier = @"EOWalletAddCardTableViewCell";


@interface EOForgetPayPasswordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UITextField *newpasswordTF;
@property (nonatomic, strong) UITextField *aginPasswordTF;
@property (nonatomic,strong ) UITableView *tableView;


@property (nonatomic,assign)BOOL isSend;//是否发送;
@end

@implementation EOForgetPayPasswordController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createUI];
}

- (void)initData
{
    
}

- (void)createUI
{

    EOWalletNoteDetailHeaderView *headerView = [[TRZXWalletBundle loadNibNamed:@"EOWalletNoteDetailHeaderView" owner:self options:nil] firstObject];
    headerView.frame                         = CGRectMake(0, 0,SCREEN_WIDTH,60);
    headerView.topLable.hidden = NO;
    headerView.bottomLabel.hidden = NO;
    headerView.accountTotal.hidden = YES;
    headerView.dateLabel.hidden = YES;
    
//    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"17310220038"];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@",[Login curLoginUser].mobile?[Login curLoginUser].mobile:@"12345678901"];
    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    headerView.bottomLabel.text = [NSString stringWithFormat:@"验证码将发送至手机：%@.请按提示操作。",str];
    
    self.tableView.tableHeaderView           = headerView;
    [self.view addSubview:self.tableView];
    
    [self registerTitleLabe:@"找回支付密码"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOUpdatePasswordTableViewCell" bundle:nil] forCellReuseIdentifier:deatilIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:addIdentifier];

}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    
        EOUpdatePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deatilIdentifier];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOUpdatePasswordTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.sendCodeButton.hidden = NO;
        cell.sendCodeButton.backgroundColor = TRZXWalletMainColor;
        [cell.sendCodeButton setNeedsDisplay];
        [self setUpTextFieldUpdate:cell];
        return cell;
        
    }else if (indexPath.row == 1)
    {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.backgroundColor = WalletbackColor;
            return cell;
    }
    else if (indexPath.row == 2)
    {
        EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addLabel.text = @"确定";
        cell.addLabel.textColor = [UIColor whiteColor];
        cell.addLabel.backgroundColor = TRZXWalletMainColor;
        return cell;
        
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0) {
            return 183;
        }else if (indexPath.row == 1)
        {
            return 44;
        }
        return 55;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {

           
            //修改密码
            if (self.codeTF.text.length < 1) {
//                [LCProgressHUD showInfoMsg:@"请输入验证码"]; // 显示提示

                return;
            }
            if (self.newpasswordTF.text.length < 1) {
//                [LCProgressHUD showInfoMsg:@"请输入新密码"]; // 显示提示

                return;
            }
        if (self.newpasswordTF.text.length < 6) {
//            [LCProgressHUD showInfoMsg:@"密码为6位数字组成"];
            return;
        }
            if (self.aginPasswordTF.text.length < 1) {
//                [LCProgressHUD showInfoMsg:@"请再次输入新密码"];
                return;
            }
        if (self.aginPasswordTF.text.length < 6) {
//            [LCProgressHUD showInfoMsg:@"密码为6位数字组成"];
            return;
        }
            if (![self.aginPasswordTF.text isEqualToString:self.newpasswordTF.text]) {
//                [LCProgressHUD showInfoMsg:@"两次新密码输入不一致"];
                return;
            }
            
            [self updatePasswordWithPassword:self.codeTF.text newPassword:self.aginPasswordTF.text];
            
        }

}


//忘记密码
- (void)updatePasswordWithPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    newPassword = [NSString wallet_getMd5_32Bit_String:newPassword isUppercase:NO];
    [EOMyWalletViewModel forgetPasswordWithPassword:oldPassword newPassword:newPassword success:^(id responseObj) {
        
        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            
//            [LCProgressHUD showInfoMsg:@"修改成功"];
            NSLog(@"修改成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSLog(@"%@",responseObj[@"status_dec"]?responseObj[@"status_dec"]:@"加载失败");
//            [LCProgressHUD showFailure:responseObj[@"status_dec"]?responseObj[@"status_dec"]:@"加载失败"];   // 显示失败
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)addBank
{
   

}
- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  修改密码
 *
 *  @param cell /
 */
- (void)setUpTextFieldUpdate:(EOUpdatePasswordTableViewCell *)cell
{
    cell.passwordTF.delegate = self;
    cell.passwordTF.placeholder = @" 填写验证码";
    cell.newpasswordTF.delegate = self;
    cell.againPasswordTF.delegate = self;
    self.codeTF = cell.passwordTF;
    self.codeTF.secureTextEntry = NO;
    self.newpasswordTF = cell.newpasswordTF;
    self.aginPasswordTF = cell.againPasswordTF;
    
    cell.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    cell.newpasswordTF.keyboardType = UIKeyboardTypeNumberPad;
    cell.againPasswordTF.keyboardType =UIKeyboardTypeNumberPad;
    
    [cell.passwordTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.newpasswordTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.againPasswordTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.sendCodeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma  mark - 文本改变的通知
- (void)textChanged:(UITextField *)textfield
{

    if ([textfield isEqual:self.newpasswordTF]||[textfield isEqual:self.aginPasswordTF]) {
        if (textfield.text.length <= 6) {
        } else {
            NSString *subText = [textfield.text substringToIndex:7-1];
            textfield.text = subText;
        }
    }
    if ([textfield isEqual:self.codeTF]) {
        if (textfield.text.length <= 4) {
        } else {
            NSString *subText = [textfield.text substringToIndex:5-1];
            textfield.text = subText;
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    if ([textField isEqual:self.newpasswordTF]||[textField isEqual:self.aginPasswordTF])
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletAlphaNum] invertedSet];
    }else if ([textField isEqual:self.codeTF])
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletNumbers] invertedSet];
    }
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}


//发送验证码
- (void)sendCode:(UIButton *)button
{
    [self.view endEditing:YES];
  
    [EOMyWalletViewModel forgetPassSmsSuccess:^(id responseObj) {
        
        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            
//            [LCProgressHUD showFailure:@"验证码发送成功"];   // 显示失败
            
            __block int timeout=59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [button setTitle:@"重新发送" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:14];
                        button.enabled = YES;
                        
                        
                    });
                }else if ([responseObj[@"status_code"] isEqualToString:@"205"]) {
//                    [LCProgressHUD showFailure:@"验证码发送失败"];   // 显示失败
                }else {
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [button setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:12];
                        button.enabled = NO;
                        self.isSend = YES;
                        EOWalletNoteDetailHeaderView *headerView = (EOWalletNoteDetailHeaderView *)self.tableView.tableHeaderView;
//                        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"17310220036"];
                        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@",[Login curLoginUser].mobile?[Login curLoginUser].mobile:@"12345678901"];
                        if (str.length > 0) {
                            [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                            headerView.bottomLabel.text = [NSString stringWithFormat:@"验证码将发送至手机：%@.请按提示操作。",str];
                        }
                        
                        headerView.topLable.text = @"本次操作需要短信确认,";
                    });
                    
                    timeout--;
                    
                }
            });
            dispatch_resume(timer);
            
        }

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - setter/getter------------------------------------------------------------------------
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = WalletbackColor;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
