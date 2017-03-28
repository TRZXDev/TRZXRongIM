//
//  ComplaintsViewController.m
//  tourongzhuanjia
//
//  Created by Rhino on 16/5/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "TRZXComplaintsViewController.h"
#import "TRZXComplaintsMsgViewController.h"
#import "TRZXComplaintCell.h"
#import "UIImage+Com_Load.h"

@interface TRZXComplaintsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic,assign)NSUInteger index;

@property (nonatomic, strong)UIImageView *tickImageView;

@end

@implementation TRZXComplaintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNaviBar];
    [self createUI];
}

- (void)initData
{
    self.dataSource = @[@"色情",@"赌博",@"敏感信息",@"欺诈",@"违法"];
}
- (void)setNaviBar{
    self.title = @"投诉";
//    [self.mainTitle setTextColor:grayKColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(0, 0, 80, 44);
    [btn setTitle:@"下一步"  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
}

-(void)rightBarItemAction:(UIButton *)button{
    
    if(!_tickImageView){
//        [LCProgressHUD showMessage:@"请选择投诉原因"];
        return ;
    }
    
    TRZXComplaintsMsgViewController *compVc =[[TRZXComplaintsMsgViewController alloc]init];
    compVc.type = self.type;
    compVc.targetId =self.targetId;
    compVc.subType = self.dataSource[self.index];
    compVc.userTitle = self.userTitle;
    [self.navigationController pushViewController:compVc animated:YES];
}

- (void)createUI
{
    [self.view addSubview:self.tableView];
    UIView *headerView             = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UILabel *lable                 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 24)];
    lable.text                     = @"请选择投诉原因";
    lable.font                     = [UIFont systemFontOfSize:14];
    lable.textColor                = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [headerView addSubview:lable];
    self.tableView.tableHeaderView = headerView;

}

#pragma mark - cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXComplaintCell"];
    if (!cell) {
        
        cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"TRZXComplaintCell" owner:self options:nil] firstObject];
//        cell =[[[NSBundle mainBundle] loadNibNamed:@"TRZXComplaintCell" owner:self options:nil]lastObject];
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label1.font = [UIFont systemFontOfSize:15];
    cell.label1.text = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    cell.yzImage.hidden = YES;
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TRZXComplaintCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.index = indexPath.row;
    [cell addSubview:self.tickImageView];
    
}

#pragma mark - setter/getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
    }
    return _tableView;
}

-(UIImageView *)tickImageView{
    if (!_tickImageView) {
        _tickImageView = [[UIImageView alloc]initWithImage:[UIImage loadImage:@"TRZXComplaints_Selected" class:[self class]]];
        _tickImageView.frame = CGRectMake(self.view.bounds.size.width - 30, 15, 15, 15);
    }
    return _tickImageView;
}

@end
