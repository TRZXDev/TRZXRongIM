//
//  ZhiFuMiMaController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/31.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ZhiFuMiMaController.h"
#import "PasswordEnterView.h"
#import "PasswordTextField.h"

//#import "ZhiFuChengGongVC.h"
//#import "PersonalModView.h"

#import "TRZXWalletMacro.h"

@interface ZhiFuMiMaController ()
@property (strong, nonatomic)PasswordTextField *textFieldOne;
@property (strong, nonatomic)UILabel *lable;
@property (copy, nonatomic)NSString *passwordStr;
@property (copy, nonatomic)NSString *zhanghuStr;

@property (copy, nonatomic)PasswordEnterView *enterView;
// 防止重复支付
@property (nonatomic, assign) BOOL payOnceToken;
@end

@implementation ZhiFuMiMaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerTitleLabe:@"支付密码"];
    [self createpasswordView];
}

-(void)goBackView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createpasswordView {
    _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 80,self.view.frame.size.width, 20)];
    _lable.text = @"请输入支付密码";
    
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = [UIFont systemFontOfSize:15];
    _lable.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_lable];
    _enterView = [[PasswordEnterView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 50) count:6 isCiphertext:YES textField:^(PasswordTextField *textField) {
        [textField becomeFirstResponder];
        _textFieldOne = textField;
    }];
    
    __weak __typeof(self)weakSelf = self;
    _enterView.textDetail = ^(NSString *textDetail){
        if (textDetail.length == 6) {
            
            _passwordStr = [NSString wallet_getMd5_32Bit_String:textDetail isUppercase:NO];
            if ([weakSelf.typeStr isEqualToString:@"tixian"]) {
                [weakSelf request_api];
            } else if ([weakSelf.typeStr isEqualToString:@"zhifu"]) {
                [weakSelf request_ZhiFuApi];
            }
        }
    };
    _enterView.backgroundColor = WalletbackColor;
    [self.view addSubview:_enterView];
    
}

- (void)request_api {

//    [PersonalModView getQianbaotixianAmount:self.money payPassword:_passwordStr Success:^(id object) {
//        
//        if ([object[@"status_code"] isEqualToString:@"200"]) {
//            
//            ZhiFuChengGongVC *cGVc = [[ZhiFuChengGongVC alloc] init];
//            cGVc.money = self.money;
//            cGVc.icmImage = self.icmImage;
//            cGVc.typeMe = @"tixian";
//            cGVc.zhiFuMiMaVC = self;
//            [self.navigationController pushViewController:cGVc animated:YES];
//        }else{
//            [LCProgressHUD showFailure:[object objectForKey:@"status_dec"]];   // 显示失败
//        }
//    } failure:^(NSError *error) {
//    }];


}

- (void)request_ZhiFuApi {
    
    if (self.payOnceToken) {
        return;
    }
    self.payOnceToken = YES;
//    [PersonalModView getQianbaozhifuAmount:self.money payPassword:_passwordStr meetId:self.mid Success:^(id object) {
//        if ([object[@"status_code"] isEqualToString:@"200"]) {
//            
//            ZhiFuChengGongVC *cGVc = [[ZhiFuChengGongVC alloc] init];
//            cGVc.mid = self.mid;
//            cGVc.money = self.money;
//            cGVc.typeMe = @"zhifu";
//            
//            [self.navigationController pushViewController:cGVc animated:YES];
//        }else{
//            self.payOnceToken = NO;
//            [_enterView clearPassword];
//
//            [LCProgressHUD showFailure:[object objectForKey:@"status_dec"]];   // 显示失败
//        }
//    } failure:^(NSError *error) {
//    }];
//    

    
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
