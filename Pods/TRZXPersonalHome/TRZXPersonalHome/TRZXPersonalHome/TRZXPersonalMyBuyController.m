//
//  TRZXPersonalMyBuyController.m
//  TRZXPersonalMyBuy
//
//  Created by 张江威 on 2017/2/22.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPersonalMyBuyController.h"
#import "ZXShouMode.h"
#import "ZaixianerjiyedeCell.h"
#import "MJRefresh.h"
#import "TRZXNetwork.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"


#define  zjself __weak __typeof(self) sfself = self
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]


@interface TRZXPersonalMyBuyController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *liebiaoDataArr;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic, strong) UIImageView * bgdImage;

@property (strong, nonatomic) UILabel * noLabelView;

@end


@implementation TRZXPersonalMyBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    _bgdImage = [[UIImageView alloc]init];
    _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
    //    _bgdImage.contentMode =  UIViewContentModeScaleAspectFill;
    _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:_bgdImage];
    _bgdImage.hidden = YES;
    
    
    self.title = @"我的购买";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.height)-64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = backColor;
    [self.view addSubview:_tableView];
    
    _liebiaoDataArr=[[NSMutableArray alloc]init];
    _pageNo = 1;
    
    
    zjself;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNo = 1;
        [sfself createData:_pageNo refresh:0];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [sfself createData:_pageNo refresh:1];
            
        }else{
            [_tableView.mj_footer endRefreshing];
            self.tableView.tableFooterView = self.noLabelView;
            _tableView.mj_footer.hidden = YES;
        }
    }];
    _tableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
}



- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex
{
    NSDictionary *params = @{
                             @"requestType":@"New_Schoole_Api",
                             @"apiType":@"myPay",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        if (data) {
            NSDictionary *Arr = data[@"data"];
            _totalPage = [data[@"totalPage"] integerValue];
            
            if(refreshIndex==0){
                _liebiaoDataArr = [[NSMutableArray alloc]initWithArray:[ZXShouMode mj_objectArrayWithKeyValuesArray:Arr]];
                if (_liebiaoDataArr.count>0) {
                    self.tableView.tableFooterView = [[UIView alloc]init];
                    _tableView.backgroundColor = backColor;
                    self.bgdImage.hidden = YES;
                    if(_totalPage<=1){
                        self.tableView.tableFooterView = self.noLabelView;
                        _tableView.mj_footer.hidden = YES;
                    }else{
                        _tableView.mj_footer.hidden = NO;
                        self.tableView.tableFooterView.hidden = YES;
                    }
                }else{
                    _tableView.mj_footer.hidden = YES;
                    _tableView.backgroundColor = [UIColor clearColor];
                    self.bgdImage.hidden = NO;
                }
                
                [_tableView.mj_header endRefreshing];
            }else{
                
                NSArray *array = [ZXShouMode mj_objectArrayWithKeyValuesArray:Arr];
                
                if (array.count>0) {
                    [_liebiaoDataArr addObjectsFromArray:array];
                    [_tableView.mj_footer endRefreshing];
                    
                }else{
                    if (!_noLabelView) {
                        _noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                        _noLabelView.text = @"— 没有更多了 —";
                        _noLabelView.textAlignment = NSTextAlignmentCenter;
                        _noLabelView.textColor = zideColor;
                        self.tableView.tableFooterView = _noLabelView;
                    }
                    _tableView.mj_footer.hidden = YES;
                    
                }
                
            }
            [_tableView reloadData];
        }else{
            _tableView.mj_footer.hidden = YES;
            _tableView.backgroundColor = [UIColor clearColor];
            self.bgdImage.hidden = NO;
            
        }
        
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _liebiaoDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXShouMode *mode = [_liebiaoDataArr objectAtIndex:indexPath.row];
    ZaixianerjiyedeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZaixianerjiyedeCell"];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZaixianerjiyedeCell" owner:self options:nil] lastObject];
    }
    self.tableView.showsVerticalScrollIndicator =
    NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.titleLabel.text = mode.name;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:mode.userPic] placeholderImage:[UIImage imageNamed:@"展位图"]];
    NSString * companyPosition = [NSString stringWithFormat:@"  %@,%@  ",mode.company,mode.title];
    cell.kanguoLab.text = [NSString stringWithFormat:@"%@人看过",mode.clickRate];
    
    if(mode.title==nil){
        companyPosition = mode.user;
    }
    cell.backgroundColor = backColor;
    cell.nameLabel.text = mode.user;
    cell.positionLabel.text = companyPosition;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



