//
//  RCDSendSelectedViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSendSelectedViewController.h"
#import "RCDDscussionHeadManager.h"
#import "RCDUIImageView.h"
#import "RCDataBaseManager.h"
#import "RCDUserInfo.h"
#import "RCDSelectedSendView.h"
#import "RCDCollectionMessage.h"
#import "OpenShare.h"
#import "RCDGroupInfo.h"
#import "RCDAddFriendCell.h"
#import "RCDSendSelectedCreateNewChatCell.h"
#import "RCDAddressBookViewController.h"
#import "RCDSendSelectedAddressViewController.h"
#import "RCDPublicMessage.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDBusinessCardMessage.h"
#import "RCDHttpTool.h"
#import "RCDCommonDefine.h"

@interface RCDSendSelectedViewController ()<UISearchBarDelegate>

@property(nonatomic, strong)RCDDscussionHeadManager *dscussionHeadManager;

@property(nonatomic, strong)NSMutableArray *results;

@property (nonatomic,strong) NSMutableArray *friends;

@property (strong, nonatomic) NSMutableArray *searchResult;

@property (strong, nonatomic) UIView *notSearch;

@end

@implementation RCDSendSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor trzx_TextColor];
//    [self getAllData];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_barButtonWithTitle:@"关闭" color:[UIColor trzx_TitleColor] imageName:nil target:self action:@selector(leftBarButtonItemPressed:)];
//    [self createDatas];
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
    
    //背景颜色
    
    self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    self.searchBar.tintColor = [UIColor trzx_TitleColor];
//    self.searchBar.delegate = self;
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
    self.searchViewController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *array = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
    for (RCConversation *model  in array) {
        [temp addObject:[[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:model extend:nil]];
    }
    _friends = [NSMutableArray arrayWithArray:temp];
    [self.tableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        
        RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDSearchResultTableViewCell"];
        if (!cell) {
            cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDSearchResultTableViewCell"];
        }
        RCConversationModel *model = _searchResult[indexPath.row];
        
        //    [cell.imgvAva mas_updateConstraints:^(MASConstraintMaker *make) {
        //       make.size.mas_equalTo(CGSizeMake(33, 33));
        //    }];
        //    cell.addButton.hidden = YES;
        if(model.conversationType == ConversationType_PRIVATE){
            RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:model.targetId];
            cell.lblName.text = userInfo.name;
            [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]];
        }
        if (model.conversationType == ConversationType_GROUP) {
            if (![cell isMemberOfClass:[RCDUIImageView class]]) {
                [self.dscussionHeadManager kipo_settingHeader:cell.ivAva titleLabel:cell.lblName model:model];
            }
        }
        return cell;
    }

    if (indexPath.section == 0) {
        RCDSendSelectedCreateNewChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDSendSelectedCreateNewChatCell"];
        if (!cell) {
            cell = [[RCDSendSelectedCreateNewChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDSendSelectedCreateNewChatCell"];
        }
        return cell;
    }
    
    RCDAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddFriendCell"];
    if(!cell){
        cell = [[RCDAddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDAddFriendCell"];
    }
    
    RCConversationModel *model = _friends[indexPath.row];
    
    [cell.headImage mas_updateConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    cell.addButton.hidden = YES;
    
    if(model.conversationType == ConversationType_PRIVATE){
        RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:model.targetId];
        if(userInfo){
            cell.nameLabel.text = userInfo.name;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]];
        }else{
            [[RCDHttpTool shareInstance] getUserInfoByUserID:model.targetId completion:^(RCDUserInfo *user) {
//                cell.nameLabel.text = userInfo.name;
//                [cell.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]];
                [self.tableView reloadData];
            }];
        }
    }
    if (model.conversationType == ConversationType_GROUP) {
        if (![cell isMemberOfClass:[RCDUIImageView class]]) {
           [self.dscussionHeadManager kipo_settingHeader:cell.headImage titleLabel:cell.nameLabel model:model];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || tableView == self.searchViewController.searchResultsTableView) {
        return 0;
    }
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;
    
    if(section == 0){
        return 1;
    }
    
    return _friends.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView)return 1;
    
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || tableView == self.searchViewController.searchResultsTableView) {
        return nil;
    }
    
    UILabel *label = [UILabel RC_labelWithTitle:@"    最近聊天" color:[UIColor trzx_TextColor] fontSize:13 aligment:NSTextAlignmentLeft];
    label.backgroundColor = [UIColor trzx_BackGroundColor];
    label.frame = CGRectMake(0, 0, RC_SCREEN_WIDTH, 30);
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;
    return 60.f;//原来: 65
}

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        RCConversationModel *model = [_searchResult objectAtIndex:indexPath.row];
        [self jumpViewControllerWithModel:model];
        return;
    }
    
    if (indexPath.section == 0) {
       //跳转个人聊天页面
       UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
       RCDSendSelectedAddressViewController *addressBookVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSendSelectedAddressViewController"];
       addressBookVC.OSMessage = self.OSMessage;
       [self.navigationController pushViewController:addressBookVC animated:YES];
       return;
    }
    
    RCConversationModel *model = [_friends objectAtIndex:indexPath.row];
    [self jumpViewControllerWithModel:model];
}

-(void)jumpViewControllerWithModel:(RCConversationModel *)model{

    switch (model.conversationType) {
        case ConversationType_PRIVATE:{
            RCDUserInfo *user = [[RCDataBaseManager shareInstance] getUserByUserId:model.targetId];
            RCMessageContent *message;
            if ([self.OSMessage.type isEqualToString:@"userHome"]) {
                RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:self.OSMessage.objId];
                message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:userInfo.name portrait:userInfo.portraitUri userId:userInfo.userId];
            }else if([self.OSMessage.type isEqualToString:@"public"]){
                message = [RCDPublicMessage messageWithName:self.OSMessage.title mid:self.OSMessage.objId photo:self.OSMessage.headURL introduction:self.OSMessage.desc];
            }else{
                message = [RCDCollectionMessage messageWithTitle:self.OSMessage.title content:self.OSMessage.desc picture:self.OSMessage.headURL collectionType:self.OSMessage.type mid:self.OSMessage.objId];
            }
            [RCDSelectedSendView selectedSendView:user messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:model.targetId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
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
        }break;
        case ConversationType_GROUP:{
            RCDGroupInfo *group = [[RCDataBaseManager shareInstance] getGroupByGroupId:model.targetId];
            
            RCMessageContent *message;
            if ([self.OSMessage.type isEqualToString:@"userHome"]) {
                RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:self.OSMessage.objId];
                message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:userInfo.name portrait:userInfo.portraitUri userId:userInfo.userId];
            }else if([self.OSMessage.type isEqualToString:@"public"]){
                message = [RCDPublicMessage messageWithName:self.OSMessage.title mid:self.OSMessage.objId photo:self.OSMessage.headURL introduction:self.OSMessage.desc];
            }else{
                message = [RCDCollectionMessage messageWithTitle:self.OSMessage.title content:self.OSMessage.desc picture:self.OSMessage.headURL collectionType:self.OSMessage.type mid:self.OSMessage.objId];
            }
            [RCDSelectedSendView selectedSendViewToGroupInfo:group messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:model.targetId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                        if (leaveString.length) {
                            RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:model.targetId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                                
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
        }break;
            default:
            break;
    }
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
        
        for (RCConversationModel *model  in _friends) {
            
            NSString *searchStr;
            if (model.conversationType == ConversationType_PRIVATE) {
                RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:model.targetId];
                searchStr = userInfo.name;
            }else if(model.conversationType == ConversationType_GROUP){
                RCDGroupInfo *groupInfo = [[RCDataBaseManager shareInstance] getGroupByGroupId:model.targetId];
                searchStr = groupInfo.name;
            }
            
            NSString *pyResult = [searchText RC_isInputRuleZhongWen]?searchStr:[searchStr RC_hanZiToPinYin];
            
            NSString *searchTextResult = [searchText RC_isInputRuleZhongWen]?searchText:[searchText RC_hanZiToPinYin];
            
            if(![self.searchResult containsObject:model] &&
               [pyResult containsString:searchTextResult]){
                [self.searchResult addObject:model];
            }
        }
        
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
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}

-(RCDDscussionHeadManager *)dscussionHeadManager{
    if (!_dscussionHeadManager) {
        _dscussionHeadManager = [[RCDDscussionHeadManager alloc]init];
    }
    return _dscussionHeadManager;
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

@end
