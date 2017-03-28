//
//  TRZXPersonalCareAboutController.m
//  TRZXPersonalCareAbout
//
//  Created by 张江威 on 2017/2/23.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPersonalCareAboutController.h"
#import "PersonalGuanZhuCell.h"
#import "TRZXCareAboutModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"
#import "TRZXPersonalHomeViewController.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define  zjself __weak __typeof(self) sfself = self
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]



@interface TRZXPersonalCareAboutController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;

//@property (strong, nonatomic) NSMutableArray * personalArr;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;
@property (strong, nonatomic) UILabel *noLabelView;
@property (nonatomic, strong) UIImageView * bgdImage;
@property (nonatomic, strong) TRZXCareAboutModel * cereAboutModel;


@end

@implementation TRZXPersonalCareAboutController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.delegate pushAllSetting];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.title = @"关注";
    
    _bgdImage = [[UIImageView alloc]init];
    _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
    _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:_bgdImage];
    _bgdImage.hidden = YES;

    _pageNo = 1;
    
    [self createUI];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _myTableView.mj_footer.hidden = NO;
        _noLabelView.hidden = YES;
        _pageNo = 1;
        [self createData:_pageNo refresh:0];
    }];
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [self createData:_pageNo refresh:1];
            
        }else{
            [_myTableView.mj_footer endRefreshing];
            _myTableView.tableFooterView = self.noLabelView;
            _noLabelView.hidden = NO;
            _myTableView.mj_footer.hidden = YES;
        }
    }];
    _myTableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
    
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
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
        
        NSDictionary *params = @{@"requestType":@"Collection_Tools_List",
                                 @"apiType":@"findFollowList",
                                 @"id":_midStr?_midStr:@"",
                                 @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                                 };
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
            if ([object[@"status_code"] isEqualToString:@"200"]) {
                NSDictionary *personalArr = object[@"data"];
                _totalPage = [object[@"totalPage"] integerValue];
                if(refreshIndex==0){
                    _cereAboutModel = [TRZXCareAboutModel mj_objectWithKeyValues:object];
                    if (_cereAboutModel.data.count>0) {
                        _myTableView.tableFooterView = [[UIView alloc]init];
                        _myTableView.mj_footer.hidden = NO;
                        _myTableView.backgroundColor = backColor;
                        self.bgdImage.hidden = YES;
                        if(_totalPage<=1){
                            _myTableView.tableFooterView = self.noLabelView;
                            _noLabelView.hidden = NO;
                            _myTableView.mj_footer.hidden = YES;
                        }else{
                            _myTableView.mj_footer.hidden = NO;
                            _myTableView.tableFooterView.hidden = YES;
                        }
                    }else{
                        _myTableView.mj_footer.hidden = YES;
                        _myTableView.backgroundColor = [UIColor clearColor];
                        self.bgdImage.hidden = NO;
                    }
                    [_myTableView.mj_header endRefreshing];
                }else{
                    NSArray *array = [Data mj_objectArrayWithKeyValuesArray:personalArr];
                    if (array.count>0) {
                        [_cereAboutModel.data addObjectsFromArray:array];
                        [_myTableView.mj_footer endRefreshing];
                        
                    }else{
                        _bgdImage.hidden = NO;
                        _myTableView.mj_footer.hidden = YES;
                    }
                }
                [_myTableView reloadData];
            }else{
                _myTableView.mj_footer.hidden = YES;
                _myTableView.backgroundColor = [UIColor clearColor];
                _bgdImage.hidden = NO;
                
            }
            [_myTableView.mj_footer endRefreshing];
            [_myTableView.mj_header endRefreshing];
        
    }];
}
- (void)createUI{
    _myTableView = [[UITableView alloc] init];
    _myTableView.frame = CGRectMake(0, 65, self.view.frame.size.width, (self.view.frame.size.height)- 65);
    _myTableView.separatorStyle = NO;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = backColor;
    [self.view addSubview:_myTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cereAboutModel.data.count;
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
    Data *model = [_cereAboutModel.data objectAtIndex:indexPath.row];
    PersonalGuanZhuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalGuanZhuCell"];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalGuanZhuCell" owner:self options:nil] lastObject];
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _myTableView.showsVerticalScrollIndicator =
    NO;
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Data *model = [_cereAboutModel.data objectAtIndex:indexPath.row];
    TRZXPersonalHomeViewController * studentPersonal=[[TRZXPersonalHomeViewController alloc]init];
    studentPersonal.midStrr = model.userId;
    studentPersonal.otherStr = @"1";
    [self.navigationController pushViewController:studentPersonal animated:true];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Data *model = [_cereAboutModel.data objectAtIndex:indexPath.row];
        
        NSDictionary *params = @{@"requestType":@"Collection_Tools_List",
                                 @"apiType":@"cancelFollow",
                                 @"id":model.mid,
                                 @"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                                 };
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
            
            //删除好友(融云的先注销)
//            [[RCDataBaseManager shareInstance] deleteFriendFromDB:model.userId];
            
            if ([object[@"status_code"] isEqualToString:@"200"]) {
                _myTableView.mj_footer.hidden = NO;
                _noLabelView.hidden = YES;
                _pageNo = 1;
                [self createData:_pageNo refresh:0];
            }else{
                
            }
        }];
        
    } else {
        
    }
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)goBackView:(UIButton *)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}



@end

