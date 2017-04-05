//
//  RCDSendSelectedAddressViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/19.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSendSelectedAddressViewController.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDUserInfo.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"
#import "RCDRCIMDataSource.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDSendSelectedCreateNewChatCell.h"
#import "RCDBusinessCardMessage.h"
#import "RCDSelectedSendView.h"
#import "RCDCollectionMessage.h"
#import "RCDGroupChatViewController.h"
#import "RCDPublicMessage.h"
#import "RCDGroupInfo.h"
#import "RCDCommonDefine.h"


@interface RCDSendSelectedAddressViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate>

//#字符索引对应的user object
@property (nonatomic,strong) NSMutableArray *tempOtherArr;
@property (nonatomic,strong) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) RCDGroupInfo *group;
@property (strong, nonatomic) UIView *notSearch;

@end

@implementation RCDSendSelectedAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor trzx_TextColor];
    [self getAllData];
    [self setNavigationColor];
    [self createDatas];
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
    
    //背景颜色
    self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    self.searchBar.tintColor = [UIColor trzx_TitleColor];
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
    [self.searchBar setContentMode:UIViewContentModeLeft];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchViewController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    if(self.OSMessage){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if(self.callBackUserInfo){
            self.callBackUserInfo(nil);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)setNavigationColor{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    if (self.OSMessage) {
        self.title = @"选择联系人";
    }
}

/**
 *  initial data
 */
-(void) getAllData{
    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
}

/**
 *  创建数据
 */
-(void)createDatas{
    _allFriends = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
    if(self.OSMessage){
        _friends = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance]getAllFriends]];
        if (_friends==nil||_friends.count<1) {
            [RCDDataSource syncFriendList:^(NSMutableArray * result) {
                _friends=result;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    _allFriends = [self sortedArrayWithPinYinDic:_friends];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                });
            }];
        }else{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _allFriends = [self sortedArrayWithPinYinDic:_friends];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
    }else if(self.conversationType == ConversationType_GROUP){
        [[RCDHttpTool shareInstance] getGroupByID:self.conversationTargetId successCompletion:^(RCDGroupInfo *group) {
            self.group = group;
            //@功能取消自己
            NSMutableArray *temp = [NSMutableArray array];
            for (RCUserInfo *userInfo in group.users) {
                if(![userInfo.userId isEqualToString:[Login curLoginUser].userId]){
                    [temp addObject:userInfo];
                }
            }
            _friends= [NSMutableArray arrayWithArray:temp];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _allFriends = [self sortedArrayWithPinYinDic:_friends];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }];
    }
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        
        RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDSearchResultTableViewCell"];
        if (!cell) {
            cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDSearchResultTableViewCell"];
        }
        RCDUserInfo *user =_searchResult[indexPath.row];
        if(user){
            cell.user = user;
        }
        return cell;
    }


    if (indexPath.section == 0 && (self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId])) {
        RCDSendSelectedCreateNewChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDSendSelectedCreateNewChatCell"];
        if(!cell){
            cell = [[RCDSendSelectedCreateNewChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDSendSelectedCreateNewChatCell"];
        }
        if([self.group.adminId isEqualToString:[Login curLoginUser].userId]){
            cell.promptLabel.text = @"所有人";
        }else{
            cell.promptLabel.text = @"选择群聊";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddressBookCell"];
//    cell.badgeNumberLabel.hidden = YES;
//    cell.backgroundColor = [UIColor white];
    
    if (_allKeys.count == 0 || _allFriends.count == 0) {
        return cell;
    }

    NSString *key = [_allKeys objectAtIndex:self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId]?indexPath.section - 1:indexPath.section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    RCDUserInfo *user = arrayForKey[indexPath.row];
    if(user){
        cell.user = user;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0 && (self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId])){
        return 0;
    }
    
    NSString *key = [_allKeys objectAtIndex:self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId]?section - 1:section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    if (!arrayForKey.count) {
        return 0;
    }
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;

    
    if(section == 0 && (self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId])){
        return 1;
    }
    
    NSString *key = [_allKeys objectAtIndex:self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId]?section - 1:section];
    
    NSArray *arr = [_allFriends objectForKey:key];
    
    return [arr count];
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView)return 1;
    
    return self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId]?[_allKeys count] + 1:[_allKeys count];
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && (self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId] )) {
        return nil;
    }
    
    NSString *key = [_allKeys objectAtIndex:self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId]?section - 1 : section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    if (!arrayForKey.count) {
        return nil;
    }
    UILabel *label = [[UILabel alloc]init];
    if (_allKeys.count)label.text = [NSString stringWithFormat:@"  %@",key];
    label.backgroundColor = [UIColor trzx_BackGroundColor];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;
    return 60.f;//原来: 65
}

//pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        return nil;
    }
    return _friends.count?_allKeys:nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView) {
        return nil;
    }

    if (_allKeys.count == 0 || ((self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId]) && section == 0)) {
        return nil;
    }

    NSString *key = [_allKeys objectAtIndex:self.OSMessage || [self.group.adminId isEqualToString:[Login curLoginUser].userId] ? section - 1 : section];
    return key;
}

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        if (self.searchResult.count) {
            if ([self.searchBar isFirstResponder]) {
                [self.searchBar resignFirstResponder];
            }
            RCDUserInfo *user = self.searchResult[indexPath.row];
            if(self.OSMessage){
                [self sendMessageToUserInfo:user];
            }else{
                if(self.callBackUserInfo){
                    self.callBackUserInfo(@[user]);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }else if(self.OSMessage){
        if(indexPath.section == 0){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            RCDGroupChatViewController *groupChatVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDGroupChatViewController"];
            groupChatVC.OSMessage = self.OSMessage;
            [self.navigationController pushViewController:groupChatVC animated:YES];
            return ;
        }
        
        NSString *key = [_allKeys objectAtIndex:indexPath.section - 1];
        NSArray *arrayForKey = [_allFriends objectForKey:key];
        RCDUserInfo *user = arrayForKey[indexPath.row];
        [self sendMessageToUserInfo:user];
    }else{

        if ([self.group.adminId isEqualToString:[Login curLoginUser].userId]) {
            if(indexPath.section == 0){
                if(self.callBackUserInfo){
                    self.callBackUserInfo(_friends);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
        
        NSString *key = [_allKeys objectAtIndex:[self.group.adminId isEqualToString:[Login curLoginUser].userId]?indexPath.section - 1:indexPath.section];
        NSArray *arrayForKey = [_allFriends objectForKey:key];
        RCDUserInfo *user = arrayForKey[indexPath.row];
        if(self.callBackUserInfo){
            self.callBackUserInfo(@[user]);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private Method
-(void)sendMessageToUserInfo:(RCDUserInfo *)user{
    
    RCMessageContent *message;
    if ([self.OSMessage.type isEqualToString:@"userHome"]) {
            RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:self.OSMessage.objId];
            message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:userInfo.name portrait:userInfo.portraitUri userId:userInfo.userId];
    }else{
        if([self.OSMessage.type isEqualToString:@"public"]){
            message = [RCDPublicMessage messageWithName:self.OSMessage.title mid:self.OSMessage.objId photo:self.OSMessage.headURL introduction:self.OSMessage.desc];
        }else{
            message = [RCDCollectionMessage messageWithTitle:self.OSMessage.title content:self.OSMessage.desc picture:self.OSMessage.headURL collectionType:self.OSMessage.type mid:self.OSMessage.objId];
        }
    }
    [RCDSelectedSendView selectedSendView:user messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:user.userId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                if (leaveString.length) {
                    RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:user.userId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                        
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                
            }];
        }];
    }];
}

#pragma mark - Help Method
#pragma mark - 拼音排序

/**
 *  根据转换拼音后的字典排序
 *
 *  @param friends 转换后的字典
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
        for (RCDUserInfo *user in friends) {
            
            NSString *pyResult = [user.name RC_hanZiToPinYin];
            
            NSString *firstLetter = [[pyResult substringToIndex:1] uppercaseString];
            if ([firstLetter isEqualToString:key]){
                [tempArr addObject:user];
            }
            
            if(isReturn) continue;
            char c = [pyResult characterAtIndex:0];
            if (isalpha(c) == 0) {
                [_tempOtherArr addObject:user];
            }
        }
//        if(![tempArr count]) continue;
        [returnDic setObject:tempArr forKey:key];
        
    }
//    if([_tempOtherArr count])
        [returnDic setObject:_tempOtherArr forKey:@"#"];
    
    
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

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
    self.notSearch.hidden = YES;
}

/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    for (UIView *subView in self.searchViewController.searchResultsTableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label = (UILabel *)subView;
            label.text = @"";
        }
    }
    
    [self.searchResult removeAllObjects];
    
    if ([searchText length]) {
        
        [_friends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RCDUserInfo *userInfo = obj;
            
            NSString *pyResult = [searchBar.text RC_isInputRuleZhongWen]?userInfo.name:[userInfo.name RC_hanZiToPinYin];
            
            NSString *searchTextResult = [searchBar.text RC_isInputRuleZhongWen]?searchBar.text:[searchBar.text RC_hanZiToPinYin];
            
            if(![self.searchResult containsObject:userInfo] &&
               [pyResult containsString:searchTextResult]){
                [self.searchResult addObject:userInfo];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.searchViewController.searchResultsTableView.delegate = self;
            self.searchViewController.searchResultsTableView.dataSource = self;
            [self.searchViewController.searchResultsTableView reloadData];
            if(self.searchResult.count){
                self.notSearch.hidden = YES;
            }else{
                self.notSearch.hidden = NO;
            }
        });
    }else{
        self.notSearch.hidden = YES;
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
        //        _notSearch.center = self.view.center;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageViewWidth + 10, imageViewWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"搜索无结果";
        
        [_notSearch addSubview:imageView];
        [_notSearch addSubview:label];
        _notSearch.hidden = YES;
        [self.searchViewController.searchResultsTableView addSubview:_notSearch];
    }
    return _notSearch;
}
@end
