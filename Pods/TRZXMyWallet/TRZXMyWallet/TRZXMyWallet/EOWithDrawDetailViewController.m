//
//  EOWithDrawDetailViewController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWithDrawDetailViewController.h"
#import "EOWithDrawDetailCell.h"
#import "EOWalletAddCardTableViewCell.h"
#import "EOWalletModel.h"
#import "EOWalletViewController.h"
#import "DCPaymentView.h"

#import "TRZXWalletMacro.h"

static  NSString *deatilIdentifier = @"EOWithDrawDetailCell";
static  NSString *addIdentifier = @"EOWalletAddCardTableViewCell";

@interface EOWithDrawDetailViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic,strong ) UITableView *tableView;


@end

@implementation EOWithDrawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}



- (void)createUI
{
    [self registerTitleLabe:@"提现详情"];
//    navigationView1.backgroundColor = TRZXWalletMainColor;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EOWithDrawDetailCell" bundle:nil] forCellReuseIdentifier:deatilIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:addIdentifier];
//    logintTitleLabel.textColor = [UIColor whiteColor];
//    [self NoImagebackButtonNoImage];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EOWithDrawDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:deatilIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWithDrawDetailCell class]) owner:nil options:nil] firstObject];
        }
        cell.countLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.money floatValue]] ;
        cell.bankNumber.text =  self.bankNumber;
        return cell;
    }else if (indexPath.row == 1)
    {
        EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.addLabel.text = @"完成";
        cell.addLabel.textColor = [UIColor whiteColor];
        cell.addLabel.backgroundColor = TRZXWalletMainColor;
        return cell;
        
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 291;
    }
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {

        [self popViewController];
    }
}

- (void)goBackReload:(UIButton *)btn
{
    [self popViewController];
}

- (void)goBackView:(id)sender
{
    
    [self popViewController];
}

- (void)popViewController
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[EOWalletViewController class]]){
            EOWalletViewController * csController = (EOWalletViewController*)vc;
            [self.navigationController popToViewController:csController animated:YES];
            return;
        }
    }
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
