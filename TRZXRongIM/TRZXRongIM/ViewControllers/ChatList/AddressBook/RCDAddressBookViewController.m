//
//  RCDAddressBookViewController.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDAddressBookViewController.h"
#import "RCDRCIMDataSource.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDAddressBookTableViewCell.h"
#import "RCDHttpTool.h"
//#import "pinyin.h"
#import "RCDUserInfo.h"
#include <ctype.h>
#import "RCDPersonDetailViewController.h"
#import "RCDataBaseManager.h"
#import "RCDSearchFriendViewController.h"
//#import "PersonalModView.h"
//#import "PersonalModell.h"
#import "RCDAddFriendViewController.h"
#import "RCDSearchResultTableViewCell.h"
//#import "PersonalInformationVC.h"
#import "RCDSelectedSendView.h"
#import "RCDBusinessCardMessage.h"
#import "RCDAddFriendListViewController.h"
#import "UISearchBar+RCExtension.h"
#import "RCDGroupChatViewController.h"
#import "OpenShare.h"
#import "RCDSelectedSendView.h"
#import "RCDCollectionMessage.h"
//#import "ConsultingDetailsViewController.h"
#import "RCDGroupInfo.h"
#import "RCDChatViewController.h"
#import "RCDPublicMessage.h"
#import "RCDDscussionHeadManager.h"
#import "RCDCommonDefine.h"
#import "UIBarButtonItem+RCExtension.h"
#import "UILabel+RCExtension.h"
#import <ReactiveCocoa/UIAlertView+RACSignalSupport.h>
#import <ReactiveCocoa/RACSignal.h>
//#import "RACReturnSignal.h"
#import "NSString+RCExtension.h"
#import <TRZXKit/UIColor+APP.h>
#import <MJExtension/MJExtension.h>

static NSString *searchResultCellWithIdentifier = @"RCDSearchResultTableViewCell";
static NSString *reusableCellWithIdentifier = @"RCDAddressBookCell";

@interface RCDAddressBookViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate>

//#字符索引对应的user object
@property (nonatomic,strong) NSMutableArray *tempOtherArr;

@property (strong, nonatomic) NSMutableArray *searchResult;

@property (strong, nonatomic) UIView *notSearch;

@property (nonatomic, strong)RCDDscussionHeadManager *dscussionHeadManager;

@end

@implementation RCDAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor trzx_TextColor];
    [self getAllData];
    [self setNavigationColor];
    
    [self.tableView registerClass:[RCDSearchResultTableViewCell class] forCellReuseIdentifier:searchResultCellWithIdentifier];
    //背景颜色
    self.searchBar.backgroundColor = [UIColor trzx_BackGroundColor];
    self.searchBar.tintColor = [UIColor trzx_TitleColor];
    [self.searchBar RC_setSearchTextFieldBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriendNotification:) name:RCDDeleteFriendNotification object:nil];
    
    self.searchViewController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)deleteFriendNotification:(NSNotification *)noti{
    [self getAllData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    if (self.selectedPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.searchResult.count){
        [self createDatas];
    }
    self.navigationController.navigationBarHidden = NO;
}

-(void)setNavigationColor{
    self.searchViewController.searchResultsDataSource = self;
    self.searchViewController.searchResultsDelegate = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    if (self.selectedPresent) {
        self.title = @"选择朋友";
    }else{
        self.title = @"通讯录";
    }
}

//删除已选中用户
-(void) removeSelectedUsers:(NSArray *) selectedUsers{
    for (RCDUserInfo *user in selectedUsers) {
        [_friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RCDUserInfo *userInfo = obj;
            if ([user.userId isEqualToString:userInfo.userId]) {
                [_friends removeObject:obj];
            }
        }];
    }
}

/**
 *  initial data
 */
-(void) getAllData{
    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    [self createDatas];
    [RCDHTTPTOOL requestMyFriendList:^(id data, NSError *error) {
        if (data) {
            NSMutableArray *result = data;
            for (RCDUserInfo *userInfo in result) {
                [[RCDataBaseManager shareInstance] insertFriendToDB:userInfo];
            }
            if(![self.searchBar isFirstResponder]){
                [self createDatas];
            }
        }
    }];
}

/**
 *  创建数据
 */
-(void)createDatas{
    _allFriends = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
    _friends = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance]getAllFriends]];
//    if (_friends==nil||_friends.count<1) {
//        [RCDDataSource syncFriendList:^(NSMutableArray * result) {
//            _friends=result;
////            if (_friends.count < 20) {
////                self.hideSectionHeader = YES;
////            }
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                _allFriends = [self sortedArrayWithPinYinDic:_friends];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
//                    [self.tableView reloadSectionIndexTitles];
//                });
//            });
//        }];
//    }else{
//        if (_friends.count < 20) {
//            self.hideSectionHeader = NO;
//        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _allFriends = [self sortedArrayWithPinYinDic:_friends];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self.tableView reloadSectionIndexTitles];
            });
        });
//    }
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        
        RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellWithIdentifier];
        [cell.ivAva RC_removeAllSubviews];
        if (!cell) {
            cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchResultCellWithIdentifier];
        }
            NSArray *array = self.searchResult[indexPath.section];
            id value = array[indexPath.row];
        if([value isKindOfClass:[RCDUserInfo class]]){
            RCDUserInfo *user = value;
            if(user){
                cell.user = user;
            }
        }else if([value isKindOfClass:[RCDGroupInfo class]]){
            
            RCDGroupInfo *group =array[indexPath.row];
            if ([[RCDataBaseManager shareInstance] getGroupByGroupId:group.mid].groupHeadData) {
                cell.ivAva.image = [UIImage imageWithData:[[RCDataBaseManager shareInstance] getGroupByGroupId:group.mid].groupHeadData];
            }else{
                [self.dscussionHeadManager kipo_setGroupListHeader:cell.ivAva groupInfo:group isSave:YES];
            }
            cell.lblName.text = group.name;
        }
        
        return cell;
    }
    
    RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    cell.badgeNumberLabel.hidden = YES;
    cell.backgroundColor = [UIColor trzx_BackGroundColor];
    if (indexPath.section == 0 && !self.selectedPresent) {
        if (indexPath.row == 0) {
            cell.lblName.text = @"新的好友";
            [cell.imgvAva setImage:[UIImage RC_BundleImgName:@"RCDAddressBook_Friend"]];
            
            if ([RCDataBaseManager shareInstance].getAddFriendMessageCount) {
                cell.badgeNumberLabel.hidden = NO;
                cell.badgeNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[RCDataBaseManager shareInstance].getAddFriendMessageCount];
            }
        }else if(indexPath.row == 1){
            cell.lblName.text = @"群聊";
            [cell.imgvAva setImage:[UIImage RC_BundleImgName:@"RCDAddressBook_group"]];
        }
        return cell;
    }

    if (_allKeys.count == 0 || _allFriends.count == 0) {
        return cell;
    }
    NSString *key = [_allKeys objectAtIndex:self.selectedPresent ? indexPath.section : indexPath.section - 1];
    NSArray *arrayForKey = [_allFriends objectForKey:key];

    RCDUserInfo *user = (arrayForKey.count > 0  && arrayForKey.count > indexPath.row) ? arrayForKey[indexPath.row]:nil;
    if(user){
        cell.user = user;
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchViewController.searchResultsTableView){
        NSArray *array = self.searchResult[section];
        return array.count?20:0;
    }
    
    if ((!self.selectedPresent && section == 0) ||
        [self.searchBar isFirstResponder] ||
        _allKeys.count == 0 ||
        _allFriends.count == 0 ) {
        return 0;
    }
    NSString *key = [_allKeys objectAtIndex:self.selectedPresent? section : section - 1];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    if(arrayForKey.count){
        return 20;
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchViewController.searchResultsTableView){
        NSArray *array = self.searchResult[section];
        NSString *title;
        if(array.count){
            title = [array[0] isKindOfClass:[RCDUserInfo class]] ? @"    联系人":@"    群聊";
        }else{
            title = @"";
        }
        UILabel *label = [UILabel RC_labelWithTitle:title color:[UIColor trzx_TitleColor] fontSize:15 aligment:NSTextAlignmentLeft];
        label.backgroundColor = [UIColor trzx_BackGroundColor];
        return label;
    }
    
    if((!self.selectedPresent && section == 0) || [self.searchBar isFirstResponder]){
        return nil;
    }
    
    if(_allKeys.count == 0 || _allFriends.count == 0){
        return nil;
    }
    
    UILabel *label = [[UILabel alloc]init];
    NSString *key = [_allKeys objectAtIndex:self.selectedPresent? section : section - 1];
    if (_allKeys.count)label.text = [NSString stringWithFormat:@"  %@",key];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchViewController.searchResultsTableView){
        NSArray *array = self.searchResult[section];
        return array.count;
    }
    
    if((!self.selectedPresent && section == 0) || [self.searchBar isFirstResponder]){
        return 2;
    }
    if(_allKeys.count == 0 || _allFriends.count == 0){
        return 0;
    }
    NSString *key = [_allKeys objectAtIndex:self.selectedPresent?section : section - 1];
    
    NSArray *arr = [_allFriends objectForKey:key];
    
    return [arr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView)return self.searchResult.count;;
    
    return self.selectedPresent ?  [_allKeys count] : [_allKeys count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchViewController.searchResultsTableView)return 80.f;
    if(!self.selectedPresent && indexPath.section == 0){
        return 53;
    }
    return 60.f;//原来: 65
}

#pragma mark - 左滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    if(tableView == self.searchViewController.searchResultsTableView){
        return NO;
    }
    if (_allKeys.count == 0 || _allFriends.count == 0 || (indexPath.section == 0 && !self.selectedPresent)) {
        return YES;
    }
    
    NSString *key = [_allKeys objectAtIndex:self.selectedPresent ? indexPath.section : indexPath.section - 1];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    
    if(arrayForKey.count == 0){
        return NO;
    }
    
    if(arrayForKey.count > indexPath.row){
        RCDUserInfo *user = arrayForKey[indexPath.row];
        if([user.name isEqualToString:@"投融小秘书"]){
            return NO;
        }
    }
    
    
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || self.selectedPresent) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [_allKeys objectAtIndex:indexPath.section - 1];
        NSArray *arrayForKey = [_allFriends objectForKey:key];
        RCDUserInfo *user = arrayForKey[indexPath.row];
        if(arrayForKey.count >= indexPath.row){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"将联系人“%@”删除,同时删除与该联系人的聊天记录",user.name] message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除联系人", nil];
            [alertView show];
            [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                if ([indexNumber intValue] == 1) {
                    
                    [[RCDHttpTool shareInstance] deleteFriend:user.userId complete:^(BOOL result) {
                        //删除好友
                        [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_PRIVATE targetId:user.userId success:^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //成功
                                // 融云提示
//                                [LCProgressHUD hide];
                                [[RCDataBaseManager shareInstance] deleteFriendFromDB:user.userId];
                                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:user.userId];
                                [self createDatas];
                            });
                        } error:^(RCErrorCode status) {
                            //融云提示
//                            [LCProgressHUD hide];
                        }];
                    }];
                }
            }];
        }else{
            [self createDatas];
        }
    }
}

//pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == self.searchViewController.searchResultsTableView) {
        return nil;
    }
    return _friends.count?_allKeys:nil;
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

//跳转到个人详细资料
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *key = [_allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [_allFriends objectForKey:key];
    RCDUserInfo *user = arrayForKey[indexPath.row];
    
    RCDPersonDetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.userInfo = user;
}

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_allKeys.count == 0 || _allFriends.count == 0) {
        return;
    }
    if(self.selectedPresent && tableView == self.searchViewController.searchResultsTableView){
        
        RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:self.conversationTargetId];
        RCDBusinessCardMessage *message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:userInfo.name portrait:userInfo.portraitUri userId:userInfo.userId];
        [RCDSelectedSendView selectedSendView:userInfo messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.conversationTargetId content:message pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                    if (leaveString.length) {
                        RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.conversationTargetId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                        } error:^(RCErrorCode nErrorCode, long messageId) {
                        }];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        融云提示
//                        //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                    });
                } error:^(RCErrorCode nErrorCode, long messageId) {
                }];
            }];
        }];
        
    }else if(self.OSMessage && tableView == self.searchViewController.searchResultsTableView){
        
        if(indexPath.section == 0){
            NSArray *array = self.searchResult[indexPath.section];
            RCDUserInfo *user = array[indexPath.row];
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
                    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:user.userId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                        if (leaveString.length) {
                            RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:user.userId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                                
                            } error:^(RCErrorCode nErrorCode, long messageId) {
                                
                            }];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
//                            //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                        });
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                }];
            }];
        }else{
            NSArray *array = self.searchResult[indexPath.section];
            RCDGroupInfo *groupInfo = array[indexPath.row];
            RCMessageContent *message;
            if ([self.OSMessage.type isEqualToString:@"userHome"]) {
                RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:self.OSMessage.objId];
                message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:userInfo.name portrait:userInfo.portraitUri userId:userInfo.userId];
            }else if([self.OSMessage.type isEqualToString:@"public"]){
                message = [RCDPublicMessage messageWithName:self.OSMessage.title mid:self.OSMessage.objId photo:self.OSMessage.headURL introduction:self.OSMessage.desc];
            }else{
                message = [RCDCollectionMessage messageWithTitle:self.OSMessage.title content:self.OSMessage.desc picture:self.OSMessage.headURL collectionType:self.OSMessage.type mid:self.OSMessage.objId];
            }
            [RCDSelectedSendView selectedSendViewToGroupInfo:groupInfo messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:groupInfo.groupId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                        if (leaveString.length) {
                            RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:groupInfo.groupId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                                
                            } error:^(RCErrorCode nErrorCode, long messageId) {
                                
                            }];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 融云提示
//                            //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                        });
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                }];
            }];
        }
        
    }else if (tableView == self.searchViewController.searchResultsTableView) {
        
            NSArray *array = self.searchResult[indexPath.section];
            if(array.count){
                if ([array.firstObject isKindOfClass:[RCDUserInfo class]]) {
                    RCDUserInfo *user = array[indexPath.row];
                    UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:user.userId];
                    if (personalHomeVC) {
                        [self.navigationController pushViewController:personalHomeVC animated:YES];
                    }
                    self.navigationController.navigationBarHidden = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.navigationController.navigationBarHidden = YES;
                    });
                }else{
                    NSArray *array = self.searchResult[indexPath.section];
                    RCDGroupInfo *groupInfo = array[indexPath.row];
                    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
                    _conversationVC.title = groupInfo.inName;
                    
//                    }
                    _conversationVC.conversationType = ConversationType_GROUP;
                    _conversationVC.targetId = groupInfo.mid;
                    //                _conversationVC.userName = model.conversationTitle;
                    RCConversationModel *model = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:[[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:groupInfo.mid] extend:nil];
                    _conversationVC.conversation = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:[[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:groupInfo.mid] extend:nil];
                    _conversationVC.unReadMessage = model.unreadMessageCount;
                    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
                    _conversationVC.enableUnreadMessageIcon=YES;
//                    _conversationVC.closeInputBool = YES;
//                    _conversationVC.isPopRootNav = YES;
                    //            _conversationVC.originalVC = origanalViewControll;
                    if (model.conversationType == ConversationType_SYSTEM) {
                        _conversationVC.userName = @"系统消息";
                        _conversationVC.title = @"系统消息";
                    }
                    _conversationVC.collectionHeightChange = YES;
                    [self.navigationController pushViewController:_conversationVC animated:YES];
                }
            }
        
    }else if(!self.selectedPresent && indexPath.section == 0 && ![tableView isEqual:self.searchViewController]){
        if (indexPath.row == 0) {
            RCDAddFriendListViewController *addFriendListVC = [[RCDAddFriendListViewController alloc] init];
            //删除红点
            [[RCDataBaseManager shareInstance] clearAddFriendMessage];
            
            [self.navigationController pushViewController:addFriendListVC animated:YES];
        }else if(indexPath.row == 1){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            RCDGroupChatViewController *groupChatVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDGroupChatViewController"];
            [self.navigationController pushViewController:groupChatVC animated:YES];
        }
    }else if (self.friends.count && self.OSMessage){
        
        NSString *key = [_allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [_allFriends objectForKey:key];
        RCDUserInfo *user = arrayForKey[indexPath.row];
        if ([self.OSMessage.type isEqualToString:@"userHome"]) {
            RCDBusinessCardMessage *message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:user.name portrait:user.portraitUri userId:user.userId];
            [self sendMessageToUserInfo:user messageContent:message targetId:user.userId type:ConversationType_PRIVATE];
        }else{
            RCDCollectionMessage *collectionMessage = [RCDCollectionMessage messageWithTitle:self.OSMessage.title content:self.OSMessage.desc picture:self.OSMessage.headURL collectionType:self.OSMessage.type mid:self.OSMessage.objId];
            [RCDSelectedSendView selectedSendView:user messageContent:collectionMessage sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:user.userId content:collectionMessage pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                        if (leaveString.length) {
                            RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:self.conversationTargetId.length?self.conversationTargetId:user.userId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                                
                            } error:^(RCErrorCode nErrorCode, long messageId) {
                                
                            }];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            // 融云提示
//                            //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                        });
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                }];
            }];
        }
    }else if(self.friends.count && self.selectedPresent){
        
        NSString *key = [_allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [_allFriends objectForKey:key];
        RCDUserInfo *user = arrayForKey[indexPath.row];
//        RCDUserInfo *targetUser = [[RCDataBaseManager shareInstance] getUserByUserId:self.conversationTargetId];
        RCDBusinessCardMessage *message = [RCDBusinessCardMessage messageWithContent:@"个人签名" andName:user.name portrait:user.portraitUri userId:user.userId];
        if (self.conversationType == ConversationType_PRIVATE) {
            [self sendMessageToUserInfo:user messageContent:message targetId:self.conversationTargetId type:self.conversationType];
        }else if(self.conversationType == ConversationType_GROUP){
            RCDGroupInfo *group = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.conversationTargetId];
            [RCDSelectedSendView selectedSendViewToGroupInfo:group messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.conversationTargetId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                        if (leaveString.length) {
                            RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                            [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.conversationTargetId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                                
                            } error:^(RCErrorCode nErrorCode, long messageId) {
                                
                            }];
                        }
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                }];
            }];
        }
    }else if (self.friends.count) {
        RCDAddressBookTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:cell.user.userId];
        if (personalHomeVC) {
            [self.navigationController pushViewController:personalHomeVC animated:YES];
        }
    }
}

/**
 发送消息给 指定用户
 */
-(void)sendMessageToUserInfo:(RCDUserInfo *)user messageContent:(RCMessageContent *)message targetId:(NSString *)targetId type:(RCConversationType)type{
    [RCDSelectedSendView selectedSendView:user messageContent:message sendButtonBlock:^(RCDUserInfo *userInfo, NSString *leaveString) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[RCIM sharedRCIM] sendMessage:type targetId:targetId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
                if (leaveString.length) {
                    RCTextMessage *textMessage = [RCTextMessage messageWithContent:leaveString];
                    [[RCIM sharedRCIM] sendMessage:type targetId:targetId content:textMessage pushContent:@"您有新的消息" pushData:nil success:^(long messageId) {
                        
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 融云提示
//                    //                            [LCProgressHUD showSuccess:@"发送成功"]; // 融云提示;
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                
            }];
        }];
    }];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchResult removeAllObjects];
    self.notSearch.hidden = YES;
}

//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    if(!self.searchResult.count){
////        [self.searchViewController.searchResultsTableView reloadData];
////    }else{
//        [self.tableView reloadData];
//    }
//}


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
    self.notSearch.hidden = YES;
    if ([searchText length]) {
        
        [[RCDHttpTool shareInstance] searchLocal:searchText complete:^(id value) {
            [self.searchResult removeAllObjects];
            NSArray *users = [RCDUserInfo mj_objectArrayWithKeyValuesArray:value[@"users"]];
            NSArray *groups = [RCDGroupInfo mj_objectArrayWithKeyValuesArray:value[@"groups"]];
            
            if(users.count){
                [self.searchResult addObject:users];
            }
            if(groups.count && !self.selectedPresent){
                [self.searchResult addObject:groups];
            }
//            self.hideSectionHeader = YES;
            self.searchViewController.searchResultsTableView.delegate = self;
            self.searchViewController.searchResultsTableView.dataSource = self;
            [self.searchViewController.searchResultsTableView reloadData];
            
            if(self.searchResult.count){
                self.notSearch.hidden = YES;
            }else{
                self.notSearch.hidden = NO;
            }
        }];
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
//        _notSearch.hidden = YES;
        [self.searchViewController.searchResultsTableView addSubview:_notSearch];
    }
    return _notSearch;
}

-(RCDDscussionHeadManager *)dscussionHeadManager{
    if (!_dscussionHeadManager) {
        _dscussionHeadManager = [[RCDDscussionHeadManager alloc]init];
    }
    return _dscussionHeadManager;
}

@end
