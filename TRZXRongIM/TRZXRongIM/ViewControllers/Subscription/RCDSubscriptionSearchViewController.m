//
//  RCDSubscriptionSearchViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSubscriptionSearchViewController.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDPublicServiceProfileViewController.h"
#import "RCDSubscriptionResultTitleView.h"
#import "RCDSubscriptionResultCell.h"
#import "RCDCommonDefine.h"


@interface RCDSubscriptionSearchViewController ()<UISearchBarDelegate,UISearchControllerDelegate>

@property (strong, nonatomic) NSMutableArray *searchResult;

@property (strong, nonatomic) UIView *statusBackView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *notSearch;

@property (nonatomic, strong) UIView *converView;

@end

@implementation RCDSubscriptionSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    
    [self.searchBar becomeFirstResponder];
    
    self.searchBar.delegate = self;
    
    NSArray *array = [[RCIMClient sharedRCIMClient] getPublicServiceList];
    
    NSLog(@"array = %@",array);
    
}

#pragma mark - SearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.converView.hidden = NO;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.converView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    if (self.searchResult.count) {
//        self.headView.height = 40;
//        self.notSearch.hidden = YES;
//    }else{
//        self.notSearch.hidden = NO;
//    }
    //搜索
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if([text RC_isInputRuleAndBlank]){
        return YES;
    }else{
        return NO;
    }
}

/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [[RCIMClient sharedRCIMClient] searchPublicServiceByType:RC_APP_PUBLIC_SERVICE searchType:RC_SEARCH_TYPE_FUZZY searchKey:searchText success:^(NSArray *accounts) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResult removeAllObjects];
            
            [self.searchResult addObjectsFromArray:accounts];
            if (self.searchResult.count) {
                self.headView.height = 40;
                self.notSearch.hidden = YES;
            }else{
                self.notSearch.hidden = NO;
            }
            //搜索
            [self.tableView reloadData];
        });
        
    } error:^(RCErrorCode status) {
        NSLog(@"%ld",(long)status);
    }];
}

-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
//        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"搜索订阅刊";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.backgroundColor = [UIColor whiteColor];
        [_searchBar setBarTintColor:[UIColor blackColor]];
        [_searchBar RC_setSearchTextFieldBackgroundColor:[UIColor trzx_BackGroundColor]];
        
        [_searchBar RC_setSearchCancelButtonTitle:@"取消" titleColor:[UIColor trzx_TextColor] titleFont:nil];
        [_searchBar setImage:[UIImage RC_BundleImgName:@"RCDSubscription_SearchBar_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UIButton *button = [UIButton RC_buttonWithTitle:@"取消" color:[UIColor trzx_TextColor] imageName:nil target:self action:@selector(searchBarCancelButtonClicked:)];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        UIView *backView = [UIView RC_viewWithColor:[UIColor whiteColor]];
        
        [self.view addSubview:backView];
        [backView addSubview:_searchBar];
        [backView addSubview:button];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusBackView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.offset(44);
        }];
        
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.statusBackView.mas_bottom);
            make.right.equalTo(self.view).offset(-50);
            make.height.offset(44);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView);
            make.bottom.equalTo(backView);
//            make.left.equalTo(_searchBar.mas_right);
            make.right.equalTo(backView);
            make.width.offset(50);
        }];
        
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.y -= 80;
        _tableView.backgroundColor = [UIColor trzx_BackGroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        [_tableView kipo_makeDataSource:^(KPTableViewDataSourceMaker *make) {
//            make.scrollViewDidScrollBlock = SearchViewDidScrollBlock;
            [make makeSection:^(KPTableViewSectionMaker *section) {
                section.cell([UITableViewCell class])
                .data(@[self.searchResult])
                .adapter(^(UITableViewCell *cell, id data , NSUInteger index){
                    if (self.searchResult.count) {
                        cell.hidden = NO;
                        if(!cell.contentView.subviews.count){
                            [cell addSubview:self.headView];
                        }
                    }else{
                        cell.hidden = YES;
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }).height(40);
            }];
            
            [make makeSection:^(KPTableViewSectionMaker *section) {
                section.cell([RCDSubscriptionResultCell class])   //cell
                .data(self.searchResult)                          //数据
                .adapter(^(RCDSubscriptionResultCell *cell , RCPublicServiceProfile *profile , NSUInteger index){                                       //适配
                    cell.profile = profile;
//                    [self.searchBar resignFirstResponder];
                }).height(90)                                     //cell高度
                .Event(^(NSUInteger index,RCPublicServiceProfile *profile){//点击事件
                    RCDPublicServiceProfileViewController *publicServiceVC = [[RCDPublicServiceProfileViewController alloc] init];
                    publicServiceVC.profile = profile;
                    [self.navigationController pushViewController:publicServiceVC  animated:YES];
                });
            }];
        }];
    }
    return _tableView;
}

-(UIView *)notSearch{
    if (!_notSearch) {
        CGFloat imageViewWidth = RC_SCREEN_WIDTH - 150;
        CGFloat labelHeight = 30;
        _notSearch = [[UIView alloc]initWithFrame:CGRectMake((RC_SCREEN_WIDTH - imageViewWidth) * 0.5 - 10,150, imageViewWidth, imageViewWidth + labelHeight + 10)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewWidth)];
        imageView.image = [UIImage RC_BundleImgName:@"RCD_Search_NotResult"];
        _notSearch.center = self.view.center;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageViewWidth + 10, imageViewWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"搜索无结果";
        
        [_notSearch addSubview:imageView];
        [_notSearch addSubview:label];
        _notSearch.hidden = YES;
        [self.view addSubview:_notSearch];
        
//        [_notSearch addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//            if([self.searchBar isFirstResponder])[self.searchBar resignFirstResponder];
//        }]];
        
    }
    return _notSearch;
}


-(UIView *)statusBackView{
    if (!_statusBackView) {
        _statusBackView = [UIView RC_viewWithColor:[UIColor whiteColor]];
        [self.view addSubview:_statusBackView];
        [_statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.offset(20);
        }];
    }
    return _statusBackView;
}

-(NSMutableArray *)searchResult{
    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}

-(UIView *)headView{
    if (!_headView) {
        RCDSubscriptionResultTitleView *titleView = [[RCDSubscriptionResultTitleView alloc] initWithFrame:CGRectMake(0, 10, RC_SCREEN_WIDTH, 30)];
        _headView = [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
        [_headView addSubview:titleView];
        _headView.frame = CGRectMake(0, 0, RC_SCREEN_WIDTH, 0);
    }
    return _headView;
}

-(UIView *)converView{
    if(!_converView){
        _converView = [UIView RC_viewWithColor:[UIColor clearColor]];
        [self.view addSubview:_converView];
        [_converView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(converViewWithTap:)];
        [_converView addGestureRecognizer:tap];

    }
    return _converView;
}

- (void)converViewWithTap:(UITapGestureRecognizer *)tap{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    _converView.hidden = YES;
}

@end
