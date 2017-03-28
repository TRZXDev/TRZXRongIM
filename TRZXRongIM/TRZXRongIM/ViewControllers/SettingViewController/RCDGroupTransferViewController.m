//
//  RCDGroupTransferViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/12.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDGroupTransferViewController.h"
#import "RCDSearchFriendViewController.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDUserInfo.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDGroupInfo.h"
#import "RCDHttpTool.h"
#import "RCDCommonDefine.h"

@interface RCDGroupTransferViewController ()

@property(nonatomic, strong) NSMutableArray *searchResult;

@property(nonatomic, strong) NSMutableArray *groupMembers;

@end

@implementation RCDGroupTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    self.title = self.groupInfo.inName;
    
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
    //背景颜色
    self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    self.searchBar.tintColor = [UIColor trzx_TitleColor];
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    
    for (RCUserInfo *user in self.groupInfo.users) {
        if (![user.userId isEqualToString:[Login curLoginUser].userId]) {
            [self.groupMembers addObject:user];
        }
    }
    [self.tableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    if (self.refresh) {
        self.refresh();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView == self.searchViewController.searchResultsTableView) {
    
        RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDSearchResultTableViewCell"];
        if (!cell) {
            cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDSearchResultTableViewCell"];
        }
        RCDUserInfo *user = self.groupMembers[indexPath.row];
        if(user){
            cell.user = user;
        }
        return cell;
//    }
    
//    RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddressBookCell"];
//
//    cell.badgeNumberLabel.hidden = YES;
//    
//    RCDUserInfo *user = self.groupMembers[indexPath.row];
//    
//    if(user){
//        cell.user = user;
//    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;
    
    return self.groupMembers.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;

    return 60.f;//原来: 65
}

#pragma mark - Help Method
#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //转让群主
    RCDUserInfo *userInfo;
    if(tableView == self.searchViewController.searchResultsTableView){
        userInfo = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        userInfo = [self.groupMembers objectAtIndex:indexPath.row];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定选择%@为新群主,你将自动放弃群主身份.",userInfo.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
//    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
//        
//        if ([indexNumber intValue] == 1) {
//            
//            EOWalletViewController *wallet = [[EOWalletViewController alloc]init];
//            wallet.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:wallet animated:YES];
//            
//        }
//        
//    }];
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
        if ([indexNumber intValue] == 1) {
            [[RCDHttpTool shareInstance] transferGroup:self.groupInfo.mid uId:userInfo.userId complete:^(BOOL result) {
                //转让成功
                [self leftBarButtonItemPressed:nil];
            }];
        }
    } ];

    

}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchResult removeAllObjects];
}
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
    
    if ([searchBar.text length]) {
        //搜索群成员
        for (RCDUserInfo *userInfo in self.groupMembers) {
            
            NSString *pyResult = [searchBar.text RC_isInputRuleZhongWen]?userInfo.name:[userInfo.name RC_hanZiToPinYin];
            
            NSString *searchTextResult = [searchBar.text RC_isInputRuleZhongWen]?searchBar.text:[searchBar.text RC_hanZiToPinYin];
            
            if(![self.searchResult containsObject:userInfo] &&
               [pyResult containsString:searchTextResult]){
                [self.searchResult addObject:userInfo];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchViewController.searchResultsTableView reloadData];
        });
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

#pragma mark - Properties
-(NSMutableArray *)searchResult{
    if (!_searchResult) {
        _searchResult = [NSMutableArray new];
    }
    return _searchResult;
}

-(NSMutableArray *)groupMembers{
    if (!_groupMembers) {
        _groupMembers = [NSMutableArray array];
    }
    return _groupMembers;
}

@end
