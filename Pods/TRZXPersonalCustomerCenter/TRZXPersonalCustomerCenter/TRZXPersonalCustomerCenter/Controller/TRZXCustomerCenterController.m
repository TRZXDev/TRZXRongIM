//
//  TRZXCustomerCenterController.m
//  TRZXPersonalCustomerCenter
//
//  Created by 张江威 on 2017/2/24.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXCustomerCenterController.h"
#import "zhinanCell.h"

#import "GuanYuWoMenVC.h"
#import "ZhiNanBangZhuCellVC.h"
#import "CTMediator+TRZXComplaint.h"
//#import <CTMediator/CTMediator+TRZXComplaint.h>

/** 主题颜色 */
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXCustomerCenterController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSArray *dataArr;

@property (strong, nonatomic)UIButton *backBtn;;

@property (nonatomic, strong) NSString *appKey;
/// 自定义反馈界面配置，在创建反馈界面前设置
@property (nonatomic, strong, readwrite) NSDictionary *customPlist;
@property (nonatomic,strong)NSNumber *count;

@end

@implementation TRZXCustomerCenterController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服中心";
    [self createUI];

}
- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = backColor;
    [self.view addSubview:_tableView];
    _dataArr = @[@"关于我们",@"使用帮助",@"投诉",@"客服电话"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    
}

#pragma mark - UITableViewDeleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2||indexPath.row == 3) {
        return 55;
    }else{
        return 45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zhinanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhinanCell"];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"zhinanCell" owner:self options:nil] firstObject];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label1.text = _dataArr[indexPath.row];
    if ([_dataArr[indexPath.row] isEqualToString:@"客服电话"]) {
        cell.label1.font = [UIFont boldSystemFontOfSize:17];
    }else{
        cell.label1.font = [UIFont systemFontOfSize:15];
    }
    cell.backgroundColor = backColor;
    
    return cell;
}
#pragma mark -cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        GuanYuWoMenVC * guanyuwomen = [[GuanYuWoMenVC alloc] init];
        guanyuwomen.panduanStr = @"guanyu";
        [self.navigationController pushViewController:guanyuwomen animated:YES];
    }
    if (indexPath.row == 1){
        ZhiNanBangZhuCellVC * bangzhu = [[ZhiNanBangZhuCellVC alloc] init];
        [self.navigationController pushViewController:bangzhu animated:YES];
    }
    if (indexPath.row == 2){
//        [params[@"type"] integerValue];
//        complaints.targetId = params[@"targetId"];
//        complaints.userTitle = params[@"userTitle"];
        UIViewController * vc = [[CTMediator sharedInstance]TRZXComplaint_TRZXComplaintViewController:@{@"type":@"1",@"targetId":@" ",@"userTitle":@" "}];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.row == 3){
        
        
        [self openScheme:@"tel://4006781693"];
       
    }
}


- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBackView:(UIButton *)sender{
    
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)actionCleanMemory:(id)sender
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end

