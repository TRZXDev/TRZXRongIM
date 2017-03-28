//
//  EOWalletBankCardViewController.m
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EOWalletBankCardViewController.h"
#import "EOAddBankMsgViewController.h"
#import "EOAouthViewController.h"

#import "EOWalletBankCardTableViewCell.h"
#import "EOWalletAddCardTableViewCell.h"
#import "PickerChoiceView.h"
#import "EOChooseBankTableViewCell.h"

#import "EOWalletModel.h"
#import "TRZXWalletMacro.h"


static  NSString *bankIdentifier = @"EOWalletBankCardTableViewCell";
static  NSString *addIdentifier = @"EOWalletAddCardTableViewCell";
static  NSString *chooseIdentifier = @"EOChooseBankTableViewCell";
static  NSString *normalIdentifier = @"cell";

@interface EOWalletBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate,UIActionSheetDelegate>


@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic,strong ) UITableView      *tableView;
@property (nonatomic,strong ) PickerChoiceView *pickerView;
@property (nonatomic, strong) NSArray          *bankArray;

@property (nonatomic,strong)NSIndexPath *indexpath;


@end

@implementation EOWalletBankCardViewController
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
    
//    if ([self.type isEqualToString:@"1"]) {
//        [self loadBankList];
//    }
    
    [self loadMyCardList];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarType?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self initData];
    
//    [self loadMyCardList];
    
    [self createUI];
}

- (void)initData
{
//   self.dataSource = @[@"",@"",@"",@"",@"",@""].mutableCopy;
}
/**
 *  获取我的银行卡
 */
- (void)loadMyCardList
{

    [EOMyWalletViewModel isHadCardSuccess:^(id json) {
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        NSDictionary *responseObj = json;
        NSArray *array = [EOBankModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        [self.dataSource addObjectsFromArray:array];
        [self.tableView reloadData];
//        responseObj[@"sessionUserTypeStr"];
        
    } failure:^(NSError * error) {
       //  [NSObject showError:error];
    }];
}

- (void)createUI
{
    if ([self.type isEqualToString:@"1"]) {
        [self registerTitleLabe:@"银行卡"];
//         navigationView1.backgroundColor = TRZXWalletMainColor;
//        [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:bankIdentifier];
//        [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletAddCardTableViewCell" bundle:nil] forCellReuseIdentifier:addIdentifier];
//        logintTitleLabel.textColor = [UIColor whiteColor];
//        [self NoImagebackButtonNoImage];
    }else
    {
         [self registerTitleLabe:@"选择银行卡"];
         [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:normalIdentifier];
//         [self.tableView registerNib:[UINib nibWithNibName:@"EOChooseBankTableViewCell" bundle:nil] forCellReuseIdentifier:chooseIdentifier];
    }
   
   
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count] +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"1"]) {
        if (indexPath.row == self.dataSource.count) {
            EOWalletAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
            if (cell == nil) {
                cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletAddCardTableViewCell class]) owner:nil options:nil] firstObject];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        EOWalletBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletBankCardTableViewCell class]) owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        EOBankModel *model =  self.dataSource[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @" 到账银行";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = WalletzideColor;
        cell.textLabel.backgroundColor = WalletbackColor;
        cell.contentView.backgroundColor = WalletbackColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    EOChooseBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseIdentifier];
    if (cell == nil) {
        cell= [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOChooseBankTableViewCell class]) owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    EOBankModel *model =  self.dataSource[indexPath.row-1];
    cell.model = model;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"1"]) {
        return 85;
    }else
    {
        if (indexPath.row == 0) {
            return 35;
        }
        return 55;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.type isEqualToString:@"1"]) {

        if (indexPath.row == self.dataSource.count) {
            //添加银行卡
            EOAddBankMsgViewController *add = [[EOAddBankMsgViewController alloc]init];
            [self.navigationController pushViewController:add animated:YES];
            
            return;
        }else
        {

            EOBankModel *model = self.dataSource[indexPath.row];
            EOAouthViewController *update  = [[EOAouthViewController alloc]init];
            update.model = model;
            [self.navigationController pushViewController:update animated:YES];
        }
        
    }else
    {
        if (indexPath.row != 0) {
            
            EOBankModel *model = self.dataSource[indexPath.row-1];
            if (self.bankCallBack) {
                self.bankCallBack(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}


//#pragma mark  -- 解绑================
//- (void)chooseUpdatePayIndex:(NSIndexPath *)indexPath
//{
//    self.indexpath = indexPath;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除绑定", nil];
//    sheet.tag = 2000;
//    [sheet showInView:self.view];
//#pragma clang diagnostic pop
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIActionSheet
//    
//    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"" style:0 handler:^(UIAlertAction * _Nonnull action) {
//        [self deleteCardWithIndex:indexPath.row];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alertController addAction:updateAction];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
//}
//
//#pragma mark - UIActionSheetDelegate
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    
//#pragma clang diagnostic pop
//    if (buttonIndex == 0) {
//       [self deleteCardWithIndex:self.indexpath.row];
//    } else if (buttonIndex == 1) {
//        
//    }
//}

//解除绑定
//- (void)deleteCardWithIndex:(NSInteger)index
//{
//    
//
//    
//    EOBankModel *model  = self.dataSource[index];
//    [EOMyWalletViewModel postWallet_deleteCardId:model.mid Success:^(id json) {
//        
//        NSDictionary *responseObj = json;
//
//        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
//            
//            [LCProgressHUD showInfoMsg:@"解绑成功"];
//            [self.dataSource removeObjectAtIndex:index];
//            [self.tableView reloadData];
//        }
//        else
//        {
//            [LCProgressHUD showInfoMsg:@"解绑失败"];
//        }
//
//    } failure:^(NSError *error) {
//        [NSObject showError:error];
//    }];
//}


- (void)goBackView:(id)sender{
    
    [self popViewController];
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
//        _tableView.rowHeight = 85;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
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
