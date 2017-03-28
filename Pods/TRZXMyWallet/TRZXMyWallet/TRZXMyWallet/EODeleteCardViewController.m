//
//  EODeleteCardViewController.m
//  TRZX
//
//  Created by Rhino on 2016/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "EODeleteCardViewController.h"
#import "EOWalletBankCardTableViewCell.h"
#import "EOWalletModel.h"
#import "EOMyWalletViewModel.h"
#import "EOWalletBankCardViewController.h"

#import "TRZXWalletMacro.h"

static  NSString *bankIdentifier = @"EOWalletBankCardTableViewCell";

static  NSString *chooseIdentifier = @"EOChooseBankTableViewCell";
static  NSString *normalIdentifier = @"cell";

@interface EODeleteCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>


@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic,strong ) UITableView      *tableView;
@property (nonatomic, strong) NSArray          *bankArray;

@property (nonatomic,strong)NSIndexPath *indexpath;
@property (nonatomic, strong) UIButton *qianbaoBtn;


@end

@implementation EODeleteCardViewController

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
    self.navigationController.navigationBarHidden = YES;
    [self.dataSource addObject:_model];
    [self createUI];
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

        if (array.count>0) {
            self.qianbaoBtn.hidden = NO;
        }else{
            self.qianbaoBtn.hidden = YES;
        }
        [self.dataSource addObjectsFromArray:array];
        [self.tableView reloadData];

    } failure:^(NSError * error) {
    }];
}

- (void)createUI
{

    [self registerTitleLabe:@"我的银行卡"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn setTitle:@"👛"  forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    self.qianbaoBtn = btn;
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    
//        navigationView1.backgroundColor = [UIColor whiteColor];
//        logintTitleLabel.textColor = WalletBlackColor;
//        [self.tableView registerNib:[UINib nibWithNibName:@"EOWalletBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:bankIdentifier];
        [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EOWalletBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankIdentifier];
    if (cell == nil) {
       cell = [[TRZXWalletBundle loadNibNamed:NSStringFromClass([EOWalletBankCardTableViewCell class]) owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EOBankModel *model =  self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


//跳转列表
-(void)saveAction{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
    sheet.tag = 2000;
    [sheet showInView:self.view];
#pragma clang diagnostic pop

}




#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
#pragma clang diagnostic pop
    if (buttonIndex == 0) {
        [self deleteCardWithIndex:self.indexpath.row];
    } else if (buttonIndex == 1) {
        
    }
}

//解除绑定
- (void)deleteCardWithIndex:(NSInteger)index
{
    
        EOBankModel *model  = self.dataSource[index];
    
        [EOMyWalletViewModel postWallet_deleteCardId:model.mid Success:^(id json) {
    
            NSDictionary *responseObj = json;
    
            if ([responseObj[@"status_code"] isEqualToString:@"200"]) {

                self.qianbaoBtn.hidden = YES;
                [self.dataSource removeObjectAtIndex:index];
                [self.tableView reloadData];
                [self popViewController];
            }
    
        } failure:^(NSError *error) {
        }];
}


- (void)popViewController
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[EOWalletBankCardViewController class]]){

            EOWalletBankCardViewController * csController = (EOWalletBankCardViewController*)vc;
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
        _tableView.rowHeight = 85;
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


@end
