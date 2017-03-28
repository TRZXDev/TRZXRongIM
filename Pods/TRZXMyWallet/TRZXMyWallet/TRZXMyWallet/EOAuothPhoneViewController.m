
//
//  EOAuothPhoneViewController.m
//  TRZX
//
//  Created by Rhino on 2016/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOAuothPhoneViewController.h"
#import "EOWalletBankCardViewController.h"

#import "EOWalletNoteDetailHeaderView.h"
#import "EOEditMailTableViewCell.h"
#import "EOWalletAddCardTableViewCell.h"
#import "TRZXWalletMacro.h"



@interface EOAuothPhoneViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong ) UITableView *tableView;

@property (weak, nonatomic)UITextField *identifyingCodeTF;
@property (weak, nonatomic)UIButton *getCodeButton;

@end

@implementation EOAuothPhoneViewController{
    BOOL oneceToken;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
}

- (void)createUI
{
    
    EOWalletNoteDetailHeaderView *headerView = [[TRZXWalletBundle loadNibNamed:@"EOWalletNoteDetailHeaderView" owner:self options:nil] firstObject];
    headerView.frame                         = CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width,60);
    headerView.topLable.hidden = NO;
    headerView.bottomLabel.hidden = NO;
    headerView.accountTotal.hidden = YES;
    headerView.dateLabel.hidden = YES;
    
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@",self.phoneNumber];
    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    headerView.bottomLabel.text = [NSString stringWithFormat:@"验证码已发送至手机：%@.请按提示操作。",str];
    
    self.tableView.tableHeaderView           = headerView;
    [self.view addSubview:self.tableView];
    
    [self registerTitleLabe:@"验证手机号"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOEditMailTableViewCell" bundle:nil] forCellReuseIdentifier:@"EOEditMailTableViewCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"EOWalletAddCardTableViewCell"];
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EOEditMailTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:@"EOEditMailTableViewCell"];
        if (cells == nil) {
          cells =  [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOEditMailTableViewCell class]) owner:nil options:nil] firstObject];
        }
       [cells.tefieldEdit addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cells.tefieldEdit.delegate = self;
        self.identifyingCodeTF = cells.tefieldEdit;
      [cells.getCodeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cells;
    }else if (indexPath.row == 1){
        EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EOWalletAddCardTableViewCell"];
        if (cell == nil) {
          cell=  [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addLabel.text = @"确定";
        cell.addLabel.textColor = [UIColor whiteColor];
        cell.addLabel.backgroundColor = TRZXWalletMainColor;
        return cell;

    }
    return [UITableViewCell new];
}

- (void)textChanged:(UITextField *)textfield
{

        if (textfield.text.length <=4) {
        } else {
            NSString *subText = [textfield.text substringToIndex:5-1];
            textfield.text = subText;
            
        }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletNumbers] invertedSet];
  
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
    
}

//获取验证码
- (void)buttonClick:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    //发送验证码
//    [[Kipo_NetAPIManager sharedManager] request_Sms_Api_loginCode:self.phoneNumber.length?self.phoneNumber:@"" andBlock:^(id data, NSError *error) {
//        if (data) {
//            
//        }
//    }];
//            button.backgroundColor = [UIColor whiteColor];
//            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            button.enabled = NO;
//    
//            __block int timeout=59; //倒计时时间
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//            dispatch_source_set_event_handler(timer, ^{
//                if(timeout<=0){ //倒计时结束，关闭
//                    dispatch_source_cancel(timer);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //设置界面的按钮显示 根据自己需求设置
//                        [button setTitle:@"重新获取" forState:UIControlStateNormal];
//                        button.titleLabel.font = [UIFont systemFontOfSize:12];
//                        button.enabled = YES;
//                        button.backgroundColor = TRZXWalletMainColor;
//                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    });
//                } else {
//                    int seconds = timeout % 60;
//                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [button setTitle:[NSString stringWithFormat:@"获取验证码\n     (%@)",strTime] forState:UIControlStateNormal];
//                        button.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没用
//                        button.titleLabel.font = [UIFont systemFontOfSize:10];
//                        button.enabled = NO;
//                        button.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
//                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//                    });
//                    
//                    timeout--;
//                }
//            });
//            dispatch_resume(timer);
}

#pragma mark - 键盘通知
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 81;
    }else if (indexPath.row == 1)
    {
        return   55;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
        if (self.identifyingCodeTF.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"验证码不能为空"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        if (self.identifyingCodeTF.text.length < 4) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请填写4位验证码"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [self getCardInfoIsAnd:YES];
        
    }
    
}

- (void)getCardInfoIsAnd:(BOOL)isAnd
{
    if (oneceToken) {
        return ;
    }
    oneceToken = YES;
    
//    [[Kipo_NetAPIManager sharedManager] request_UserCard_Api_checkCard_smsCode:self.identifyingCodeTF.text accNo:self.bankNumber mobile:self.phoneNumber andBlock:^(id data, NSError *error) {
//        oneceToken = NO;
//        if(data){
//            [self popViewController];
//        }else{
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误，请重新输入" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////            [alert show];
//        }
//    }];
}



- (void)popViewController
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[EOWalletBankCardViewController class]]){

            EOWalletBankCardViewController * csController = (EOWalletBankCardViewController*)vc;
            [self.navigationController popToViewController:csController animated:YES];
            return;
        }
    }
}



- (void)goBackView:(id)sender
{

    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }


}

- (void)addBank
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
