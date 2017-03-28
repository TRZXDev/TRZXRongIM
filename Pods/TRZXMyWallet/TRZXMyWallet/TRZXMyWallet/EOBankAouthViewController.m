
//
//  EOBankAouthViewController.m
//  TRZX
//
//  Created by Rhino on 2016/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOBankAouthViewController.h"
#import "WalletPayProtocolViewController.h"
#import "EOAuothPhoneViewController.h"

#import "EOEditMyMsgTableViewCell.h"
#import "EOAddBankTypeCell.h"
#import "EOAgreeProTableViewCell.h"
#import "EOWalletModel.h"
#import "EOWalletAddCardTableViewCell.h"

//#import "RCDTextFieldValidate.h"
#import "TRZXWalletMacro.h"


#define kMaxPhoneLength 11


static  NSString *editlIdentifier = @"EOEditMyMsgTableViewCell";
static  NSString *addIdentifier =  @"EOWalletAddCardTableViewCell";
static  NSString *agreeIdentifier = @"EOAgreeProTableViewCell";
static  NSString *bankIdentifier = @"EOAddBankTypeCell";

@interface EOBankAouthViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong ) UITableView *tableView;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *bankNameLabel;

@end

@implementation EOBankAouthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createUI];
}

- (void)initData{
    
}

- (void)createUI{
    [self registerTitleLabe:@"填写银行卡信息"];
    [self.view addSubview:self.tableView];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOAddBankTypeCell" bundle:nil] forCellReuseIdentifier:bankIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOAgreeProTableViewCell" bundle:nil] forCellReuseIdentifier:agreeIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOEditMyMsgTableViewCell" bundle:nil] forCellReuseIdentifier:editlIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:addIdentifier];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        EOAddBankTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:bankIdentifier];
        if (cell == nil) {
           cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOAddBankTypeCell class]) owner:nil options:nil] firstObject];
        }
        cell.cardNO.delegate =self;
        cell.userNameTF.text = self.model.bankName;
        cell.nameTitleLable.text = @"卡类型";
        cell.numberTitleLabel.text = @"卡号";
        cell.userNameTF.enabled = NO;
//        @"D4241423424424";
        cell.cardNO.text = self.bankNumber;
        cell.userInteractionEnabled = NO;
        
        return cell;
    }else if (indexPath.row == 1){
        EOEditMyMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editlIdentifier];
        if (cell == nil) {
           cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOEditMyMsgTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.userNumberTF.delegate  = self;
        cell.bankPhoneTF.delegate = self;
        cell.name.delegate        = self;
        [cell.userNumberTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.bankPhoneTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.name  addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

        cell.userNumberTF.userInteractionEnabled = NO;
        cell.name.userInteractionEnabled = NO;
        cell.name.text = self.model.name;
        cell.userNumberTF.text = self.model.idCard;
        
        self.phoneTF = cell.bankPhoneTF;
        return cell;
            
    }else if (indexPath.row == 2){
        EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if (cell == nil) {
          cell=  [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addLabel.text = @"下一步";
        cell.addLabel.textColor = [UIColor whiteColor];
        cell.addLabel.backgroundColor = TRZXWalletMainColor;
        return cell;
        
    }else if (indexPath.row == 3){
        EOAgreeProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:agreeIdentifier];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOAgreeProTableViewCell class]) owner:nil options:nil] firstObject];
        }
        [cell.proButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)      return 112;
    else if (indexPath.row == 1) return  141;
    else if (indexPath.row == 2) return  55;
    else if (indexPath.row == 3) return 30;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (indexPath.row==2) {


        if (self.phoneTF.text.length==0) {

            NSString *message = @"手机号不能为空";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return ;

        }else if (self.phoneTF.text.length<11) {
            NSString *message = @"请填写有效手机号";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }else{
            EOAuothPhoneViewController *phoneVC = [[EOAuothPhoneViewController alloc]init];
            phoneVC.phoneNumber = self.phoneTF.text;
            phoneVC.bankNumber = self.bankNumber;
            [self.navigationController pushViewController:phoneVC animated:YES];
        }


        
    }    
}
//协议事件
-(void)btnClick:(id)sender{
    WalletPayProtocolViewController * xieyiVC = [[WalletPayProtocolViewController alloc]init];
    [self.navigationController pushViewController:xieyiVC animated:true];

}
#pragma  mark - 文本改变的通知
- (void)textChanged:(UITextField *)textfield
{

    NSString *toBeString = textfield.text;

    NSString *lang = [[textfield textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textfield markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString maxLength:kMaxPhoneLength];
            if(getStr && getStr.length > 0) {
                textfield.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString maxLength:kMaxPhoneLength];
        if(getStr && getStr.length > 0) {
            textfield.text= getStr;
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}

- (NSString *)getSubString:(NSString*)string maxLength:(NSInteger)maxLength
{
    if (string.length > maxLength) {
        //        [LCProgressHUD showInfoMsg:[NSString stringWithFormat:@"不能超过%zd字符",maxLength]];   // 显示等待
        return [string substringToIndex:maxLength];
    }
    return nil;
}


- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
