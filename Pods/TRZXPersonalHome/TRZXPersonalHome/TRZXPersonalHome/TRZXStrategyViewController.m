//
//  TRZXStrategyViewController.m
//  TRZXPersonalHome
//
//  Created by 张江威 on 2017/3/10.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXStrategyViewController.h"
#import "xihuanTableViewCell.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXStrategyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView * tableVieew;

@end

@implementation TRZXStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投融攻略";
    [self createUI];
    
}
- (void)createUI{
    _tableVieew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height))];
    _tableVieew.separatorStyle = NO;
    _tableVieew.delegate = self;
    _tableVieew.dataSource = self;
    _tableVieew.backgroundColor = backColor;
    
    [self.view addSubview:_tableVieew];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.frame.size.width*4067)/375;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    xihuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xihuanTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"xihuanTableViewCell" owner:self options:nil] lastObject];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xihuanView.backgroundColor = backColor;
    UIImageView * images = [[UIImageView alloc]init];
    images.image = [UIImage imageNamed:@"投融攻略.png"];
    images.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width*4067)/375);
    [cell.xihuanView addSubview:images];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

