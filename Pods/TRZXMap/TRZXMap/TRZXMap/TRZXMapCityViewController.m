//
//  TRMapZoneViewController.m
//  TRZX
//
//  Created by Rhino on 2016/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXMapCityViewController.h"
#import "TRZXMapCityViewModel.h"
@interface TRZXMapCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *titles;

@property (nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic) TRZXMapCityViewModel *mapCityViewModel;


@end

@implementation TRZXMapCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市选择";

    _titles = [[NSMutableArray array] init];

    [self.view addSubview:self.tableView];

    [self requestSignal_toAll];
}



// 发起请求
- (void)requestSignal_toAll {


    [self.mapCityViewModel.requestSignal_toAll subscribeNext:^(id x) {
        // 请求完成后，更新UI
        for (NSArray* arrays in self.mapCityViewModel.list) {
            NSDictionary *dic = arrays[0];
            NSString *name = [self firstCharactor:dic[@"name"]];
            [_titles addObject:name];
        }

        [self.tableView reloadData];

    } error:^(NSError *error) {
        // 如果请求失败，则根据error做出相应提示
        
    }];
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.mapCityViewModel.list.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *cities = self.mapCityViewModel.list[section];
    return cities.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSArray *cities = self.mapCityViewModel.list[indexPath.section];
    NSDictionary *dic = cities[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    NSArray *cities = self.mapCityViewModel.list[indexPath.section];
    NSDictionary *dic = cities[indexPath.row];
    if (self.cityCallback) {
        self.cityCallback(dic);
    }
    [self.navigationController popViewControllerAnimated:true];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return _titles[section];
}


//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{


    return _titles;
}

#pragma mark 索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //点击索引，列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}


#pragma mark- setter/geter


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexBackgroundColor=[UIColor clearColor];
        _tableView.sectionIndexColor = [UIColor blackColor];
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}



- (TRZXMapCityViewModel *)mapCityViewModel {

    if (!_mapCityViewModel) {
        _mapCityViewModel = [TRZXMapCityViewModel new];
    }
    return _mapCityViewModel;
}

@end
