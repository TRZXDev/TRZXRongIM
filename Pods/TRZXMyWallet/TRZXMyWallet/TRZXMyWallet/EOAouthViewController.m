//
//  EOAouthViewController.m
//  TRZX
//
//  Created by Rhino on 2016/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOAouthViewController.h"
#import "EODeleteCardViewController.h"

#import "EOPasswordView.h"
#import "TRZXWalletMacro.h"

@interface EOAouthViewController ()

@property (strong, nonatomic)EOPasswordView *textFieldOne;

@property (strong, nonatomic)UILabel *lable;
@property (strong, nonatomic)UILabel *pasErrorLabel;
@property (copy, nonatomic)NSString *passwordStr;
@property (copy, nonatomic)NSString *passwordStr2;

@end

@implementation EOAouthViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[EOAouthViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerTitleLabe:@"安全验证"];
//    [self NoImagebackButtonNoImage];
    self.navigationController.navigationBarHidden = YES;
    [self createpasswordView];
}

- (void)createpasswordView {
    
    _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 20)];
    _lable.text = @"请输入支付密码,以验证身份";

    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = [UIFont systemFontOfSize:15];
    _lable.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_lable];
    
    self.textFieldOne = [[EOPasswordView alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width - 40, 50)];
    _pasErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.textFieldOne.frame.origin.y+self.textFieldOne.frame.size.height+5, self.view.frame.size.width, 20)];
    _pasErrorLabel.text = @"支付密码错误,请重新输入";
    _pasErrorLabel.hidden = YES;
    _pasErrorLabel.font = [UIFont systemFontOfSize:12];
    _pasErrorLabel.textColor = TRZXWalletMainColor;
    [self.view addSubview:_pasErrorLabel];

    __weak __typeof(self)weakSelf = self;
    self.textFieldOne.PasswordCompeleteBlock = ^(NSString *password){
        [weakSelf request_api:password];
    };
    [self.view addSubview:self.textFieldOne];
}

- (void)request_api:(NSString *)password {
//    [LCProgressHUD showLoading:@"正在加载"];   // 显示等待

    NSString *pwd = [NSString wallet_getMd5_32Bit_String:password isUppercase:NO];
    [EOMyWalletViewModel checkCardPassword:pwd success:^(id data) {
        
//         [LCProgressHUD hide];
        EODeleteCardViewController *delete = [[EODeleteCardViewController alloc]init];
        delete.model = _model;
        [self.navigationController pushViewController:delete animated:YES];
        _pasErrorLabel.hidden = YES;
        
    } failure:^(NSError *error) {
//         [LCProgressHUD hide];
        _pasErrorLabel.hidden = NO;
        [self.textFieldOne clearPassword];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
