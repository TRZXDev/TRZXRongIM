//
//  TRZXPersonalProfileViewController.m
//  TRZXPersonalProfile
//
//  Created by Rhino on 2017/3/1.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "TRZXPersonalProfileViewController.h"
#import "TRZXPersonalWorkCell.h"
#import "TRZXPersonalProfileCell.h"
#import "TRZXPersonalExperCell.h"

#define PersonalProfilrColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define PPPhotoBrowserBundle [NSBundle bundleForClass:[self class]]


@interface TRZXPersonalProfileViewController ()<UITableViewDataSource,UITableViewDelegate>{
    CGSize size;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TRZXPersonalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUI];
}

- (void)addUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.userType isEqualToString:@"TradingCenter"]) {//交易中心
        self.title = @"交易中心的简介";
    }else if ([self.userType isEqualToString:@"Gov"]) {//政府
        self.title = @"政府的简介";
    }else{
        self.title = @"个人简介";
    }
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        if ([self.userType isEqualToString:@"TradingCenter"]||[self.userType isEqualToString:@"Gov"]) {//交易中心，政府
            return 0;
        }else{
            return 1+ _workArray.count;
        }
    }else if (section == 2){
        if ([self.userType isEqualToString:@"TradingCenter"]||[self.userType isEqualToString:@"Gov"]) {//交易中心，政府
            return 0;
        }else{
            return 1+_eduArray.count;
        }
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 105;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 105;
        }
    }else{
        if (self.abstractz.length == 0) {
            return 53;
        }else{
            return 80 + size.height;
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        TRZXPersonalProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXPersonalProfileCell"];
        if (!cell) {
            cell = [[PPPhotoBrowserBundle loadNibNamed:@"TRZXPersonalProfileCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([self.userType isEqualToString:@"Brokerage"]) {//券商
            cell.titleLabel.text = @"券商简介";
        }else if ([self.userType isEqualToString:@"TradingCenter"]) {//交易中心
            cell.titleLabel.text = @"交易中心简介";
        }else if ([self.userType isEqualToString:@"Gov"]) {//政府
            cell.titleLabel.text = @"政府简介";
        }else{
            cell.titleLabel.text = @"个人简介";
        }
        cell.jianjieLabel.text = self.abstractz;
        size = [cell.jianjieLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-30, MAXFLOAT)];
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0){
            TRZXPersonalExperCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXPersonalExperCell"];
            if (!cell) {
                cell = [[PPPhotoBrowserBundle loadNibNamed:@"TRZXPersonalExperCell" owner:self options:nil] lastObject];
            }
            cell.jingliLabel.text = @"工作经历";
            cell.jingliImage.image = [UIImage imageNamed:@"personalWork"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = PersonalProfilrColor;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return cell;
        }else{
            TRZXProfileUserModel *mode = [_workArray objectAtIndex:indexPath.row-1];
            TRZXPersonalWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXPersonalWorkCell"];
            if (!cell) {
                cell = [[PPPhotoBrowserBundle loadNibNamed:@"TRZXPersonalWorkCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.backgroundColor = PersonalProfilrColor;
            if (indexPath.row == 1){
                cell.yincangLabel.hidden = YES;
            }
            cell.dataLabel.text = [NSString stringWithFormat:@"%@-%@",mode.startDate,mode.endDate];
            cell.nameLabel.text = mode.company;
            cell.xueliLabel.text = mode.position;
            
            return cell;
        }
    }else{
        if (indexPath.row == 0){
            
            TRZXPersonalExperCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXPersonalExperCell"];
            if (!cell) {
                cell = [[PPPhotoBrowserBundle loadNibNamed:@"TRZXPersonalExperCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.jingliImage.image = [UIImage imageNamed:@"personalEdu"];
            cell.jingliLabel.text = @"教育经历";
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }else{
            TRZXProfileUserModel *mode = [_eduArray objectAtIndex:indexPath.row-1];
            TRZXPersonalWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXPersonalWorkCell"];
            if (!cell) {
                cell = [[PPPhotoBrowserBundle loadNibNamed:@"TRZXPersonalWorkCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            if (indexPath.row == 1){
                cell.yincangLabel.hidden = YES;
            }
            cell.dataLabel.text = [NSString stringWithFormat:@"%@-%@",mode.startDate,mode.endDate];
            cell.nameLabel.text = mode.school;
            cell.zhiweiLabel.text = mode.education;
            cell.xueliLabel.text = mode.major;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.height)- 64)];
        _tableView.separatorStyle = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PersonalProfilrColor;
    }
    return _tableView;
}


@end
