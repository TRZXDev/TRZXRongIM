//
//  ChongzhiVC.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/29.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ChongzhiVC.h"
//#import "UPPaymentControl.h"
#import "ZhiFuMiMaController.h"
//#import "payTool.h"

//***
//#import "WXApi.h"
//#import "WXApiObject.h"
//***
#import <CommonCrypto/CommonDigest.h>

#import "TRZXWalletMacro.h"


@interface ChongzhiVC ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSString *tnMode;
@property (nonatomic,strong) NSString *orderNumber;
@property(nonatomic,strong)UIView *alertView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation ChongzhiVC
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //测试环境  上线时，请改为“00”
    _tnMode = @"01";


    _nextButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
    _nextButton.userInteractionEnabled = NO;
    
    self.view.backgroundColor = WalletbackColor;
    if ([self.typeStr isEqualToString:@"chongzhi"]) {
        [self registerTitleLabe:@"充值"];
        [self.bankView removeFromSuperview];
        [self.moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(97);
        }];
    } else if ([self.typeStr isEqualToString:@"tixian"]) {
        
//       临时:把他注销 选择 银行的cell 显示
        [self.bankView removeFromSuperview];
        [self.moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(97);
        }];
        
        
        [self registerTitleLabe:@"提现"];
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
        _textQB.placeholder = @"请输入提现金额";
    }
    
    _textQB.delegate = self;

    [_textQB addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popNavSelf) name:removeChongZhiVC object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayWechatSuccessDelaySelf) name:PayWechatSuccess object:nil];
//    

    
}
//设置输入的范围只能是数字 ，考虑粘贴的情况
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{


    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,6}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
        _nextButton.backgroundColor = TRZXWalletMainColor;
        _nextButton.userInteractionEnabled = YES;
        
    }else{
        _nextButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
        _nextButton.userInteractionEnabled = NO;
    }

    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
//    CGFloat a = [str floatValue];
//    if (a > 999999999) {
//        return NO;
//    }
    if(str.length > 10 || [str floatValue] > 10000000){
        return NO;
    }

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
    if ([textfield isEqual:self.textQB]) {

        if ([self.textQB.text floatValue]<=0) {
            _nextButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:0.5];
            _nextButton.userInteractionEnabled = NO;
        }
        else
        {
            self.nextButton.backgroundColor = TRZXWalletMainColor;
            self.nextButton.enabled = YES;
        }
    }

}


-(void)PayWechatSuccessDelaySelf{
    
//    [[payTool instanceMethod] disappearView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadDataWallet" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self popViewController];
    });
}

-(void)popNavSelf{

    [self popViewController];

    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)request_Api {
//    if (_textQB.text.length == 0) {
//        [LCProgressHUD showInfoMsg:@"输入金额不能为空"];
//    } else {
//        ZhiFuMiMaController *zhifuMM = [[ZhiFuMiMaController alloc] init];
//        zhifuMM.money = _textQB.text;
//        zhifuMM.typeStr = @"tixian";
//        [self.navigationController pushViewController:zhifuMM animated:YES];
//    }

}
#pragma mark - 请求订单流水号
- (void)requestOrderNumber {
//    if (_textQB.text.length == 0) {
//        [LCProgressHUD showInfoMsg:@"输入金额不能为空"];
//    } else {
//        
//        //        开始银联支付
//        [EOMyWalletViewModel rechargeableAccount:_textQB.text Success:^(id responseObj) {
//            if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]){
//                _orderNumber = [responseObj objectForKey:@"tn"];
//                if (_orderNumber.length>0) {
//                    [self startUPPayPlugin:[responseObj objectForKey:@"tn"]];
//                }
//            }
//        } failure:^(NSError *error) {
//        }];
//    }
}









#pragma mark 开始银联支付

-(void)startUPPayPlugin:(NSString*)orderNumber{


//    BOOL isPay = [[UPPaymentControl defaultControl] startPay:orderNumber fromScheme:@"UPPayDemo" mode:self.tnMode viewController:self];
//
//    if (isPay){
//
//
//
//    }else{
//
//
//        
//    }





}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadDataWallet" object:nil];
    if ([result isEqualToString:@"msgcancel"]) {



    }
    else if([result containsString:@"success"]){



        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

#pragma mark - 通知后台

- (void)requestUniuonPayNotice:(NSString*)respCode orderNumber:(NSString*)orderNumber
{
    

    
//    NSString *stringURL = [NSString stringWithFormat:@"%@&equipment=ios&requestType=%@",[KipoServerConfig serverURL],@"AppPay_Api"];
//    
//    NSDictionary *dict = @{@"apiType":@"rechargeNotice",@"respCode":respCode,@"tn":orderNumber};
//    
//    
//    
//    [KipoNetworking post:stringURL params:dict success:^(id responseObj) {
//        
//
//
//        
//        if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]){
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//    } failure:^(NSError *error) {
//
//    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

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

- (IBAction)nextBtn:(id)sender {
    
//
//    if ([self.typeStr isEqualToString:@"chongzhi"]) {
//        
//       if (_textQB.text.doubleValue ==0) {
//            [LCProgressHUD showInfoMsg:@"充值金额不得为0"];
//            return;
//        }
//        [payTool payWithController:self andPayMoney:_textQB.text andTypeStr:payTypeChongzhi];
//
//    }
    
}


- (void)goBackReload:(UIButton *)btn
{
    [self popViewController];

}


-(void)popViewController{

    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}



@end
