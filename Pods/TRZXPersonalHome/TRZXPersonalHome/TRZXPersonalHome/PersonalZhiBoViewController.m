//
//  PersonalZhiBoViewController.m
//  tourongzhuanjia
//
//  Created by Rhino on 16/6/7.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalZhiBoViewController.h"
#import "PersonalZhiBoCollectionViewCell.h"
#import "PersonalLiveVideoModel.h"
#import "TRZPWaterfallFlowLayout.h"
#import "LatestLiveModel.h"
#import "TRPLiveListCollectionCell.h"
#import "Login.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@interface PersonalZhiBoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TRWaterfallFlowLayoutDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (assign,nonatomic)NSInteger pageNo;
@property (assign,nonatomic)NSInteger totalPage;
@property (nonatomic, strong) UIButton *rightButton;



@end

@implementation PersonalZhiBoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.delegate pushAllSetting];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.title = _titleStr;
    if (([_otherStr isEqualToString:@"0"]||[_otherStr isEqualToString:@"1"])&&[_titleStr isEqualToString:@"路演直播"]){// 股东  &&[KPOUserDefaults currentSessionUserTypeIsShare]
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    }
    [self createUI];
    
}
-(UIButton *)rightButton{
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [_rightButton setTitle:@"我要直播" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _rightButton;
}
- (void)createUI
{
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadData];
        [weakSelf.collectionView.mj_footer resetNoMoreData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [weakSelf loadMoreData];
            
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)loadData
{
    self.pageNo = 1;
    NSDictionary *params = @{@"requestType":@"Live_Video_Api",
                             @"apiType":@"list",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)self.pageNo],
                             @"beVistedId":self.beVistedId?self.beVistedId:@""
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id json, NSError *error) {
        
        if ([json[@"status_code"] isEqualToString:@"200"]) {
            
            self.totalPage = [json[@"totalPige"] integerValue];
            NSArray *liveVedioArray = [LatestLiveModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (self.dataSource.count > 0) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:liveVedioArray];
            if (self.dataSource.count > 0) {
                self.collectionView.backgroundColor = backColor;
                //                self.bgdImage.hidden = YES;
                self.collectionView.mj_footer.hidden = NO;
                [self.collectionView reloadData];
            }else{
                self.collectionView.mj_footer.hidden = YES;
                self.collectionView.backgroundColor = [UIColor clearColor];
                //                self.bgdImage.hidden = NO;
            }
            
        }else{
            
        }
        
        [self.collectionView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData
{
    NSDictionary *params = @{@"requestType":@"Live_Video_Api",
                             @"apiType":@"list",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)self.pageNo],
                             @"beVistedId":self.beVistedId?self.beVistedId:@""
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id json, NSError *error) {
        
        if ([json[@"status_code"] isEqualToString:@"200"]) {
            NSArray *liveVedioArray = [LatestLiveModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.dataSource addObjectsFromArray:liveVedioArray];
            [self.collectionView reloadData];
            
        }else{
            
        }
        [self.collectionView.mj_footer endRefreshing];
        
    }];
    
}
#pragma mark -- collection delegate
//有多少个组section
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TRPLiveListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRPLiveListCollectionCell" forIndexPath:indexPath];
    LatestLiveModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    
    return cell;
}




#pragma mark - delegate methods;
#pragma mark - <WaterfallFlowLayoutDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(TRZPWaterfallFlowLayout *)collectionViewLayout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LatestLiveModel *model = self.dataSource[indexPath.row];
    
    CGFloat W = (SCREEN_WIDTH - 3 * 1) / 2;
    NSString *liveTitle;
    
    if(model.liveTitle.length>0){
        liveTitle = model.liveTitle;
    }else if (model.abstractz.length>0){
        liveTitle = model.abstractz;
    }else if (model.title.length>0){
        liveTitle = model.title;
    }
    
    NSInteger videoBgH;
    
    if(model.img.length==0){
        videoBgH = W;
        
    }else{
        videoBgH = (self.view.bounds.size.width*3)/4;
        
    }
    
    
    
    
    //    CGFloat H = [liveTitle heightWithFont:[UIFont systemFontOfSize:14] withinWidth:W-20]+videoBgH;
    
    return CGSizeMake(W , videoBgH);
}


//点击调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    __weak PersonalZhiBoViewController *weakSelf = self;
    //
    //    LatestLiveModel *model = self.dataSource[indexPath.row];
    
    
}
//我要直播
- (void)saveBtnClick:(UIButton *)sender
{
    
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
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        TRZPWaterfallFlowLayout *flowLayout= [[TRZPWaterfallFlowLayout alloc]init];
        flowLayout.delegate = self;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = backColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"TRPLiveListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TRPLiveListCollectionCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

@end
