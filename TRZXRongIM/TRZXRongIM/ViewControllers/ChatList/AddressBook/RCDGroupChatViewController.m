//
//  RCDGroupChatViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/5.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDGroupChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDSearchFriendViewController.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDGroupInfo.h"
#import "RCDDscussionHeadManager.h"
#import "RCDChatViewController.h"
#import "RCDBusinessCardMessage.h"
#import "RCDSelectedSendView.h"
#import "RCDataBaseManager.h"
#import "RCDCollectionMessage.h"
#import "RCDPublicMessage.h"

#import "RCDCommonDefine.h"


@interface RCDGroupChatFooterView : UIView

-(void)setGroupChatNumber:(NSInteger)number;

@property(nonatomic, strong) UILabel *promptLabel;

@property(nonatomic, strong) UIView *separatorView;

@end

@implementation RCDGroupChatFooterView
-(UIView *)separatorView{
    if(!_separatorView){
        _separatorView = [UIView RC_viewWithColor:[UIColor colorWithRed:232/255.0 green:231/255.0 blue:232/255.0 alpha:1]];
        [self addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.offset(1);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
    }
    return _separatorView;
}
-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel RC_labelWithTitle:nil color:[UIColor trzx_TextColor] fontSize:16];
        [self addSubview:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _promptLabel;
}

-(void)setGroupChatNumber:(NSInteger)number{
    [self separatorView];
    self.promptLabel.text = [NSString stringWithFormat:@"%ld个群聊",(long)number];
}

@end


static NSString *const RCDGroupChatViewCellKey = @"RCDGroupChatViewCellKey";
@interface RCDGroupChatViewController ()<UISearchBarDelegate>

@property(nonatomic, strong) RCDGroupChatFooterView *footerView;

@property(nonatomic, strong) NSMutableArray *groups;

@property(nonatomic, strong) NSMutableArray *searchResult;

@property (nonatomic,strong) RCDDscussionHeadManager *headManager;

@property (nonatomic, strong) UILabel *notListView;

@end

@implementation RCDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    self.title = @"群聊";
    
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //背景颜色
    self.tableView.backgroundColor = self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    self.searchBar.tintColor = [UIColor trzx_TitleColor];
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    self.searchBar.delegate = self;
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData{
    [[RCDHttpTool shareInstance] getAllGroupsWithCompletion:^(NSMutableArray *result) {
        self.groups = result;
        
        if (result.count) {
            if (self.OSMessage) {
                [self.searchBar removeFromSuperview];
//                self.tableView.y -= 44;
//                self.tableView.height += 44;
            }
            
            self.footerView.hidden = NO;
            [self.footerView setGroupChatNumber:result.count];            
            self.notListView.hidden = YES;
            
        }else{
            //            if(!self.OSMessage){
            self.notListView.hidden = NO;
            self.footerView.hidden = YES;
            //            }
        }
        [self.tableView reloadData];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        
        RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDSearchResultTableViewCell"];
        if (!cell) {
            cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDSearchResultTableViewCell"];
        }
        RCDGroupInfo *groupInfo = self.searchResult[indexPath.row];
//        if(user){
//            cell.user = user;
//        }
        cell.lblName.text = groupInfo.name;
        cell.lblName.numberOfLines = 1;
        [self.headManager kipo_setGroupListHeader:cell.ivAva groupInfo:groupInfo isSave:NO];
        return cell;
    }
    
    RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAddressBookCell"];
//    [tableView dequeueReusableCellWithIdentifier:RCDGroupChatViewCellKey forIndexPath:indexPath];
    RCDGroupInfo *groupInfo = self.groups[indexPath.row];
    cell.lblName.text = groupInfo.name;
    cell.lblName.width = 20;
    cell.lblName.numberOfLines = 1;
    cell.imgvAva.size = CGSizeMake(33, 33);
    [self.headManager kipo_setGroupListHeader:cell.imgvAva groupInfo:groupInfo isSave:NO];
    
//    if(user){
//        cell.user = user;
//    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;
    
    return self.groups.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;
    return 50.f;//原来: 65
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.OSMessage) {
        return NO;
    }
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除吗?" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
            if ([indexNumber intValue] == 1) {
                RCDGroupInfo *groupInfo = self.groups[indexPath.row];
                [[RCDHttpTool shareInstance] saveGroupToList:groupInfo.groupId saveOrRemove:NO complete:^(BOOL result) {
                    [self loadData];
                }];
            }
        }];
    }
}


#pragma mark - Help Method
#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RCDGroupInfo *groupInfo;
    if(tableView == self.searchViewController.searchResultsTableView){
        groupInfo = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        groupInfo = [self.groups objectAtIndex:indexPath.row];
    }
    
    if (self.OSMessage) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSData *imageData;
        if([cell isKindOfClass:[RCDAddressBookTableViewCell class]]){
            RCDAddressBookTableViewCell *cell1 = (RCDAddressBookTableViewCell *)cell;
            imageData = [cell1.imgvAva.image RC_dataCompress];
        }else if([cell isKindOfClass:[RCDSearchResultTableViewCell class]]){
            RCDSearchResultTableViewCell *cell1 = (RCDSearchResultTableViewCell *)cell;
            imageData = [cell1.ivAva.image RC_dataCompress];
        }
        
        if(!imageData){
            imageData = [[RCDataBaseManager shareInstance] getGroupByGroupId:groupInfo.mid].groupHeadData;
        }
        groupInfo.groupHeadData = imageData;
        [self sendMessageToGroupInfo:groupInfo];
        return ;
    }
    
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    
    _conversationVC.conversationType = ConversationType_GROUP;
    //                _conversationVC.userName = model.conversationTitle;
    RCConversation *conversation = [[RCConversation alloc] init];
    conversation.targetId = _conversationVC.targetId = groupInfo.mid;
    conversation.conversationTitle = _conversationVC.title = groupInfo.inName;
    RCConversationModel *conversationModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:conversation extend:nil];
    _conversationVC.conversation = conversationModel;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
//    _conversationVC.closeInputBool = YES;
    //            _conversationVC.originalVC = origanalViewControll;
    
    [self.navigationController pushViewController:_conversationVC animated:YES];
}

-(void)sendMessageToGroupInfo:(RCDGroupInfo *)groupInfo{

    if ([self.OSMessage.type isEqualToString:@"userHome"]) {
        RCUserInfo *user = [[RCDataBaseManager shareInstance] getUserByUserId:self.OSMessage.objId];
        RCDBusinessCardMessage *message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:user.name portrait:user.portraitUri userId:user.userId];
        [RCDSelectedSendView selectedSendViewToGroupInfo:groupInfo messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:groupInfo.mid content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                    if (leaveString.length) {
                        RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                        [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:groupInfo.mid content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                            
                        } error:^(RCErrorCode nErrorCode, long messageId) {
                            
                        }];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                            // 融云提示
//                        //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                    });
                } error:^(RCErrorCode nErrorCode, long messageId) {
                    
                }];
            }];
        }];

    }else{
        RCMessageContent *collectionMessage;
        if([self.OSMessage.type isEqualToString:@"public"]){
            collectionMessage = [RCDPublicMessage messageWithName:self.OSMessage.title mid:self.OSMessage.objId photo:self.OSMessage.headURL introduction:self.OSMessage.desc];
        }else{
            collectionMessage = [RCDCollectionMessage messageWithTitle:self.OSMessage.title content:self.OSMessage.desc picture:self.OSMessage.headURL collectionType:self.OSMessage.type mid:self.OSMessage.objId];
        }
        [RCDSelectedSendView selectedSendViewToGroupInfo:groupInfo messageContent:collectionMessage sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:groupInfo.mid content:collectionMessage pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                    if (leaveString.length) {
                        RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                        [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:groupInfo.mid content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                            
                        } error:^(RCErrorCode nErrorCode, long messageId) {
                            
                        }];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 融云提示
//                        //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                    });
                } error:^(RCErrorCode nErrorCode, long messageId) {
                    
                }];
            }];
        }];
    }
}


#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
}

/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
    
    if ([searchBar.text length]) {
        //搜索群成员
        for (RCDGroupInfo *groupInfo in self.groups) {
            
            NSString *pyResult = [groupInfo.name RC_isInputRuleZhongWen]?groupInfo.name:[groupInfo.name RC_hanZiToPinYin];
            
            NSString *searchTextResult = [searchBar.text RC_isInputRuleZhongWen]?searchBar.text:[searchBar.text RC_hanZiToPinYin];
            
            if(![self.searchResult containsObject:groupInfo] &&
               [pyResult containsString:searchTextResult]){
                [self.searchResult addObject:groupInfo];
            }
        }
        self.searchViewController.searchResultsDataSource = self;
        self.searchViewController.searchResultsDelegate = self;
        [self.searchViewController.searchResultsTableView reloadData];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

#pragma mark - Properties
-(RCDDscussionHeadManager *)headManager{
    if (!_headManager) {
        _headManager = [[RCDDscussionHeadManager alloc] init];
    }
    return _headManager;
}
-(NSMutableArray *)searchResult{
    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}
-(RCDGroupChatFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[RCDGroupChatFooterView alloc] initWithFrame:CGRectMake(0, 0, RC_SCREEN_WIDTH, 60)];
        _footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = _footerView;
    }
    return _footerView;
}
-(UILabel *)notListView{
    if (!_notListView) {
        _notListView = [UILabel RC_labelWithTitle:@"你可以通过群聊中“保存到群聊”选项,将其保存到这里" color:[UIColor blackColor] fontSize:20];
        [self.view addSubview:_notListView];
        [_notListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(50);
            make.centerY.equalTo(self.view).offset(-100);
            make.width.offset(RC_SCREEN_WIDTH - 100);
        }];
    }
    return _notListView;
}
@end
