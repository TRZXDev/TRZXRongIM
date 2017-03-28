//
//  EOWalletViewController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletViewController.h"
//vc
#import "EOWalletBankCardViewController.h"
#import "EOWalletWithDrawViewController.h" //提现
#import "EOEditMyInfoViewController.h"  //修改支付密码
#import "EOForgetPayPasswordController.h"//忘记支付密码
#import "ChongzhiVC.h" //充值
#import "JiaoYiJiLuViewController.h" //账单详情
//vm/model
#import "EOWalletModel.h"
//view
#import "EOWalletHeaderView.h"
#import "EOWalletRecentlyCell.h"
#import "EOWalletNoteTableViewCell.h"
#import "EOSetTradeView.h"
#import "NewWalletLookDetailTableViewCell.h"
//third
#import "TRZXWalletMacro.h"


#define buttonTag 445



@interface EOWalletViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView          *tableView;
@property (nonatomic,strong) NSMutableArray       *dataSource;
@property (nonatomic,copy)   NSString             *amout;
@property (nonatomic,copy)   NSString             *firstPassword;
@property (nonatomic,copy)   NSString             *updateDate;
@property (nonatomic,copy)   EOSetTradeView       *payAlert1;
@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation EOWalletViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - viewLife
- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    if (_isRefersh) {
        [self initRequestOther];
    }
    [IQKeyboardManager sharedManager].enable = NO;
    //推送的刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initRequestOther) name:@"receiveUmengNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isRefersh = YES;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addUI];
    _isRefersh = NO;
    [self initRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initRequest) name:@"reloadDataWallet" object:nil];
}

- (void)alertPassword{
   
    _payAlert1 = [[EOSetTradeView alloc]init];
    _payAlert1.titleStr = @"请设置支付密码";
    [_payAlert1 show];
    __weak EOWalletViewController *weakSelf = self;
    _payAlert1.completeHandle = ^(NSString *inputPwd) {
        weakSelf.firstPassword = inputPwd;
        [weakSelf performSelector:@selector(alertAgain) withObject:nil afterDelay:0.4];
    };
    _payAlert1.exit = ^()
    {//退出
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };
}
- (void)alertAgain
{
    EOSetTradeView *payAlert = [[EOSetTradeView alloc]init];
    payAlert.titleStr = @"请确认支付密码";
    payAlert.firtPassword = self.firstPassword;
    [payAlert show];
    __weak EOWalletViewController *weakSelf = self;
    payAlert.completeHandle = ^(NSString *inputPwd) {
        
        if ([inputPwd integerValue]==0) { // 密码不一致
            [self alertPassword];
            _payAlert1.detailLabel.hidden = NO;
        }else{

            NSString *password = [NSString wallet_getMd5_32Bit_String:inputPwd isUppercase:NO];
            [EOMyWalletViewModel setPasswordWithPassword:password Success:^(id json) {
                NSDictionary *responseObj = json;
                if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
//                    [LCProgressHUD showSuccess:@"设置成功"];   // 显示成功

                }else{
//                    [LCProgressHUD showFailure:@"设置失败"];   // 显示失败
                }

            } failure:^(NSError *error) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];

        }
    };
    
    payAlert.exit = ^()
    {//退出
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}


- (void)addUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(0, 0, 83, 44);
    [btn setTitle:@"..."  forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 40.0];
    btn.titleEdgeInsets = UIEdgeInsetsMake(-10,0,11,-20);
    [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    self.rightBtn = btn;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    EOWalletHeaderView *headerView = [[TRZXWalletBundle loadNibNamed:@"EOWalletHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView = headerView;
    
    [headerView.accountDetailButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.withDrawButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.bankCardButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
}


//不弹密码框
- (void)initRequestOther{
    
    [self.dataSource removeAllObjects];
    [self isSet:NO];
}
- (void)initRequest
{
    [self.dataSource removeAllObjects];
    [self isSet:YES];
}

- (void)isSet:(BOOL)isSet{
 
    [EOMyWalletViewModel getWalletSuccess:^(id data) {
        
        BOOL notSet = (BOOL)data[@"notSet"];
        //88789
        EOWalletModel *walletModel = [EOWalletModel mj_objectWithKeyValues:data[@"wallet"]];
        
        EOWalletHeaderView *headerView = (EOWalletHeaderView *)self.tableView.tableHeaderView;
        //余额
        headerView.balanceLabel.text = [NSString stringWithFormat:@"%0.2f",walletModel.amount];
        
        self.amout = [NSString stringWithFormat:@"%0.2f",walletModel.amount];
        //年份
        self.updateDate = [data[@"wallet"] valueForKey:@"updateDate"]?[data[@"wallet"] valueForKey:@"updateDate"]:@"2016";
        
        if ([self.updateDate isKindOfClass:[NSString class]]) {
            if (self.updateDate.length > 5)
            {
                self.updateDate = [self.updateDate substringToIndex:4];
            }
        }
        
        //收入
        CGFloat totalAmount = data[@"totalAmount"]?[data[@"totalAmount"] floatValue]:0.00;
        
        headerView.incomeLabel.text = [NSString stringWithFormat:@"%0.2f",totalAmount];
        
        //提现
        CGFloat cashAmount = data[@"cashAmount"]?[data[@"cashAmount"] floatValue]:0.00;
        headerView.withDrawLabel.text = [NSString stringWithFormat:@"%0.2f",cashAmount];
        
        //充值
        CGFloat rechargeAmount = data[@"rechargeAmount"]?[data[@"rechargeAmount"] floatValue]:0.00;
        headerView.rechargeLabel.text = [NSString stringWithFormat:@"%0.2f",rechargeAmount];
        
        if (notSet && isSet) {
            [self alertPassword];
        }
        NSArray *array = [EOWalletRecordModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
        //只显示10条数据
        if (array.count > 10) {
            for (int i = 0; i < 10; i ++) {
                EOWalletRecordModel *model = array[i];
                [self.dataSource addObject:model];
            }
        }else
        {
            [self.dataSource addObjectsFromArray:array];
        }
        [self.tableView reloadData];
//        qianbaoBtn.enabled = YES;
        
    } failure:^(NSError *error) {
//        qianbaoBtn.enabled = YES;
    }];
}

#pragma mark - cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 8;
    if (self.dataSource.count == 0) return 2;
    return self.dataSource.count +2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EOWalletRecentlyCell *cell = [tableView dequeueReusableCellWithIdentifier:recentlyIdentifier];
        if (cell == nil) {
            cell = [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletNoteTableViewCell class]) owner:nil options:nil] lastObject];
        }
        if (self.dataSource.count != 0) {
            cell.updateDate = self.updateDate;
        }
        return cell;
    }
    if (self.dataSource.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none"];
        if (!cell ) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 60)];
        lable.text = @"暂无交易记录";
        lable.font = [UIFont systemFontOfSize:22];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = WalletBlackColor;
        [cell.contentView addSubview:lable];
        cell.contentView.backgroundColor = WalletbackColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == self.dataSource.count+1) {
        NewWalletLookDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[TRZXWalletBundle loadNibNamed:NSStringFromClass([NewWalletLookDetailTableViewCell class]) owner:self options:nil] firstObject];
        }
        [cell.lookButton addTarget:self action:@selector(noteDetail) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    EOWalletRecordModel *model = self.dataSource[indexPath.row - 1];
    EOWalletNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noteIdentifier];
    if (cell == nil) {
        cell = [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletNoteTableViewCell class]) owner:nil options:nil] firstObject];
    }
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)                        return 90;
    if (self.dataSource.count == 0)                return 300;
    if (indexPath.row == self.dataSource.count +1) return 30;
    return 66;
}

#pragma mark - eventHandle
- (void)noteDetail
{
    //账单详情
    JiaoYiJiLuViewController *noteDeatail = [[JiaoYiJiLuViewController alloc]init];
    [self.navigationController pushViewController:noteDeatail animated:YES];
}

- (void)buttonClick:(UIButton *)button
{
//        if ([NSObject showWalletCertificationTip:self]) {
//            return;
//        }

    NSInteger index = button.tag - buttonTag;
    switch (index) {
        case 0:
        {
                ChongzhiVC *chongzhiVC  = [[ChongzhiVC alloc] init];
                chongzhiVC.typeStr = @"chongzhi";
                [self.navigationController pushViewController:chongzhiVC animated:true];

        }
            break;
        case 1:
        {     //提现
                [self loadMyCardList];

        }
            break;
        case 2:
        {
                //银行卡
                EOWalletBankCardViewController *bankCard = [[EOWalletBankCardViewController alloc]init];
                bankCard.type = @"1";
                [self.navigationController pushViewController:bankCard animated:true];

        }
            break;
            
        default:
            break;
        }

}
/**
 *  获取我的银行卡
 */
- (void)loadMyCardList
{
    [EOMyWalletViewModel isHadCardSuccess:^(id json) {
        
        //提现
        NSDictionary *responseObj = json;
        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            NSArray *array = [EOBankModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            if (array.count == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未绑定银行卡" message:@"立刻前往进行绑定吧!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //                银行卡
                    EOWalletBankCardViewController *bankCard = [[EOWalletBankCardViewController alloc]init];
                    bankCard.type = @"1";
                    [self.navigationController pushViewController:bankCard animated:true];

                    
                }];
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else{
                //当日可提现额度
                NSString *residual = responseObj[@"residual"]?responseObj[@"residual"]:@"0";
                
                EOWalletWithDrawViewController *withDraw = [[EOWalletWithDrawViewController alloc]init];
                withDraw.residual = residual;
                withDraw.amout = self.amout;
                withDraw.bankModel = [array firstObject];
                [self.navigationController pushViewController:withDraw animated:true];

            }

        }else
        {
//            [LCProgressHUD showFailure:@"读取银行卡信息失败"];   // 显示失败
        }
        
    } failure:^(NSError *error) {
    }];
}


- (void)goBackView:(id)sender
{
    ///////取消网络请求
//    [self.arrayOfTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *taskObj, NSUInteger idx, BOOL *stop) {
//        [taskObj cancel];
//    }];
//    [self.arrayOfTasks removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}


/////////////修改支付密码 找回支付密码
- (void)saveBtnClick:(UIButton *)sender
{
    [self chooseUpdatePay];
}
- (void)chooseUpdatePay
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"修改支付密码" style:0 handler:^(UIAlertAction * _Nonnull action) {
        EOEditMyInfoViewController *infoVC= [[EOEditMyInfoViewController alloc]init];
        [self.navigationController pushViewController:infoVC animated:YES];
    }];
    UIAlertAction *forgetAction = [UIAlertAction actionWithTitle:@"找回支付密码" style:0 handler:^(UIAlertAction * _Nonnull action) {
        EOForgetPayPasswordController *Forget = [[EOForgetPayPasswordController alloc]init];
        [self.navigationController pushViewController:Forget animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:updateAction];
    [alertController addAction:forgetAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)dealloc{
  
}
#pragma mark - setter/getter------------------------------------------------------------------------
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = WalletbackColor;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
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
