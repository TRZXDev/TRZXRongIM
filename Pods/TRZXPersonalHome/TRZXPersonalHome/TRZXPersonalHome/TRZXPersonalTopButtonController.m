//
//  TRZXPersonalTopButtonController.m
//  TRZXPersonalTopButton
//
//  Created by 张江威 on 2017/2/23.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPersonalTopButtonController.h"
#import "PersonalGuanZhuCell.h"
#import "TRZPersonalModell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"
#import "TRZXPersonalHomeViewController.h"



#define  zjself __weak __typeof(self) sfself = self
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]


@interface TRZXPersonalTopButtonController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *guanzhuTableView;
@property (strong, nonatomic) TRZPersonalModell *PersonalMode;
@property (strong, nonatomic) NSMutableArray * personalArr;

@property (strong, nonatomic) NSString * requestTypeStr;
@property (strong, nonatomic) NSString * apiTypeStr;
@property (strong, nonatomic) NSString * pageNoStr;
@property (strong, nonatomic) UILabel * noLabelView;

@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic, strong) UIImageView * bgdImage;

@end

@implementation TRZXPersonalTopButtonController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_midStrr.length == 0) {
        _midStrr = @"ed48b2ecda7f485e9c3353ecfb53f3f5";
        _titleStrr = @"粉丝";
    }
    self.title = _titleStrr;
    self.view.backgroundColor = backColor;
    
    _bgdImage = [[UIImageView alloc]init];
    _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
    _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:_bgdImage];
    _bgdImage.hidden = YES;
    
    _pageNo = 1;
    
    [self createUI];
    zjself;
    _guanzhuTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _guanzhuTableView.mj_footer.hidden = NO;
        _noLabelView.hidden = YES;
        _pageNo = 1;
        [sfself createData:_pageNo refresh:0];
    }];
    _guanzhuTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [sfself createData:_pageNo refresh:1];
            
        }else{
            [_guanzhuTableView.mj_footer endRefreshing];
            _guanzhuTableView.tableFooterView = self.noLabelView;
            _noLabelView.hidden = NO;
            _guanzhuTableView.mj_footer.hidden = YES;
        }
    }];
    _guanzhuTableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
}
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
    
    NSString * idStr;
    if ([_titleStrr isEqualToString:@"关注"]){
        _requestTypeStr = @"Collection_Tools_List";
        _apiTypeStr = @"findFollowList";
        idStr = @"id";
    }else if ([_titleStrr isEqualToString:@"粉丝"]) {
        _requestTypeStr = @"Collection_Tools_List";
        _apiTypeStr = @"findFansList";
        idStr = @"id";
    }else if ([_titleStrr isEqualToString:@"课程观众"]) {
        _requestTypeStr = @"User_Record_Api";
        _apiTypeStr = @"studentWatch";
        idStr = @"beVisitId";
    }else if ([_titleStrr isEqualToString:@"学员咨询"]) {
        _requestTypeStr = @"User_Record_Api";
        _apiTypeStr = @"studentMeet";
        idStr = @"beVisitId";
    }else if ([_titleStrr isEqualToString:@"路演观众"]) {
        _requestTypeStr = @"User_Record_Api";
        _apiTypeStr = @"roadShowWatch";
        idStr = @"beVisitId";
    }else if ([_titleStrr isEqualToString:@"我答"]) {
        _requestTypeStr = @"User_Record_Api";
        _apiTypeStr = @"roadShowWatch";
        idStr = @"beVisitId";
    }else if ([_titleStrr isEqualToString:@"我问"]) {
        _requestTypeStr = @"User_Record_Api";
        _apiTypeStr = @"roadShowWatch";
        idStr = @"beVisitId";
    }
        NSDictionary *params = @{@"requestType":_requestTypeStr,
                                 @"apiType":_apiTypeStr,
                                 idStr:_midStrr,
                                 @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                                 };
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
            
            if ([object[@"status_code"] isEqualToString:@"200"]) {
                
                NSDictionary *personalArr = object[@"data"];
                _totalPage = [object[@"totalPage"] integerValue];
                if(refreshIndex==0){
                    _personalArr = [[NSMutableArray alloc]initWithArray:[TRZPersonalModell mj_objectArrayWithKeyValuesArray:personalArr]];
                    if (_personalArr.count>0) {
                        _guanzhuTableView.tableFooterView = [[UIView alloc]init];
                        _guanzhuTableView.backgroundColor = backColor;
                        _bgdImage.hidden = YES;
                        if(_totalPage<=1){
                            _guanzhuTableView.tableFooterView = self.noLabelView;
                            _noLabelView.hidden = NO;
                            _guanzhuTableView.mj_footer.hidden = YES;
                        }else{
                            _guanzhuTableView.mj_footer.hidden = NO;
                            _guanzhuTableView.tableFooterView.hidden = YES;
                        }
                    }else{
                        _guanzhuTableView.mj_footer.hidden = YES;
                        _guanzhuTableView.backgroundColor = [UIColor clearColor];
                        self.bgdImage.hidden = NO;
                    }
                    [_guanzhuTableView.mj_header endRefreshing];
                }else{
                    NSArray *array = [TRZPersonalModell mj_objectArrayWithKeyValuesArray:personalArr];
                    if (array.count>0) {
                        [_personalArr addObjectsFromArray:array];
                        [_guanzhuTableView.mj_footer endRefreshing];
                        
                    }else{
                        _bgdImage.hidden = NO;
                        _guanzhuTableView.mj_footer.hidden = YES;
                    }
                }
                [_guanzhuTableView reloadData];
            }else{
                _bgdImage.hidden = NO;
                _guanzhuTableView.mj_footer.hidden = YES;
                _guanzhuTableView.backgroundColor = [UIColor clearColor];
            }
            [_guanzhuTableView.mj_footer endRefreshing];
            [_guanzhuTableView.mj_header endRefreshing];

        }];
        
}
- (void)createUI{
    _guanzhuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, (self.view.frame.size.height)- 65)];
    _guanzhuTableView.separatorStyle = NO;
    _guanzhuTableView.delegate = self;
    _guanzhuTableView.dataSource = self;
    _guanzhuTableView.backgroundColor = backColor;
    
    [self.view addSubview:_guanzhuTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personalArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonalGuanZhuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalGuanZhuCell"];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalGuanZhuCell" owner:self options:nil] lastObject];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    TRZPersonalModell *model = [_personalArr objectAtIndex:indexPath.row];
    if ([_titleStrr isEqualToString:@"粉丝"]||[_titleStrr isEqualToString:@"关注"]){
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"展位图"]];
    }else {
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:model.headImg]placeholderImage:[UIImage imageNamed:@"展位图"]];
    }
    cell.nameLabel.text = model.name;
    cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",model.company,model.position];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TRZPersonalModell *model = [_personalArr objectAtIndex:indexPath.row];
    TRZXPersonalHomeViewController * studentPersonal=[[TRZXPersonalHomeViewController alloc]init];
    studentPersonal.midStrr = model.userId;if ([_titleStrr isEqualToString:@"粉丝"]||[_titleStrr isEqualToString:@"关注"]){
        studentPersonal.midStrr = model.userId;
    }else {
        studentPersonal.midStrr = model.mid;
    }
    studentPersonal.otherStr = @"1";
    [self.navigationController pushViewController:studentPersonal animated:true];
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

@end

