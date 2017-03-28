//
//  DynamicHomeViewController.m
//  TRZX
//
//  Created by 张江威 on 2016/10/27.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "DynamicHomeViewController.h"
#import "TRZXFriendLineRefreshFooter.h"
#import "DynamicHomeModel.h"
#import "TRZXFriendLineCellModel.h"

#import "TRZXFriendDetailsViewController.h"
#import "MHActionSheet.h"
#import "MJRefresh.h"
#import "TRZXNetwork.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"


#import "DynamicHomeModel.h"

#import "DynamicGraphicCell.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "TRZXFriendLineTableViewController.h"


#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]



@interface DynamicHomeViewController ()<UIActionSheetDelegate,NewDetailsDelegate>
{
    TRZXFriendLineRefreshFooter *_refreshFooter;
}

@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIImageView * bgdImage;

@end

@implementation DynamicHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if ([_navStr isEqualToString:@"1"]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:heizideColor}];
    }else{
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:0.85]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = nil;
    if (![_navStr isEqualToString:@"1"]) {
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController.navigationBar setBarTintColor:nil];
    }
    
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    _bgdImage = [[UIImageView alloc]init];
    _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
    //    _bgdImage.contentMode =  UIViewContentModeScaleAspectFill;
    _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:_bgdImage];
    _bgdImage.hidden = YES;
    
    self.view.backgroundColor = backColor;;
    self.tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [_rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_rightBtn addTarget:self action:@selector(RightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
//    if ([_navStr isEqualToString:@"1"]) {
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem kipo_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:zideColor action:@selector(leftBarButtonItemPressed:)];
//        [_rightBtn setTitleColor:zideColor forState:UIControlStateNormal];
//    }else{
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem kipo_LeftTarButtonItemDefaultTarget:self titelabe:@"返回白" color:[UIColor whiteColor] action:@selector(leftBarButtonItemPressed:)];
//        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }


    
    _pageNo = 1;
    [self createData:_pageNo refresh:0];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.tableView.mj_footer.hidden = NO;
        
        _pageNo = 1;
        [self createData:_pageNo refresh:0];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [self createData:self.pageNo refresh:1];

        }else{
            
            self.tableView.mj_footer.hidden = YES;

        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView registerClass:[DynamicGraphicCell class] forCellReuseIdentifier:@"DynamicGraphicCell"];
    
}
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
    NSDictionary *params = @{
                             @"requestType":@"Circle_Api",
                             @"apiType":@"commentMesList",
                             @"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        NSDictionary *Arr = object[@"data"];
        _totalPage = [object[@"totalPage"] integerValue];
        
        if(refreshIndex==0){
            self.dataArray =  [NSMutableArray arrayWithArray:[DynamicHomeModel mj_objectArrayWithKeyValuesArray:Arr]];
            
            if(_totalPage == 1){
                if (self.dataArray.count >0){
                    
                    self.tableView.mj_footer.hidden = YES;
                    self.bgdImage.hidden = YES;
                }else{
                    self.tableView.mj_footer.hidden = YES;
                    self.bgdImage.hidden = NO;
                }
                
            }else{
                self.tableView.tableFooterView.hidden = YES;
                self.tableView.mj_footer.hidden = NO;
                self.bgdImage.hidden = YES;
            }
            [self.tableView.mj_header endRefreshing];
        }else{
            NSMutableArray *array = [DynamicHomeModel mj_objectArrayWithKeyValuesArray:Arr];
            
            if (array.count>0) {
                [self.dataArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            }else{
                
                self.tableView.mj_footer.hidden = YES;
                
            }
        }
        if (self.dataArray.count == 0) {
            _rightBtn.userInteractionEnabled = NO;
        }else{
            _rightBtn.userInteractionEnabled = YES;
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynamicGraphicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicGraphicCell"];
    DynamicHomeModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [DynamicGraphicCell class];
    DynamicHomeModel *model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    
}

//删除某一行
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.tableView) {
            DynamicHomeModel *model = self.dataArray[indexPath.row];
            
            NSDictionary *params = @{@"requestType":@"Circle_Api",
                                    @"apiType":@"clear",
                                    @"type":@"one",
                                    @"mid":model.mid?model.mid:@""};
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
                
                if ([object[@"status_code"] isEqualToString:@"200"]) {
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    if (self.dataArray.count == 0) {
                        self.tableView.tableFooterView.hidden = YES;
                        self.tableView.mj_footer.hidden = YES;
                        self.bgdImage.hidden = NO;
                        _rightBtn.userInteractionEnabled = NO;
                    }
                }
                
            }];
            
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DynamicHomeModel *mode = [self.dataArray objectAtIndex:indexPath.row];
    if ([mode.cirDel isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该动态已经删除" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if ([mode.delFlag isEqualToString:@"1"]&&[mode.type isEqualToString:@"text"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该评论已经删除" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else {
        TRZXFriendDetailsViewController * DetailsVC = [[TRZXFriendDetailsViewController alloc]init];
        DetailsVC.indexTeger = indexPath.row;
        DetailsVC.userIdStr = mode.circleId;
        DetailsVC.navStr = _navStr;
        DetailsVC.delegate = self;
        [self.navigationController pushViewController:DetailsVC animated:true];
    }
    
}



- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


//左侧按钮的返回
-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.delegate pushload];
    [self.navigationController popViewControllerAnimated:YES];
}

//右侧按钮的返回
-(void)RightBarButtonItemPressed:(UIButton *)button{
    
    MHActionSheet *actionSheet = [[MHActionSheet alloc] initSheetWithTitle:nil style:MHSheetStyleDefault itemTitles:@[@"清空所有信息"]];
//    actionSheet.titleTextFont = [UIFont systemFontOfSize:16];
    actionSheet.itemTextFont = [UIFont systemFontOfSize:16];
    actionSheet.cancleTextFont = [UIFont systemFontOfSize:16];
//    actionSheet.titleTextColor = [UIColor redColor];
    actionSheet.itemTextColor = TRZXMainColor;
    actionSheet.cancleTextColor = heizideColor;
//    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        if (index == 0) {
            NSDictionary *params = @{@"requestType":@"Circle_Api",
                                     @"apiType":@"clear",
                                     @"type":@"all"
                                     };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
                if ([object[@"status_code"] isEqualToString:@"200"]) {
                    [self.dataArray removeAllObjects];
                    self.tableView.mj_footer.hidden = YES;
                    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
                    self.bgdImage.hidden = NO;
                    _rightBtn.userInteractionEnabled = NO;
                    [self.tableView reloadData];
                }
                
            }];
        }
        
        
    }];
    
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清空所有信息", nil];
//        [sheet showInView:self.view];
    
    //这种弹出方式屏蔽
    
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清空所有信息？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
//        if ([indexNumber intValue] == 1) {
//            [TRZXFriendModelViews getTRZXFriendListOnedelete:@"" type:@"all" success:^(id object){
//                if ([object[@"status_code"] isEqualToString:@"200"]) {
//                    [self.dataArray removeAllObjects];
//                    self.tableView.mj_footer.hidden = YES;
//                    self.bgdImage.hidden = NO;
//                    _rightBtn.userInteractionEnabled = NO;
//                    [self.tableView reloadData];
//                }
//            } failure:^(NSError *error) {
//                
//            }];
//        }
//    }];
    
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex == 0){
//        [TRZXFriendModelViews getTRZXFriendListOnedelete:@"" type:@"all" success:^(id object){
//            if ([object[@"status_code"] isEqualToString:@"200"]) {
//                [self.dataArray removeAllObjects];
//                self.tableView.mj_footer.hidden = YES;
//                self.bgdImage.hidden = NO;
//                _rightBtn.userInteractionEnabled = NO;
//                [self.tableView reloadData];
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//
//    }
//}
- (void)refresh{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该动态已经删除" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
