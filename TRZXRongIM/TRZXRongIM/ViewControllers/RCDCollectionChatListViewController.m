//
//  RCDCollectionChatListViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/16.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDCollectionChatListViewController.h"
#import "RCDPublicServiceChatViewController.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDAddFriendCell.h"
#import "RCDCollectionChatListCell.h"
#import "RCDCommonDefine.h"

@interface RCDCollectionChatListViewController ()<UISearchBarDelegate>

@property(nonatomic, strong) NSArray *datas;

@property(nonatomic, strong) NSArray *profiles;

@property(nonatomic, strong) UIView *notSearch;

@property(nonatomic, strong) NSMutableArray *searchResult;

@end

@implementation RCDCollectionChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    self.title = @"订阅消息";
    
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:@"RCDSearchResultTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //背景颜色
    self.tableView.backgroundColor = self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    self.searchBar.tintColor = [UIColor trzx_TitleColor];
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    self.searchBar.delegate = self;
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
    self.searchViewController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *array = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE)]];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
    NSMutableArray *profileArrays = [NSMutableArray arrayWithCapacity:array.count];
    for (RCConversation *model in array) {
        [temp addObject:[[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:model extend:nil]];
        RCPublicServiceProfile *profile = [[RCIMClient sharedRCIMClient] getPublicServiceProfile:RC_PUBLIC_SERVICE publicServiceId:model.targetId];
        [profileArrays addObject:profile];
    }
    self.profiles = [NSMutableArray arrayWithArray:profileArrays];
    self.datas = [NSMutableArray arrayWithArray:temp];
    [self.tableView reloadData];
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
//        RCConversationModel *model = (RCConversationModel *)self.searchResult;
        RCPublicServiceProfile *profile = self.searchResult[indexPath.row];

        cell.lblName.text = profile.name;
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:profile.portraitUrl]];
        return cell;
    }
    
    RCDCollectionChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDCollectionChatListCell"];
    if (!cell) {
        cell = [[RCDCollectionChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDCollectionChatListCell"];
    }
    RCConversationModel *model = self.datas[indexPath.row];
    RCPublicServiceProfile *profile = self.profiles[indexPath.row];
    cell.titleLabel.text = profile.name;
    if([model.lastestMessage isKindOfClass:[RCTextMessage class]]){
        RCTextMessage *textMessage = (RCTextMessage *)model.lastestMessage;
        cell.contentLabel.text = textMessage.content.length?textMessage.content:@"";
    }else if([model.lastestMessage isKindOfClass:[RCPublicServiceRichContentMessage class]]){
        cell.contentLabel.text = ((RCPublicServiceRichContentMessage *)model.lastestMessage).richConent.title;
    }else if([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
        cell.contentLabel.text = @"[图片]";
    }else if([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
        cell.contentLabel.text = @"[语音消息]";
    }
    
    [cell setUnreadCount:[[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PUBLICSERVICE | ConversationType_APPSERVICE targetId:model.targetId]];
    
    if(model.receivedTime){
        cell.timeLabel.text = [RCKitUtility ConvertMessageTime:model.receivedTime / 1000];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:profile.portraitUrl]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;
    return 65;
}

#pragma mark - Help Method
#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCConversationModel *model = (RCConversationModel *)self.datas[indexPath.row];
    //进入订阅刊
    RCDPublicServiceChatViewController *serviceChatVC = [[RCDPublicServiceChatViewController alloc] init];
    serviceChatVC.targetId = model.targetId;
    serviceChatVC.title = model.conversationTitle;
    serviceChatVC.conversationType = ConversationType_PUBLICSERVICE;
    [self.navigationController pushViewController:serviceChatVC animated:YES];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchResult removeAllObjects];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.searchResult removeAllObjects];
    
    for (UIView *subView in self.searchViewController.searchResultsTableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label = (UILabel *)subView;
            label.text = @"";
        }
    }
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
        for (RCPublicServiceProfile *model in self.profiles) {
            NSString *pyResult = [model.name RC_isInputRuleZhongWen]?model.name:[model.name RC_hanZiToPinYin];
            NSString *searchTextResult = [searchBar.text RC_isInputRuleZhongWen]?searchBar.text:[searchBar.text RC_hanZiToPinYin];
            if(![self.searchResult containsObject:model] &&
               [pyResult containsString:searchTextResult]){
                [self.searchResult addObject:model];
            }
        }
        if(self.searchResult.count){
            self.notSearch.hidden = YES;
        }else{
            self.notSearch.hidden = NO;
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

-(NSMutableArray *)searchResult{
    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
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
        [self.tableView addSubview:_notSearch];
    }
    return _notSearch;
}
@end
