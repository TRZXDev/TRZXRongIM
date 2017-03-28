//
//  EOEditMyInfoViewController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOEditMyInfoViewController.h"

#import "EOWalletAddCardTableViewCell.h"
#import "EOUpdatePasswordTableViewCell.h"

#import "TRZXWalletMacro.h"


static  NSString *addIdentifier    = @"EOWalletAddCardTableViewCell";
static  NSString *updateIdentifier = @"EOUpdatePasswordTableViewCell";


@interface EOEditMyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray     *heightArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *upPasswordTF;
@property (nonatomic, strong) UITextField *newpasswordTF;
@property (nonatomic, strong) UITextField *aginPasswordTF;

@end

@implementation EOEditMyInfoViewController

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


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)initData
{
 
}

- (void)createUI
{
    
//    navigationView1.backgroundColor = TRZXWalletMainColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:addIdentifier];
//    
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOUpdatePasswordTableViewCell" bundle:nil] forCellReuseIdentifier:updateIdentifier];
    self.heightArray = @[@"183",@"58"];
    [self registerTitleLabe:@"修改支付密码"];
        
//    logintTitleLabel.textColor = [UIColor whiteColor];
//    [self NoImagebackButtonNoImage];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
       EOWalletAddCardTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addLabel.text = @"提交";
        cell.addLabel.textColor = [UIColor whiteColor];
        cell.addLabel.backgroundColor = TRZXWalletMainColor;
        return cell;
    }
        EOUpdatePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:updateIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOUpdatePasswordTableViewCell class]) owner:nil options:nil] firstObject];
        }
        [self setUpTextFieldUpdate:cell];
        return cell;
}

/**
 *  修改支付密码
 *
 *  @param cell /
 */
- (void)setUpTextFieldUpdate:(EOUpdatePasswordTableViewCell *)cell
{
    cell.passwordTF.delegate = self;
    cell.newpasswordTF.delegate = self;
    cell.againPasswordTF.delegate = self;
    
    cell.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    cell.newpasswordTF.keyboardType = UIKeyboardTypeNumberPad;
    cell.againPasswordTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.upPasswordTF = cell.passwordTF;
    self.newpasswordTF = cell.newpasswordTF;
    self.aginPasswordTF = cell.againPasswordTF;
    
    [cell.passwordTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.newpasswordTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.againPasswordTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

#pragma  mark - 文本改变的通知
- (void)textChanged:(UITextField *)textfield
{
    if ([textfield isEqual:self.newpasswordTF]||[textfield isEqual:self.upPasswordTF]||[textfield isEqual:self.aginPasswordTF]) {
        if (textfield.text.length <= 6) {
        } else {
            NSString *subText = [textfield.text substringToIndex:7-1];
            textfield.text = subText;
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
   if ([textField isEqual:self.newpasswordTF]||[textField isEqual:self.upPasswordTF]||[textField isEqual:self.aginPasswordTF])
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletAlphaNum] invertedSet];
    }
    
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
    //修改支付密码
        if (self.upPasswordTF.text.length < 1) {
//            [LCProgressHUD showInfoMsg:@"请输入旧密码"];
            return;
        }
        if (self.upPasswordTF.text.length < 6) {
//            [LCProgressHUD showInfoMsg:@"密码为6位数字组成"];
            return;
        }
        if (self.newpasswordTF.text.length < 1) {
//            [LCProgressHUD showInfoMsg:@"请输入新密码"];
            return;
        }
        if (self.newpasswordTF.text.length < 6) {
//            [LCProgressHUD showInfoMsg:@"密码为6位数字组成"];
            return;
        }
        if (self.aginPasswordTF.text.length < 1) {
//            [LCProgressHUD showInfoMsg:@"请再次输入新密码"];
            return;
        }
        if (self.aginPasswordTF.text.length < 6) {
//            [LCProgressHUD showInfoMsg:@"密码为6位数字组成"];
            return;
        }
        if (![self.aginPasswordTF.text isEqualToString:self.newpasswordTF.text]) {
//            [LCProgressHUD showInfoMsg:@"两次新密码输入不一致"];
            return;
        }
    
        [self updatePasswordWithPassword:self.upPasswordTF.text newPassword:self.aginPasswordTF.text];
    }
    
}


- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改密码
- (void)updatePasswordWithPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    oldPassword = [NSString wallet_getMd5_32Bit_String:oldPassword isUppercase:NO];
    newPassword = [NSString wallet_getMd5_32Bit_String:newPassword isUppercase:NO];

//    [LCProgressHUD showLoading:@"正在加载"];

    [EOMyWalletViewModel updatePasswordWithPassword:oldPassword newPassword:newPassword Success:^(id json) {
        NSDictionary *responseObj = json;
        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            
//            [LCProgressHUD showInfoMsg:@"修改成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else
        {

//            [LCProgressHUD showInfoMsg:responseObj[@"status_dec"]];
        }

    } failure:^(NSError *error) {

    }];

}

#pragma mark - setter/getter----------------------------------------------------------------
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = WalletbackColor;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       // _tableView.rowHeight = 74;
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
