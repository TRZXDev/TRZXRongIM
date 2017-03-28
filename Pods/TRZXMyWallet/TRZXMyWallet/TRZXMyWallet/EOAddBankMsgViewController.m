//
//  EOAddBankMsgViewController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOAddBankMsgViewController.h"
#import "EOBankAouthViewController.h"

#import "EOEditMyMsgTableViewCell.h"
#import "EOAddBankTypeCell.h"
#import "EOAgreeProTableViewCell.h"
#import "EOWalletAddCardTableViewCell.h"
#import "EOWalletModel.h"
#import "TRZXWalletMacro.h"


//卡类型：列表选择卡类型
//
//卡号：在点击下一步时如果卡号输入有误，提示“卡号输入有误”。输入时限制为数字键盘，每4位以空格分隔
//
//姓名：必须输入中文，至少2个字，在点击下一步时如果姓名输入有误，提示“姓名输入有误”
//
//手机号：必须11位，填写错误显示“手机号填写有误”
//
//开户银行：在点击下一步时如果身份证输入错误时，提示“开户银行填写有误”
//
//点击下一步时数据提交后台，实时验证填写信息，某项有误，不能进入下一步。
//
//多项填写错误，错误提示语显示第一个


static  NSString *editlIdentifier = @"EOEditMyMsgTableViewCell";
static  NSString *addIdentifier =  @"EOWalletAddCardTableViewCell";
static  NSString *agreeIdentifier = @"EOAgreeProTableViewCell";
static  NSString *bankIdentifier = @"EOAddBankTypeCell";

@interface EOAddBankMsgViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong ) UITableView *tableView;

@property (nonatomic, strong) UITextField *cardNoTF;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *bankNameTF;
@property (nonatomic, strong) UITextField *phoneTF;


@end

@implementation EOAddBankMsgViewController{
    BOOL oneceToken;
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
    [self registerTitleLabe:@"填写银行卡信息"];
    [self.view addSubview:self.tableView];

//    [self.tableView registerNib:[UINib nibWithNibName:@"EOAddBankTypeCell" bundle:nil] forCellReuseIdentifier:bankIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOEditMyMsgTableViewCell" bundle:nil] forCellReuseIdentifier:editlIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:addIdentifier];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        EOAddBankTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:bankIdentifier];
        if (cell == nil) {
            cell = [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOAddBankTypeCell class]) owner:nil options:nil] firstObject];
        }
       
        cell.cardNO.delegate =self;
        cell.userNameTF.text = [Login curLoginUser].name;//[KPOUserDefaults name];
        cell.userNameTF.enabled = NO;
        self.cardNoTF = cell.cardNO;
        [cell.userNameTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.cardNO addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else if (indexPath.row == 1)
    {
        EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if (cell == nil) {
           cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addLabel.text = @"下一步";
        cell.addLabel.textColor = [UIColor whiteColor];
        cell.addLabel.backgroundColor = TRZXWalletMainColor;
        return cell;
        
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)      return 112;
    else if (indexPath.row == 1) return 55;
    else if (indexPath.row == 2) return 30;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if (self.cardNoTF.text.length ==0) {
//            [LCProgressHUD showInfoMsg:@"银行卡号不能为空"];
            return;
        }else if (self.cardNoTF.text.length < 18) {
//            [LCProgressHUD showInfoMsg:@"请填写有效银行卡号"];
            return;
        }
        //提交后台验证
        [self getCardInfoIsAnd:YES];
        
    }

}

#pragma  mark - 文本改变的通知
- (void)textChanged:(UITextField *)textfield
{

    if ([textfield isEqual:self.bankNameTF]) {
        if (textfield.text.length <= 30) {
        } else {
            NSString *subText = [textfield.text substringToIndex:21-1];
            textfield.text = subText;
        }
    }
    if ([textfield isEqual:self.phoneTF]) {
        if (textfield.text.length <= 11) {
        } else {
            NSString *subText = [textfield.text substringToIndex:12-1];
            textfield.text = subText;
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    if ([textField isEqual:self.phoneTF]) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletNumbers] invertedSet];
    }else if ([textField isEqual:self.bankNameTF])
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletAlpha] invertedSet];
    }else if ([textField isEqual:self.nameTF])
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kWalletAlpha] invertedSet];
    }
    else if ([textField isEqual:self.cardNoTF])
    {
        NSString *text = [self.cardNoTF text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        // 限制长度
        if (newString.length >= 24) {
            return NO;
        }else if (newString.length == 23) {
            [self.cardNoTF setText:newString];
        }
        
        [self.cardNoTF setText:newString];
        
        return NO;
    }
    
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (void)getCardInfoIsAnd:(BOOL)isAnd
{
    NSString *str = [self.cardNoTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (oneceToken) {
        return ;
    }
    oneceToken = YES;
    [EOMyWalletViewModel checkCard:str success:^(id data) {
       
        oneceToken = NO;
        if (data) {
            EOBankModel *model = [EOBankModel mj_objectWithKeyValues:data];
            
            if ([model.validated boolValue] == true) {
                
                if ([model.repeated boolValue] == true) {
//                    [LCProgressHUD showInfoMsg:@"不能重复添加"];
                }else{
                    EOBankAouthViewController *aouth = [[EOBankAouthViewController alloc]init];
                    aouth.bankNumber = self.cardNoTF.text;
                    aouth.model = model;
                    [self.navigationController pushViewController:aouth animated:YES];
                }
            }else{
//                [LCProgressHUD showInfoMsg:@"请填写有效银行卡号"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
  
}

- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
