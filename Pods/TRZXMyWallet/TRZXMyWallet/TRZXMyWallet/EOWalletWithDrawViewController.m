//
//  EOWalletWithDrawViewController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletWithDrawViewController.h"
#import "EOWalletBankCardViewController.h"
#import "EOWithDrawDetailViewController.h"


#import "EOWalletWithDrawTableViewCell.h"
#import "EOWalletAddCardTableViewCell.h"

#import "EOWalletModel.h"
#import "TRZXWalletMacro.h"
#import "DCPaymentView.h"
#import "VerifyPasswordPopView.h"

static NSString *withDrawIdentify = @"EOWalletWithDrawTableViewCell";
static  NSString *addIdentifier = @"EOWalletAddCardTableViewCell";

@interface EOWalletWithDrawViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *moneyTF;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic,strong ) UITableView *tableView;

@property (nonatomic,strong)UIButton *addButton;

@property (nonatomic,copy)NSString *nextBankNumber;

@end

@implementation EOWalletWithDrawViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];




    [self initData];
    [self loadMyCardList];
    [self createUI];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)initData
{
    
}

/**
 *  获取我的银行卡
 */
- (void)loadMyCardList
{
    
//    [EOMyWalletViewModel isHadCardSuccess:^(id json) {
//      
//        NSDictionary *responseObj = json;
//        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
//        NSArray *array = [EOBankModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
//            if (array.count >0) {
//                self.bankModel = [array firstObject];
//            }
//        }
//    } failure:^(NSError * error) {
//        [NSObject showError:error];
//    }];
//    
}

- (void)createUI
{
    self.navigationController.navigationBarHidden = YES;
    [self registerTitleLabe:@"提现"];
   
    [self.view addSubview:self.tableView];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletWithDrawTableViewCell" bundle:nil] forCellReuseIdentifier:withDrawIdentify];
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
        EOWalletWithDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:withDrawIdentify];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletWithDrawTableViewCell class]) owner:nil options:nil] firstObject];
        }
        [cell.chooseCardButton addTarget:self action:@selector(chooseBankCardClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.moneyTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.moneyTF.placeholder = @"单笔提现金额不低于200元";
        self.moneyTF = cell.moneyTF;
        cell.moneyTF.delegate = self;
        cell.bankName.text = self.bankModel.bankName;
        
        NSMutableString *weihaoStr = [NSMutableString stringWithString:self.bankModel.accNo?self.bankModel.accNo:@"1234 6767 9267 6337 787"];
        [weihaoStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.bankModel.accNo.length)];
        NSString *string = [[NSString alloc]initWithFormat:@"尾号 %@",[weihaoStr substringFromIndex:weihaoStr.length - 4]];
        
        
        self.nextBankNumber = [NSString stringWithFormat:@"%@ %@",self.bankModel.bankName,string];
        cell.bankNumber.text = string;
        cell.msgYuELabel.text = [NSString stringWithFormat:@"可用余额：￥%@，7-15个工作日到账",self.amout];
        return cell;
    }else if (indexPath.row == 1)
    {
        EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
        cell.addButton.hidden = NO;
        cell.addButton.enabled = NO;
        cell.addLabel.hidden = YES;
        self.addButton = cell.addButton;
        [self.addButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cells"];
        }

        cell.textLabel.text = [NSString stringWithFormat:@"今日可提现%0.2f元",[self.residual floatValue]];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = WalletBlackColor;
        cell.contentView.backgroundColor = WalletbackColor;
        
        NSInteger length = cell.textLabel.text.length;
        NSRange range = NSMakeRange(5, length-6);        
        NSMutableAttributedString *stringAtt = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        
        [stringAtt setAttributes:@{NSForegroundColorAttributeName:TRZXWalletMainColor} range:range];
        
        cell.textLabel.attributedText = stringAtt;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    }else if (indexPath.row == 2) {
        return 40;
    }
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {


    }
}

/**
 *  验证支付密码
 *
 *  @param password 输入的密码
 */
- (void)authCodeWithPassword:(NSString *)password andButton:(UIButton *)button
{

    VerifyPasswordPopView *mimaView = [[VerifyPasswordPopView alloc]initWithFrame:self.view.bounds];
    mimaView.mid = self.bankModel.mid;
    mimaView.paySuccess = ^(){

//        [LCProgressHUD showLoading:@"正在加载"];
        [EOMyWalletViewModel postCashCardId:self.bankModel.mid amount:self.moneyTF.text Success:^(id json) {
            NSDictionary *responseObj  = json;
//            [LCProgressHUD hide];

            if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
                EOWithDrawDetailViewController *detail= [[EOWithDrawDetailViewController alloc]init];
                detail.money = self.moneyTF.text;
                detail.bankNumber = self.nextBankNumber;
                [self.navigationController pushViewController:detail animated:YES];
            }
        } failure:^(NSError *error) {
//            [NSObject showError:error];
        }];


    };
    [self.view addSubview:mimaView];









}

- (void)goBackReload:(UIButton *)btn
{
    [self popViewController];
}

- (void)popViewController
{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}


/**
 *  选择银行卡
 */
- (void)chooseBankCardClick
{

    EOWalletBankCardViewController *chooseBank = [[EOWalletBankCardViewController alloc]init];
    chooseBank.type = @"2";
    chooseBank.statusBarType = YES;
    __weak EOWalletWithDrawViewController *weakSelf = self;
    chooseBank.bankCallBack = ^(EOBankModel *model)
    {
        weakSelf.bankModel = model;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        EOWalletWithDrawTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.bankName.text = weakSelf.bankModel.bankName;
        NSMutableString *weihaoStr = [NSMutableString stringWithString:weakSelf.bankModel.accNo?weakSelf.bankModel.accNo:@"1234 6767 9267 6337 787"];
        [weihaoStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, weakSelf.bankModel.accNo.length)];
        NSString *string = [[NSString alloc]initWithFormat:@"尾号 %@",[weihaoStr substringFromIndex:weihaoStr.length - 4]];
        
        cell.bankNumber.text = string;
        weakSelf.nextBankNumber = [NSString stringWithFormat:@"%@ %@",weakSelf.bankModel.bankName,string];
        cell.bankNumber.text = weakSelf.bankModel.cardNo;
        weakSelf.nextBankNumber = [NSString stringWithFormat:@"%@ %@",weakSelf.bankModel.bankName,string];

        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:chooseBank animated:YES];
}

#pragma  mark - 文本改变的通知


//设置输入的范围只能是数字 ，考虑粘贴的情况
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([toString floatValue] > 10000) {
        return NO;
    }
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
        self.addButton.backgroundColor = TRZXWalletMainColor;
        self.addButton.userInteractionEnabled = YES;

    }else{
        self.addButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
        self.addButton.userInteractionEnabled = NO;
    }



//    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
//    CGFloat a = [str floatValue];
//    if (a > [self.residual floatValue]&&str.length>4) {
//        return NO;
//    }



    NSCharacterSet *cs;
    if (![self authFloatNumberWithRange:range string:string andTefield:textField]) {
        return [self authFloatNumberWithRange:range string:string andTefield:textField];
    }
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];

    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;

    return YES;
}

/**
 *  验证只有一个小数点,开头不为小数点
 *
 *  @param range  输入框范围
 *  @param string 输入的字符串
 *
 *  @return ~
 */
- (BOOL)authFloatNumberWithRange:(NSRange)range string:(NSString *)string andTefield:(UITextField *)tefield{
    if (range.location == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    if ([tefield.text rangeOfString:@"."].location != NSNotFound &&[string isEqualToString:@"."]) {
        return NO;
    }
    return YES;
}






- (void)textChanged:(UITextField *)textfield
{
    if ([textfield isEqual:self.moneyTF]) {

        NSLog(@">>>>>>>>>>>%f",[self.moneyTF.text floatValue]);
        NSLog(@">>>>>>>>>>>%f",[self.amout floatValue]);

        if ([self.moneyTF.text floatValue] > [self.amout floatValue]||[self.moneyTF.text floatValue]<200||[self.moneyTF.text floatValue] > [self.residual floatValue]) {
            self.addButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
            self.addButton.enabled = NO;
        }
        else
        {
            self.addButton.backgroundColor = TRZXWalletMainColor;
            self.addButton.enabled = YES;
        }
        

    }
    
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    NSCharacterSet *cs;
//    if ([textField isEqual:self.moneyTF]) {
//        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletNumbers] invertedSet];
//    }
//    
//    NSString *filtered =
//    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    BOOL basic = [string isEqualToString:filtered];
//    return basic;
//}

- (void)next:(UIButton *)button
{
  
//    if (self.moneyTF.text.length < 1||[self.moneyTF.text floatValue] < 1) {
//        [LCProgressHUD showInfoMsg:@"提现金额不能为空"];
//        return;
//    }
//    if ([self.moneyTF.text integerValue] > [self.amout integerValue]) {
//        [LCProgressHUD showInfoMsg:@"余额不足!"];
//        return;
//    }
//    if ([self.moneyTF.text floatValue] > [self.residual floatValue]) {
//        [LCProgressHUD showInfoMsg:@"不能高于今日可提现额度"];
//        return;
//    }

    
    [self authCodeWithPassword:@"" andButton:button];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
