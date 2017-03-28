//
//  TRZXCollectionViewController.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/10/26.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "TRZXCollectionViewController.h"
#import "ZaixianerjiyedeCell.h"
#import "TRZXYdyTableViewCell.h"
#import "TRZXPOneToOneListCell.h"
#import "TRZXPInvestSeeCell.h"
#import "ShoucangModel.h"
#import "SCViewTableViewCell.h"
#import "TRZXPShareDeleViewController.h"
#import "TRPCollectionProjectTableViewCell.h"

#import "MJRefresh.h"
#import "TRZXNetwork.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define HEIGTH(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]

@interface TRZXCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *CollectionTableView;

@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;
@property (strong, nonatomic) UILabel * noLabelView;
@property (strong, nonatomic)ShoucangModel *shoucangMode;

@property(nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation TRZXCollectionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    dataArr = [[NSMutableArray alloc] initWithArray:@[@"1",@"2",@"3",@"4",@"5"]];
    self.title = @"收藏";
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = backColor;
    
    
    
    _CollectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGTH(self.view))];
    _CollectionTableView.delegate = self;
    _CollectionTableView.dataSource = self;
    
    _CollectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _CollectionTableView.showsHorizontalScrollIndicator = NO;
    _CollectionTableView.showsVerticalScrollIndicator = NO;
    _CollectionTableView.backgroundColor = backColor;
    [self.view addSubview:_CollectionTableView];
    UIView *noLabelView = [[UIView alloc]init];
    noLabelView.backgroundColor = backColor;
    noLabelView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
    _CollectionTableView.tableHeaderView = noLabelView;

    _pageNo = 1;
    
    
    _CollectionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _CollectionTableView.mj_footer.hidden = NO;
        
        _pageNo = 1;
        [self createData:_pageNo refresh:0];
    }];
    _CollectionTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [self createData:_pageNo refresh:1];
            
        }else{
            [_CollectionTableView.mj_footer endRefreshing];
            
            self.CollectionTableView.tableFooterView = self.noLabelView;
            _CollectionTableView.mj_footer.hidden = YES;
        }
    }];
    _CollectionTableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
    
}


- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
     NSDictionary *params = @{@"requestType":@"Collection_Tools_List",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                             };
    
   [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        [self.view endEditing:YES];
        if ([object[@"status_code"] isEqualToString:@"200"]) {
            NSDictionary *Arr = object[@"data"];
            _totalPage = [object[@"totalPage"] integerValue];

            if(refreshIndex==0){
                _shoucangMode = [ShoucangModel mj_objectWithKeyValues:object];
                if (_shoucangMode.data.count>0) {
                    _CollectionTableView.tableFooterView = [[UIView alloc]init];
                    _CollectionTableView.backgroundColor = backColor;

                    if(_totalPage<=1){
                        self.CollectionTableView.tableFooterView = self.noLabelView;
                        _CollectionTableView.mj_footer.hidden = YES;
                    }else{
                        _CollectionTableView.mj_footer.hidden = NO;
                        self.CollectionTableView.tableFooterView.hidden = YES;
                    }
                }else{
                    _CollectionTableView.mj_footer.hidden = YES;
                    _CollectionTableView.backgroundColor = [UIColor clearColor];
                }
                [_CollectionTableView.mj_header endRefreshing];
            }else{
                
                NSArray *array = [MyData mj_objectArrayWithKeyValuesArray:Arr];
                
                if (array.count>0) {
                    [_shoucangMode.data addObjectsFromArray:array];
                    [_CollectionTableView.mj_footer endRefreshing];
                    
                }else{
                    
                    self.CollectionTableView.tableFooterView = self.noLabelView;
                    _CollectionTableView.mj_footer.hidden = YES;
                    
                }
                
            }
            [_CollectionTableView reloadData];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shoucangMode.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyData *dataMode = [_shoucangMode.data objectAtIndex:indexPath.row];
    if ([dataMode.deleted isEqualToString:@"1"])//删除
    {
        return 112;
    }else if ([dataMode.collectionType isEqualToString:@"roadshow"])//路演
    {
        return 100;
    }else if ([dataMode.collectionType isEqualToString:@"video"])//直播
    {
        return 100;
    }else if ([dataMode.collectionType isEqualToString:@"project"])//项目路演
    {
        return 112;
    }else if ([dataMode.collectionType isEqualToString:@"online"])//在线
    {
        return 130;
    }else if ([dataMode.collectionType isEqualToString:@"otoSchool"])//一对一
    {
        return 130;
    }else{
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyData *dataMode = [_shoucangMode.data objectAtIndex:indexPath.row];
    if ([dataMode.deleted isEqualToString:@"1"]) {//删除的
        TRPCollectionProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRPCollectionProjectTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TRPCollectionProjectTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        return cell;
        
    } else if ([dataMode.collectionType isEqualToString:@"online"]) {//在线学院
        static NSString *zxID = @"zx1ID";
        ZaixianerjiyedeCell *cell = [tableView dequeueReusableCellWithIdentifier:zxID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZaixianerjiyedeCell" owner:self options:nil] lastObject];
        }
        _CollectionTableView.showsVerticalScrollIndicator = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.titleLabel.text = dataMode.collectioned.name;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataMode.collectioned.userPic] placeholderImage:[UIImage imageNamed:@"展位图"]];
        NSString * companyPosition = [NSString stringWithFormat:@" %@,%@  ",dataMode.collectioned.company,dataMode.collectioned.title];
        cell.backgroundColor = backColor;
        cell.nameLabel.text = dataMode.collectioned.user;
        cell.positionLabel.text = companyPosition;
        cell.kanguoLab.text = [NSString stringWithFormat:@"%@人看过",dataMode.collectioned.clickRate];
        return cell;

    } else if ([dataMode.collectionType isEqualToString:@"otoSchool"]) {//一对一学院
        static NSString *zxID = @"zx2ID";
        
        TRZXPOneToOneListCell *cell = [tableView dequeueReusableCellWithIdentifier:zxID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TRZXPOneToOneListCell" owner:self options:nil] lastObject];
        }
        _CollectionTableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        cell.titleLabel.text = dataMode.collectioned.topicTitle;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataMode.collectioned.expertPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
        NSString * companyPosition = [NSString stringWithFormat:@"%@,%@",dataMode.collectioned.company,dataMode.collectioned.ePosition];
        cell.numberLabel.text = @"";
        cell.nameLabel.text = dataMode.collectioned.realName;
        cell.positionLabel.text = companyPosition;
        cell.yuanchengImg.hidden = YES;
        cell.yuanchengLab.hidden = YES;
        
        return cell;
    
    } else if ([dataMode.collectionType isEqualToString:@"project"]) {//项目路演
        static NSString *zxID = @"zx3ID";
        TRZXPInvestSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:zxID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"TRZXPInvestSeeCell" owner:nil options:nil]lastObject];
        }
        _CollectionTableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        cell.titleLabel.text = dataMode.collectioned.name;
        cell.tradeLabel.text = dataMode.collectioned.tradeInfo;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataMode.collectioned.logo] placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.detailLabel.text = dataMode.collectioned.briefIntroduction;
        cell.stradeLabel.text = dataMode.collectioned.areaName;
        cell.headImageView.layer.cornerRadius = 6;
        cell.headImageView.layer.masksToBounds = YES;
        cell.bgView.layer.cornerRadius = 6;
        cell.bgView.layer.masksToBounds = YES;
        
        cell.detailLabel.hidden = YES;
        
        return cell;

    } else if ([dataMode.collectionType isEqualToString:@"roadshow"]) {//其他路演
        static NSString *zxID = @"zx3ID";
        TRZXYdyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zxID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TRZXYdyTableViewCell" owner:self options:nil] lastObject];
        }
        _CollectionTableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        if (![dataMode.collectioned.logo isKindOfClass:[NSNull class]]) {
            [cell.txImage sd_setImageWithURL:[NSURL URLWithString:dataMode.collectioned.photo] placeholderImage:[UIImage imageNamed:@"展位图"]];
        }
        cell.titleLabel.text = dataMode.collectioned.name;
        cell.zwLabel.text = dataMode.collectioned.company;
        return cell;
    }else {//直播
        SCViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCViewTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"SCViewTableViewCell" owner:self options:nil] lastObject];
        }
        _CollectionTableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        [cell.txImage sd_setImageWithURL:[NSURL URLWithString:dataMode.collectioned.headImg] placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.titleLabel.text = dataMode.collectioned.name;
        cell.zwLabel.text = dataMode.collectioned.user;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyData *dataMode = [_shoucangMode.data objectAtIndex:indexPath.row];
    if ([dataMode.deleted isEqualToString:@"1"]) {//1标示删除 0标示没删除
        TRZXPShareDeleViewController *Controller = [TRZXPShareDeleViewController alloc];
        Controller.titleStr = @"内容已删除";
        [self.navigationController pushViewController:Controller animated:YES];
    } else if ([dataMode.collectionType isEqualToString:@"online"]) {//课程
        
    } else if ([dataMode.collectionType isEqualToString:@"otoSchool"]) {//一对一
        
    }else if ([dataMode.collectionType isEqualToString:@"video"]) {//直播
       
    }else if ([dataMode.collectionType isEqualToString:@"project"]) {//项目
       
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return UITableViewCellEditingStyleDelete;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MyData *dataMode = [_shoucangMode.data objectAtIndex:indexPath.row];
        NSDictionary *params = @{@"requestType":@"Collection_Tools_List",
                                 @"collectionType":dataMode.collectionType,
                                 @"collectionId":dataMode.collectioned.mid,
                                 @"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                                 };
        
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
            if ([object[@"status_code"] isEqualToString:@"200"]) {
                [_shoucangMode.data removeObjectAtIndex:indexPath.row];
                if (_shoucangMode.data.count>0) {
                    _CollectionTableView.tableFooterView = [[UIView alloc]init];
                    _CollectionTableView.backgroundColor = backColor;
                    _CollectionTableView.mj_footer.hidden = NO;
                }else{
                    _CollectionTableView.mj_footer.hidden = YES;
                    _CollectionTableView.backgroundColor = [UIColor clearColor];
                }
                [tableView reloadData];
            }
            
        }];

        
    } else {
        
    }
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (UILabel *)noLabelView{
    if (!_noLabelView) {
        _noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _noLabelView.text = @"— 没有更多了 —";
        _noLabelView.textAlignment = NSTextAlignmentCenter;
        _noLabelView.textColor = zideColor;
    }
    return _noLabelView;
}

@end
