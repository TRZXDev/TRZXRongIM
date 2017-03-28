//
//  RCDSubscriptionViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSubscriptionViewController.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDSearchFriendViewController.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDSubscriptionSearchViewController.h"
#import "RCDSubscriptionResultCell.h"
#import "RCDCommonDefine.h"
#import "RCDPublicServiceChatViewController.h"


@interface RCDSubscriptionViewController ()

//#字符索引对应的user object
@property (nonatomic,strong) NSMutableArray *tempOtherArr;
@property (nonatomic,strong) NSMutableArray *subscriptions;
@property (strong, nonatomic) NSMutableArray *searchResult;

@property (strong, nonatomic) UIView *notSearch;


@end

@implementation RCDSubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    [self setNavigationColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
    //背景颜色
    self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    
    self.searchBar.tintColor = [UIColor trzx_YellowColor];
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor trzx_TextColor];
    //Setting
    self.searchViewController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchViewController.searchResultsTableView.backgroundColor = [UIColor trzx_BackGroundColor];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - Action
-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(UIButton *)button{

    RCDSubscriptionSearchViewController *searchController = [[RCDSubscriptionSearchViewController alloc] init];
    [self.navigationController pushViewController:searchController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self createDatas];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)setNavigationColor{
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"RCDChatViewController_More" buttonRect:CGRectMake(0, 0, 60, 50) imageRect:CGRectMake(30, 2, 45, 45) Target:self action:@selector(rightBarButtonItemPressed:)];
    self.title = @"订阅刊";
}

//删除已选中用户
-(void) removeSelectedUsers:(NSArray *) selectedUsers{
//    for (RCPublicServiceProfile *user in selectedUsers) {
//        [_friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            RCPublicServiceProfile *userInfo = obj;
//            if ([user.userId isEqualToString:userInfo.userId]) {
//                [_friends removeObject:obj];
//            }
//        }];
//    }
}

/**
 *  创建数据
 */
-(void)createDatas{
    _allFriends = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
    _subscriptions = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getPublicServiceList]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _allFriends = [self sortedArrayWithPinYinDic:_subscriptions];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView reloadSectionIndexTitles];
            
        });
    });
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        
//        RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddressBookTableViewCellKey"];
//        if (!cell) {
//            cell = [[RCDAddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDAddressBookTableViewCellKey"];
//        }
        RCDAddressBookTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RCDAddressBookCell"];
        RCPublicServiceProfile *profile =_searchResult[indexPath.row];
        if(profile){
            cell.lblName.text = profile.name;
            [cell.imgvAva sd_setImageWithURL:[NSURL URLWithString:profile.portraitUrl]];
        }
        return cell;
    }
    
    RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddressBookCell"];
    cell.backgroundColor = [UIColor trzx_BackGroundColor];
    cell.badgeNumberLabel.hidden = YES;
    
    if (_allKeys.count == 0 || _allFriends.count == 0 ) {
        return cell;
    }
    NSString *key = [_allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    
    RCPublicServiceProfile *profile = arrayForKey[indexPath.row];
    
    if(profile){
        cell.lblName.text = profile.name;
        [cell.imgvAva sd_setImageWithURL:[NSURL URLWithString:profile.portraitUrl]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView) {
        if(self.searchResult.count){
            return 10;
        }else{
            return 0;
        }
    }
    NSString *key = [_allKeys objectAtIndex:section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    if (!arrayForKey.count) {
        return 0;
    }
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;
    
    NSString *key = [_allKeys objectAtIndex:section];
    
    NSArray *arr = [_allFriends objectForKey:key];
    
    return [arr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView)return 1;
    
    return [_allKeys count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView == self.searchViewController.searchResultsTableView){
        return nil;
    }
    
    UILabel *label = [[UILabel alloc]init];
    NSString *key = [_allKeys objectAtIndex:section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    if (!arrayForKey.count) {
        return nil;
    }
    if (_allKeys.count)label.text = [NSString stringWithFormat:@"  %@",key];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;
    return 65.f;//原来: 65
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return NO;
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"不再订阅";
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不再订阅" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
            if ([indexNumber intValue] == 1) {
                NSString *key = [_allKeys objectAtIndex:indexPath.section];
                NSArray *arrayForKey = [_allFriends objectForKey:key];
                RCPublicServiceProfile *profile = arrayForKey[indexPath.row];
                
                [[RCIMClient sharedRCIMClient] unsubscribePublicService:profile.publicServiceType publicServiceId:profile.publicServiceId success:^{
                   dispatch_async(dispatch_get_main_queue(), ^{
                       //                       [LCProgressHUD showSuccess:@"取消成功"]; //融云提示
                       [self createDatas];
                       
                   });
                } error:^(RCErrorCode status) {
                    
                }];
            }
        }];
    }
}

//pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        return nil;
    }
    return _subscriptions.count?_allKeys:nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (tableView == self.searchViewController.searchResultsTableView) {
//        return nil;
//    }
//    
//    if (_allKeys.count == 0 || section == 0) {
//        return nil;
//    }
//    NSString *key = [_allKeys objectAtIndex:section + 1];
//    return key;
//}

#pragma mark - Help Method
#pragma mark - 拼音排序

/**
 *  根据转换拼音后的字典排序
 *
 *  @param pinyinDic 转换后的字典
 *
 *  @return 对应排序的字典
 */
-(NSMutableDictionary *) sortedArrayWithPinYinDic:(NSArray *) friends{
    if(!friends) return nil;
    
    NSMutableDictionary *returnDic = [NSMutableDictionary new];
    _tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    
    for (NSString *key in _keys) {
        
        if ([_tempOtherArr count]) {
            isReturn = YES;
        }
        
        NSMutableArray *tempArr = [NSMutableArray new];
        for (RCPublicServiceProfile *profile in friends) {
            
            NSString *pyResult = [profile.name RC_hanZiToPinYin];
            
            NSString *firstLetter = [[pyResult substringToIndex:1] uppercaseString];
            if ([firstLetter isEqualToString:key]){
                [tempArr addObject:profile];
            }
            
            if(isReturn) continue;
            char c = [pyResult characterAtIndex:0];
            if (isalpha(c) == 0) {
                [_tempOtherArr addObject:profile];
            }
        }
//        if(![tempArr count]) continue;
        [returnDic setObject:tempArr forKey:key];
    }
    
//    if([_tempOtherArr count])
    [returnDic setObject:_tempOtherArr.count?_tempOtherArr:@[] forKey:@"#"];
    
    _allKeys = [[returnDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj2 isEqualToString:@"#"]) {
            return NSOrderedAscending;
        }
        if ([obj1 isEqualToString:@"#"]){
            return NSOrderedDescending;
        }
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return returnDic;
}

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCPublicServiceProfile *profile;
    if(self.searchViewController.searchResultsTableView == tableView){
        profile =self.searchResult[indexPath.row];
    }else{
        NSString *key = [_allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [_allFriends objectForKey:key];
        profile = arrayForKey[indexPath.row];
    }
    
    //跳转详情
    RCDPublicServiceChatViewController *serviceChatVC = [[RCDPublicServiceChatViewController alloc] init];
    serviceChatVC.targetId = profile.publicServiceId;
    serviceChatVC.title = profile.name;
    serviceChatVC.conversationType = ConversationType_PUBLICSERVICE;
    [self.navigationController pushViewController:serviceChatVC animated:YES];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
    searchBar.placeholder = @"搜索";
    self.notSearch.hidden = YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.placeholder = @"搜索订阅刊";
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    for (UIView *subView in self.searchViewController.searchResultsTableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label = (UILabel *)subView;
            label.text = @"";
        }
    }
    
    self.notSearch.hidden = YES;
}

/**
 当要点击键盘搜索按钮时调用
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
    
    if ([searchBar.text length]) {
        
        [_subscriptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RCPublicServiceProfile *userInfo = obj;
            
            NSString *pyResult = [searchBar.text RC_isInputRuleZhongWen]?userInfo.name:[userInfo.name RC_hanZiToPinYin];
            
            NSString *searchTextResult = [searchBar.text RC_isInputRuleZhongWen]?searchBar.text:[searchBar.text RC_hanZiToPinYin];
            
            if(![self.searchResult containsObject:userInfo] &&
               [pyResult containsString:searchTextResult]){
                [self.searchResult addObject:userInfo];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.searchResult.count) {
                self.notSearch.hidden = YES;
            }else{
                self.notSearch.hidden = NO;
            }
            self.searchViewController.searchResultsTableView.delegate = self;
            self.searchViewController.searchResultsTableView.dataSource = self;
            [self.searchViewController.searchResultsTableView reloadData];
        });
    }
}

#pragma mark - Properties
-(NSMutableArray *)searchResult{
    if (!_searchResult) {
        _searchResult = [NSMutableArray new];
    }
    return _searchResult;
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
        [self.searchViewController.searchResultsTableView addSubview:_notSearch];
        
        //        [_notSearch addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //            if([self.searchBar isFirstResponder])[self.searchBar resignFirstResponder];
        //        }]];
        
    }
    return _notSearch;
}

@end
