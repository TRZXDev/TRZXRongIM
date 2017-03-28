//
//  RCDSearchFriendTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/12.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDSearchFriendViewController.h"
 
#import "RCDHttpTool.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDRCIMDataSource.h"
#import "RCDUserInfo.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDAddFriendViewController.h"
#import "RCDataBaseManager.h"
#import "RCDSearchUserInfo.h"
#import "RCDPersonDetailViewController.h"
#import "RCDAddFriendCell.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIView+RCExtension.h"
#import "RCDCommonDefine.h"
#import "UISearchBar+RCExtension.h"
#import <TRZXKit/UIColor+APP.h>
#import "TRZXGifFooter.h"

@interface RCDSearchFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>

@property (strong, nonatomic) NSMutableArray *searchResult;

@property (strong, nonatomic) UIView *notSearch;

@property (assign , nonatomic) NSUInteger pageNo;

@property (assign , nonatomic) NSUInteger totalPage;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong)UISearchBar *searchBar;

@property (strong, nonatomic) UIView *statusBackView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *converView;

@end

@implementation RCDSearchFriendViewController

#pragma mark - 视图生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initial data
    _searchResult=[[NSMutableArray alloc] init];
    [self.searchBar becomeFirstResponder];
    
    [self tableView];
    [self converView];
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

+(instancetype) searchFriendViewController{
    RCDSearchFriendViewController *searchController = [[RCDSearchFriendViewController alloc] init];
    return searchController;
}

#pragma mark - searchResultDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchResult.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *reusableCellWithIdentifier = @"RCDAddFriendCell";
    RCDAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddFriendCell"];
    if(!cell){
        cell = [[RCDAddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDAddFriendCell"];
        [cell.headImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        cell.addButton.hidden = YES;
        cell.companyLabel.numberOfLines = 1;
        [cell separatorView];
    }
    
    if (_searchResult.count) {
        RCDUserInfo *user =_searchResult[indexPath.row];
        if(user){
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:user.portraitUri]];
            cell.nameLabel.text = user.name;
            if(user.company.length && user.position){
                cell.companyLabel.text = [NSString stringWithFormat:@"%@ , %@",user.company,user.position];
            }
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchResult.count) {
        RCDUserInfo *user = self.searchResult[indexPath.row];
        if(user && tableView == self.tableView){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            RCDPersonDetailViewController *addViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDPersonDetailViewController"];
            addViewController.title = @"加为好友";
            addViewController.userInfo = user;
            [self.navigationController pushViewController:addViewController animated:YES];
        }
    }
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text length]) {
        
        [[RCDHttpTool shareInstance] searchFriendListByName:searchBar.text pageNo:1 complete:^(NSMutableArray *result, NSUInteger totalPage, NSUInteger pageNo) {
            _searchResult = result;
            self.pageNo = pageNo;
            self.totalPage = totalPage;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result.count){
                    self.notSearch.hidden = YES;
                    self.tableView.mj_footer.hidden = NO;
                    self.searchText = searchBar.text;
                    if (self.pageNo >= self.totalPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }else{
                    self.notSearch.hidden = NO;
                    self.tableView.mj_footer.hidden = YES;
                }
                [self.tableView reloadData];
                if ([self.searchBar isFirstResponder]) {
                    [self.searchBar resignFirstResponder];
                }
            });
        }];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    for (UIView *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label = (UILabel *)subView;
            label.text = @"";
        }
    }
    if(searchBar.text.length == 0){
        self.notSearch.hidden = YES;
        _searchResult = nil;
        [self.tableView reloadData];
        self.tableView.mj_footer.hidden = YES;
    }else if (searchBar.text.length > 100) {
        searchBar.text = [searchBar.text substringToIndex:100];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.converView.hidden = NO;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.converView.hidden = YES;
}

-(UIView *)notSearch{
    if (!_notSearch) {
        CGFloat imageViewWidth = RC_SCREEN_WIDTH - 150;
        CGFloat labelHeight = 30;
        _notSearch = [[UIView alloc]initWithFrame:CGRectMake((RC_SCREEN_WIDTH - imageViewWidth) * 0.5 - 10,150, imageViewWidth, imageViewWidth + labelHeight + 10)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewWidth)];
        imageView.image = [UIImage RC_BundleImgName:@"RCD_Search_NotResult"];
//        _notSearch.center = self.view.center;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageViewWidth + 10, imageViewWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"搜索无结果";
        
        [_notSearch addSubview:imageView];
        [_notSearch addSubview:label];
        _notSearch.hidden = YES;
        [self.tableView addSubview:_notSearch];
    }
    return _notSearch;
}
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        //        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"按手机号/姓名/公司名称搜索好友";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.backgroundColor = [UIColor whiteColor];
        [_searchBar setBarTintColor:[UIColor blackColor]];
        [_searchBar RC_setSearchTextFieldBackgroundColor:[UIColor trzx_BackGroundColor]];
        [_searchBar RC_setSearchCancelButtonTitle:@"取消" titleColor:[UIColor trzx_YellowColor] titleFont:nil];
//        [_searchBar setImage:[UIImage RC_BundleImgName:@"RCDSubscription_SearchBar_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UIView *backView = [UIView RC_viewWithColor:[UIColor whiteColor]];
        
        [self.view addSubview:backView];
        [backView addSubview:_searchBar];
        
        UIView *separatorView = [UIView RC_viewWithColor:[UIColor trzx_LineColor]];
        [backView addSubview:separatorView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusBackView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.offset(44);
        }];
        
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(60);
            make.top.equalTo(self.statusBackView.mas_bottom);
            make.right.equalTo(self.view);
            make.height.offset(44);
        }];
        
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_bottom);
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.height.offset(1);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 5, 60, 25);
        UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage RC_BundleImgName:@"RCDGoBack"]];
        backImg.frame = CGRectMake(10, 9, 10, 16);
        [backBtn addSubview:backImg];
        UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(22, 6, 85, 22)];
        backText.text = @"返回";
        backText.font = [UIFont systemFontOfSize:16];//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
        [backText setTextColor:[UIColor trzx_TextColor]];
        [backBtn addSubview:backText];
        [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:backBtn];
        
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.view.backgroundColor = _tableView.backgroundColor = [UIColor trzx_BackGroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBar.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
        [_tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
        
        _tableView.mj_footer = [TRZXGifFooter footerWithRefreshingBlock:^{
            self.pageNo++;
            if(self.pageNo > self.totalPage){
                [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }else{
                [[RCDHttpTool shareInstance] searchFriendListByName:self.searchText pageNo:self.pageNo complete:^(NSMutableArray *result, NSUInteger totalPage, NSUInteger pageNo) {
                    [_searchResult addObjectsFromArray:result];
                    [_tableView reloadData];
                    if (result.count >= 15) {
                        [_tableView.mj_footer endRefreshing];
                    }else{
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }];
            }
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

-(UIView *)converView{
    if (!_converView) {
        _converView = [UIView RC_viewWithColor:[UIColor clearColor]];
        [self.view addSubview:_converView];
        [_converView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.right.equalTo(self.view);
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(converViewDidClick:)];
        [_converView addGestureRecognizer:tap];
    }
    return _converView;
}

- (void)converViewDidClick:(UITapGestureRecognizer *)tap{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    _converView.hidden = YES;
}

@end
