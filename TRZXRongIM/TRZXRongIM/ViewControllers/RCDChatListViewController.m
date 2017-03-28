//
//  FirstViewController.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDChatListViewController.h"
#import "KxMenu.h"
#import "RCDAddressBookViewController.h"
#import "RCDSearchFriendViewController.h"
#import "RCDSelectPersonViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDChatViewController.h"
#import "UIColor+RCColor.h"
#import "RCDChatListCell.h"
#import "RCDAddFriendTableViewController.h"
#import "RCDHttpTool.h"
//#import "TRZXFriendLineTableViewController.h"
#import "RCDUserInfo.h"
#import "RCDFriendInvitationTableViewController.h"
#import "RCConversationBaseCoverBtn.h"
//#import "BJCollectionCell.h"
#import "TempCollectionView.h"
#import "RCDataBaseManager.h"
#import "RCDGroupInfo.h"
#import "RCDUIImageView.h"
#import "RCDSearchUserInfo.h"
//#import "AnnouncementViewController.h"
#import "RCDAnnouncementModel.h"
#import "RCDSelectedView.h"
#import "RCFinancingLoopViewController.h"
#import "RCDDscussionHeadManager.h"
//#import "PersonalInformationVC.h"
#import <UserNotifications/UserNotifications.h>
//#import "TRZXFriendLineTableViewController.h"
#import "RCDSubscriptionViewController.h"
#import "RCDCollectionChatListViewController.h"
#import "RCDPublicMessage.h"
//#import "NSDate+Extension.h"
//#import "AppDelegate+MessageManager.h"
#import "RCDCommonDefine.h"
#import "TempCollectionViewCell.h"

//投融公告 userId
NSString *const kTRAnnouncementId = @"TRAnnouncementId";

@interface RCDChatListViewController ()<UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,RCIMReceiveMessageDelegate>

//@property (nonatomic,strong) NSMutableArray *myDataSource;
@property (nonatomic,strong) RCConversationModel *tempModel;

@property (nonatomic,assign) BOOL isClick;
- (void) updateBadgeValueForTabBarItem;

/**
 通讯录
 */
@property (nonatomic,strong)RCDSelectedView *selectedAddressBook;

/**
 投融圈
 */
@property (nonatomic,strong)RCDSelectedView *selectedFinancingLoop;

/**
 订阅刊
 */
@property (nonatomic,strong)RCDSelectedView *selectedSubscribe;

/**
 公告
 */
@property (nonatomic,strong)RCDSelectedView *selectedAnnouncement;


@property(nonatomic, strong)RCDDscussionHeadManager *dscussionHeadManager;

@end

@implementation RCDChatListViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        
        //聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE)]];//,@(ConversationType_DIS
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNeedRefreshNotification:) name:RCDUmengNotification object:nil];
    }
    return self;
}

/**
 *  此处使用storyboard初始化，代码初始化当前类时*****必须要设置会话类型和聚合类型*****
 *
 *  @param aDecoder aDecoder description
 *
 *  @return return value description
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        //聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE)]];//,@(ConversationType_DIS
        //        [self setCollectionConversationType:@[@(ConversationType_GROUP)]];//,@(ConversationType_DISCUSSION)
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView = [UIView new];
    //统一导航条样式
    [self setNavigationColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"RCDChatViewController_More" buttonRect:CGRectMake(0, 0, 60, 50) imageRect:CGRectMake(30, 2, 45, 45) Target:self action:@selector(showMenu:)];
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    [self addSelectedView];
    
}

///  添加选项(通讯录,投融圈)视图
-(void)addSelectedView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RC_SCREEN_WIDTH, 58 * 4 + 10)];
    view.backgroundColor = [UIColor trzx_BackGroundColor];
    self.conversationListTableView.tableHeaderView = view;
    self.conversationListTableView.backgroundColor = self.view.backgroundColor = [UIColor trzx_BackGroundColor];
    [view addSubview:self.selectedAddressBook];
    [view addSubview:self.selectedFinancingLoop];
    [view addSubview:self.selectedSubscribe];
    [view addSubview:self.selectedAnnouncement];
    
    [self.selectedFinancingLoop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(0);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(58);
    }];
    [self.selectedAddressBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedFinancingLoop.mas_bottom);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(58);
    }];
    [self.selectedSubscribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedAddressBook.mas_bottom);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(58);
    }];
    [self.selectedAnnouncement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedSubscribe.mas_bottom);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(58);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"私信";
    
    _isClick = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [self selectedAnnouncement];
    [self selectedFinancingLoop];
    [self notifyUpdateUnreadMessageCount];
    if(RC_SCREEN_HEIGHT < 570){
        self.emptyConversationView.bottom = RC_SCREEN_HEIGHT - 150;
    }else{
        self.emptyConversationView.bottom = RC_SCREEN_HEIGHT - 180;
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self) {
        self.navigationController.navigationBar.alpha = 1;
    }else{
        self.navigationController.navigationBar.alpha =1;
    }
}

//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRCNeedReloadDiscussionListNotification"
                                                  object:nil];
}

-(void)setNavigationColor{
    //统一导航条样式
//    [self.tabBarController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:248/255.0 alpha:1]];
    
//    UIFont *font = [UIFont boldSystemFontOfSize:19.f];
//    NSDictionary *textAttributes = @{
//                                     NSFontAttributeName : font,
//                                     NSForegroundColorAttributeName : [UIColor trzx_TitleColor]
//                                     };
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
    UIView *view = self.tabBarController.tabBar.superview;
    view.backgroundColor = [UIColor whiteColor];
}

- (void)updateBadgeValueForTabBarItem{

    // 身份判断
//    if ([KPOUserDefaults currentSessionUserTypeIsUser]||
//        [[Login curLoginUser].userId length] < 1) {
//        return;
//    }
    
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];

        // 红点提示
//        if([KPOUserDefaults getAnnouncementNumber]){
//            count ++;
//        }
//        if([[NSUserDefaults standardUserDefaults] objectForKey:RCDCommentCircleKey]){
//            count++;
//        }
//        if([[NSUserDefaults standardUserDefaults] objectForKey:RCDFriendCircleKey]){
//            count++;
//        }
        count += [[RCDataBaseManager shareInstance] getAddFriendMessageCount];
        if (count>0) {
            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        }else{
            __weakSelf.tabBarItem.badgeValue = nil;
        }
        
        if ([[RCDataBaseManager shareInstance] getAddFriendMessageCount]) {
            self.selectedAddressBook.badgeNumberLabel.hidden = NO;
            self.selectedAddressBook.badgeNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[[RCDataBaseManager shareInstance] getAddFriendMessageCount]];
        }else{
            self.selectedAddressBook.badgeNumberLabel.hidden = YES;
        }
    });
}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    if (_isClick) {
        _isClick = NO;
        if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc] init];
            _conversationVC.conversationType = model.conversationType;
            _conversationVC.targetId = model.targetId;
            _conversationVC.userName = model.conversationTitle;
            _conversationVC.title = model.conversationTitle;
            _conversationVC.conversation = model;
            _conversationVC.unReadMessage = model.unreadMessageCount;
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }
        
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
            if ([model.extend isKindOfClass:[RCDGroupInfo class]] && model.conversationType == ConversationType_GROUP) {
                RCDGroupInfo *groupInfo = model.extend;
                _conversationVC.title = groupInfo.inName.length?groupInfo.inName:[NSString stringWithFormat:@"群聊(%ld)",groupInfo.users.count];
            }else{
                _conversationVC.title = model.conversationTitle;
            }
            _conversationVC.conversationType = model.conversationType;
            _conversationVC.targetId = model.targetId;
            //                _conversationVC.userName = model.conversationTitle;
            _conversationVC.conversation = model;
            _conversationVC.unReadMessage = model.unreadMessageCount;
            _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
            _conversationVC.enableUnreadMessageIcon=YES;
            //            _conversationVC.closeInputBool = YES;
            _conversationVC.isPopRootNav = YES;
            //            _conversationVC.originalVC = origanalViewControll;
            if (model.conversationType == ConversationType_SYSTEM) {
                _conversationVC.userName = @"系统消息";
                _conversationVC.title = @"系统消息";
            }
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }
        
        //聚合会话类型，此处自定设置。
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            RCDCollectionChatListViewController *collectionChatVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDCollectionChatListViewController"];
            
            //            NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
            collectionChatVC.title = @"订阅刊";
            //            [collectionChatVC setDisplayConversationTypes:array];
            //            [collectionChatVC setCollectionConversationType:nil];
            //            collectionChatVC.isEnteredToCollectionViewController = YES;
            [self.navigationController pushViewController:collectionChatVC animated:YES];
        }
        
        //自定义会话类型
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
            RCConversationModel *model = self.conversationListDataSource[indexPath.row];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            RCDFriendInvitationTableViewController *temp = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDFriendInvitationTableViewController"];
            temp.conversationType = model.conversationType;
            temp.targetId = model.targetId;
            temp.userName = model.conversationTitle;
            temp.title = model.conversationTitle;
            temp.conversation = model;
            [self.navigationController pushViewController:temp animated:YES];
        }
    }
}

#pragma mark - cell 将要展示
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *view = [cell valueForKey:@"headerImageView"];
    
    if ([cell isKindOfClass:[RCConversationCell class]]) {
        RCConversationCell *conversationCell = (RCConversationCell *)cell;
        conversationCell.conversationTitle.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        if (conversationCell.model.conversationType == ConversationType_APPSERVICE||
            conversationCell.model.conversationType == ConversationType_PUBLICSERVICE){
            conversationCell.conversationTitle.text = @"订阅消息";
            view.image = [UIImage RC_BundleImgName:@"RCDConversation_Public_Message"];
            NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:conversationCell.model.conversationType targetId:conversationCell.model.targetId count:1];
//            conversationCell.messageContentLabel.x = conversationCell.conversationTitle.x;
            [conversationCell.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(conversationCell.conversationTitle);
            }];
            if (array.count) {
                RCMessage *message = array.firstObject;
                if ([message.content isKindOfClass:[RCTextMessage class]]) {
                    conversationCell.messageContentLabel.text = ((RCTextMessage*)message.content).content;
                }else if([message.content isKindOfClass:[RCPublicServiceRichContentMessage class]]){
                    conversationCell.messageContentLabel.text = ((RCPublicServiceRichContentMessage *)message.content).richConent.title;
                }else if([message.content isKindOfClass:[RCImageMessage class]]){
                    conversationCell.messageContentLabel.text = @"[图片]";
                }else if([message.content isKindOfClass:[RCVoiceMessage class]]){
                    conversationCell.messageContentLabel.text = @"[语音消息]";
                }
            }
        }
    }
    if(cell.model.conversationModelType == ConversationType_PRIVATE){
        [view RC_removeAllSubviews];
    }
    if (cell.model.conversationType == ConversationType_GROUP) {
        if (![cell isMemberOfClass:[RCDUIImageView class]]) {
            [self.dscussionHeadManager kipo_settingHeader:view titleLabel:((RCConversationCell *)cell).conversationTitle model:cell.model];
        }
        if ([cell isKindOfClass:[RCConversationCell class]]) {
            RCConversationCell *conversationCell = (RCConversationCell *)cell;
            NSString *userName;
            if(conversationCell.model.lastestMessage.senderUserInfo.name){
                userName = conversationCell.model.lastestMessage.senderUserInfo.name;
            }else{
                userName = [[RCDataBaseManager shareInstance] getUserByUserId:conversationCell.model.senderUserId].name;
            }
            if([conversationCell.messageContentLabel.text hasPrefix:[NSString stringWithFormat:@"%@:",userName]] && [conversationCell.model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
                RCInformationNotificationMessage *notificationMessage = (RCInformationNotificationMessage *)conversationCell.model.lastestMessage;
                conversationCell.messageContentLabel.text = notificationMessage.message;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    conversationCell.messageContentLabel.text = notificationMessage.message;
                });
            }
        }
    }
}

- (void)didTapCellPortrait:(RCConversationModel *)model{
    
    if(model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
        RCDCollectionChatListViewController *collectionChatVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDCollectionChatListViewController"];
        collectionChatVC.title = @"订阅刊";
        [self.navigationController pushViewController:collectionChatVC animated:YES];
        return ;
    }
    
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    if ([model.extend isKindOfClass:[RCDGroupInfo class]] && model.conversationType == ConversationType_GROUP) {
        RCDGroupInfo *groupInfo = model.extend;
        _conversationVC.title = groupInfo.inName;
    }else{
        _conversationVC.title = model.conversationTitle;
    }
    _conversationVC.conversationType = model.conversationType;
    _conversationVC.targetId = model.targetId;
    //                _conversationVC.userName = model.conversationTitle;
    _conversationVC.conversation = model;
    _conversationVC.unReadMessage = model.unreadMessageCount;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
    _conversationVC.closeInputBool = YES;
    _conversationVC.isPopRootNav = YES;
    //            _conversationVC.originalVC = origanalViewControll;
    if (model.conversationType == ConversationType_SYSTEM) {
        _conversationVC.userName = @"系统消息";
        _conversationVC.title = @"系统消息";
    }
    [self.navigationController pushViewController:_conversationVC animated:YES];
}

/**
 *  弹出层
 *
 *  @param sender sender description
 */
- (IBAction)showMenu:(UIButton *)sender {
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"发起群聊"
                     image:[[UIImage RC_BundleImgName:@"RCD_LaunchGroup"] RC_scaleToSize:CGSizeMake(20, 20)]
                    target:self
                    action:@selector(pushChat:)],
      
      [KxMenuItem menuItem:@"添加好友"
                     image:[[UIImage RC_BundleImgName:@"RCDSearch"] RC_scaleToSize:CGSizeMake(20, 20)]
                    target:self
                    action:@selector(pushAddFriend:)]
      ];
    
    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 50;
    targetFrame.origin.x = RC_SCREEN_WIDTH - 25;
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}

/**
 *  发起聊天
 *
 *  @param sender sender description
 */
- (void) pushChat:(id)sender{
    //成为合伙人判断
//    if ([KPOUserDefaults currentSessionUserTypeIsOperator]) {
//        [LCProgressHUD showInfoMsg:@"暂无权限"];
//        return;
//    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDSelectPersonViewController *selectPersonVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSelectPersonViewController"];
    
    //设置点击确定之后回传被选择联系人操作
    __weak typeof(&*self)  weakSelf = self;
    selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController *selectPersonViewController,NSArray *selectedUsers){
        if(selectedUsers.count == 1){
            
            RCDUserInfo *user = selectedUsers[0];
            
            // 判断 - 不能与自己聊天
            // 身份判断
//            if ([user.userId isEqualToString:[Login curLoginUser].userId]) {
//                [LCProgressHUD showInfoMsg:@"不能与自己聊天"];
//                return ;
//            }
            
            RCDChatViewController *chat =[[RCDChatViewController alloc]init];
            chat.targetId                      = user.userId;
            chat.userName                    = user.name;
            chat.conversationType              = ConversationType_PRIVATE;
            chat.title                         = user.name;
            chat.isPopRootNav = YES;
            //跳转到会话页面
            dispatch_async(dispatch_get_main_queue(), ^{
                UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                [weakSelf.navigationController popToViewController:tabbarVC animated:NO];
                [tabbarVC.navigationController  pushViewController:chat animated:YES];
            });
        }
        
        //选择多人则创建讨论组
        else if(selectedUsers.count > 1) {
            
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *userIdList = [NSMutableArray new];
            NSMutableString *userIds = [NSMutableString string];
            for (RCDUserInfo *user in selectedUsers) {
                [userIds appendString:[NSString stringWithFormat:@"%@%@", user.userId,@","]];
                [userIdList addObject:user.userId];
                [tempArray addObject:user.portraitUri];
            }
            [userIds deleteCharactersInRange:NSMakeRange(userIds.length - 1, 1)];
            NSString *discussionTitle = [NSString stringWithFormat:@"群聊(%ld)",selectedUsers.count + 1];
            [[RCDHttpTool shareInstance] createGroupWithUserIds:userIds groupName:discussionTitle complete:^(RCGroup *group) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RCDChatViewController *chat = [[RCDChatViewController alloc]init];
                    chat.targetId                      = group.groupId;
                    chat.userName                    = group.groupName;
                    chat.conversationType              = ConversationType_GROUP;
                    chat.isPopRootNav = YES;
                    //                    RCConversation *conversation = [[RCConversation alloc] init];
                    //                    conversation.conversationTitle = group.groupName;
                    //                    conversation.conversationType = ConversationType_GROUP;
                    //                    conversation.targetId = group.groupId;
                    //                    RCConversationModel *conversationModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:conversation extend:nil];
                    //                    chat.conversation = conversationModel;
                    //                    __block NSString *chatTitle;
                    //                    [selectedUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //                        RCDUserInfo *userInfo = obj;
                    //                        chatTitle = [NSString stringWithFormat:@"%@,%@",chatTitle?chatTitle:@"",userInfo.name];
                    //                    }];
                    //                    chatTitle = [chatTitle substringFromIndex:1];
                    
                    chat.title = group.groupName;//@"讨论组";
                    
                    UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                    [tabbarVC.navigationController  pushViewController:chat animated:YES];
                });
            }];
            return;
        }
    };
    
    [self.navigationController pushViewController :selectPersonVC animated:YES];
}

/**
 *  公众号会话
 *
 *  @param sender sender description
 */
- (void) pushPublicService:(id) sender{
    RCPublicServiceListViewController *publicServiceVC = [[RCPublicServiceListViewController alloc] init];
    [self.navigationController pushViewController:publicServiceVC  animated:YES];
}

-(void)addNavigationPop{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void) pushAddFriend:(id) sender{
    RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
    [self.navigationController pushViewController:searchFirendVC  animated:YES];
}

/**
 *  通讯录
 *
 *  @param sender sender description
 */
-(void) pushAddressBook:(id) sender{
    //    if ([KPOUserDefaults currentSessionUserTypeIsOperator]) {
    //        [LCProgressHUD showInfoMsg:@"暂无权限"];
    //        return;
    //    }
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDAddressBookViewController *addressBookVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddressBookViewController"];
    [self.navigationController pushViewController:addressBookVC animated:YES];
}

/**
 *  投融圈
 *
 *  @param sender sender description
 */
-(void) pushFinancingLoop:(id)sender{
    
//    if ([KPOUserDefaults currentSessionUserTypeIsOperator]) {
//        [LCProgressHUD showInfoMsg:@"暂无权限"];
//        return;
//    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCFinancingLoopViewController *financingLoopVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCFinancingLoopViewController"];
    [self.navigationController pushViewController:financingLoopVC animated:YES];
}

/**
 *  添加公众号
 *
 *  @param sender sender description
 */
- (void) pushAddPublicService:(id) sender{
    //    RCPublicServiceSearchViewController *searchFirendVC = [[RCPublicServiceSearchViewController alloc] init];
    //    [self.navigationController pushViewController:searchFirendVC  animated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDSubscriptionViewController *addressBookVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSubscriptionViewController"];
    [self.navigationController pushViewController:addressBookVC animated:YES];
}

-(void) pushAnnouncement:(id)sender{
    
    // 跳转公告
//    AnnouncementViewController *gonggaoVC  = [[AnnouncementViewController alloc] init];
//    //        [[RCDataBaseManager shareInstance] removeMsgFlag:msgFlagTypeMessage];
//    gonggaoVC.xiaoxiStr = @"xiaoxiStr";
//    gonggaoVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:gonggaoVC animated:YES];
//    [KPOUserDefaults deleteAnnouncementNumber];
}

//*********************插入自定义Cell*********************//
//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    
    //    if([KPOUserDefaults getAnnouncementIsOpen])[self getAnnouncemenwt:dataSource];
    
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
        {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    return dataSource;
}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    //    if ([model.targetId isEqualToString:kTRAnnouncementId])return;
    
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    
    if (model.conversationType == ConversationType_GROUP) {
        [[RCDataBaseManager shareInstance] deleteGroupInfoWithId:model.targetId];
    }
    
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

//自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName    = nil;
    __block NSString *portraitUri = nil;
    
    __weak RCDChatListViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]){
            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
            if (_contactNotificationMsg.sourceUserId == nil) {
                RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.lblDetail.text = @"好友请求";
                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
                return cell;
            }
            
            NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
            if (_cache_userinfo) {
                userName = _cache_userinfo[@"username"];
                portraitUri = _cache_userinfo[@"portraitUri"];
            } else {
                NSDictionary *emptyDic = @{};
                [[NSUserDefaults standardUserDefaults]setObject:emptyDic forKey:_contactNotificationMsg.sourceUserId];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                                      completion:^(RCDUserInfo *user) {
                                          if (user == nil) {
                                              return;
                                          }
                                          RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                                          rcduserinfo_.name = user.name;
                                          rcduserinfo_.userId = user.userId;
                                          rcduserinfo_.portraitUri = user.portraitUri;
                                          
                                          model.extend = rcduserinfo_;
                                          
                                          //local cache for userInfo
                                          NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                                                        @"portraitUri":rcduserinfo_.portraitUri
                                                                        };
                                          [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                          
                                          [weakSelf.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                      }];
            }
        }
    }else{
        RCDUserInfo *user = (RCDUserInfo *)model.extend;
        userName    = user.name;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
    cell.labelTime.text = [self ConvertMessageTime:model.sentTime / 1000];
    cell.model = model;
    return cell;
}

#pragma mark - private
- (NSString *)ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        //[formatter setDateFormat:@"HH:mm"];
    }
    
    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }
    return timeText;
}

//*********************插入自定义Cell*********************//
#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    
    RCMessage *message = notification.object;
    
    if([message.objectName isEqualToString:@"RC:CmdMsg"]){
        
        if ([message.content isKindOfClass:[RCCommandMessage class]]) {//命令消息处理
            if ([((RCCommandMessage *)message.content).name isEqualToString:RCDRefreshAuthKey]) {
                
                //身份更新通知
//                [ProfileViewModel getAutInfoAuthUserId:[Login curLoginUser].userId token:[KPOUserDefaults token] authUserId:@"" success:^(id object) {
//                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [app kipo_getMessage];
//                    
//                } failure:^(NSError *error) {
//                }];
            }else if([((RCCommandMessage *)message.content).name isEqualToString:RCDAddFriendKey]){
                //被添加好友好友通知
                if ([((RCCommandMessage *)message.content).data isKindOfClass:[NSString class]]) {
                    NSDictionary *dict = [((RCCommandMessage *)message.content).data mj_JSONObject];
                    if (dict[@"id"]) {
                        [[RCDataBaseManager shareInstance] insertAddFriendMessageToDB:dict[@"id"]];
                    }
                }
            }else if([((RCCommandMessage *)message.content).name isEqualToString:RCDCommentCircleKey]){//推送评论朋友圈通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RCDCommentCircleNotification object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:RCDCommentCircleKey forKey:RCDCommentCircleKey];
                [self selectedFinancingLoop];
            }else if([((RCCommandMessage *)message.content).name isEqualToString:RCDFriendCircleKey]){
                //好友发投融圈通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RCDFriendCircleNotification object:nil];
                NSDictionary *dict = [((RCCommandMessage *)message.content).data mj_JSONObject];
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"image"] forKey:RCDFriendCircleKey];
                [self selectedFinancingLoop];
            }else if([((RCCommandMessage *)message.content).name isEqualToString:@"laobi"]){
                //对方同意添加好友通知
                NSDictionary *dict = [((RCCommandMessage *)message.content).data mj_JSONObject];
                if(dict){
                    RCDUserInfo *userInfo = [[RCDUserInfo alloc] initWithUserId:dict[@"id"] name:dict[@"name"] portrait:dict[@"image"]];
                    [[RCDataBaseManager shareInstance] insertFriendToDB:userInfo];
                }
            }else if([((RCCommandMessage *)message.content).name isEqualToString:RCDGroupNameChangeKey]){
                //更新群组信息
                NSDictionary *dict = [((RCCommandMessage *)message.content).data mj_JSONObject];
                if(dict){
                    NSString *groupId =dict[@"groupId"];
                    
                    if(groupId.length){
                        [self.dscussionHeadManager kipo_updateGroupInfoWithGroupId:groupId backGroupInfo:^(RCDGroupInfo *group) {
                            [self refreshConversationTableViewIfNeeded];
                        }];
                    }
                    //同时消息转发 更新
                    [[NSNotificationCenter defaultCenter] postNotificationName:RCDGroupRefreshNotification object:nil];
                }
            }else if([((RCCommandMessage *)message.content).name isEqualToString:RCDDeleteFriendKey]){
                //同时删除好友
                NSDictionary *dict = [((RCCommandMessage *)message.content).data mj_JSONObject];
                if(dict){
                    NSString *userId =dict[@"id"];
                    //删除好友
                    
                    [[RCDataBaseManager shareInstance] deleteFriendFromDB:userId];//删除数据库
                    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:userId];//本地存储
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 融云提示
//                        [LCProgressHUD hide];
                        if(self.conversationListDataSource.count){
                            RCConversationModel *targetModel;
                            for (RCConversationModel *model in self.conversationListDataSource) {
                                if ([model.targetId isEqualToString:userId]) {
                                    targetModel = model;
                                }
                            }
                            if(targetModel){
                                [self.conversationListDataSource removeObject:targetModel];
                                [self receiveNeedRefreshNotification:nil];
                            }
                        }
                    });
                    
                    [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_PRIVATE targetId:userId success:^{
                        //成功
                        
                    } error:^(RCErrorCode status) {
                        
                    }];//删除某个会话中的所有消息
                    
                    // 发送通知
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:RCDDeleteFriendNotification object:userId];
                    });
                }
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:RCDUmengNotification object:nil];
            }
        }
    }else if(message.conversationType == ConversationType_GROUP){
        if([message.content isKindOfClass:[RCInformationNotificationMessage class]]){
            RCInformationNotificationMessage *notificationMessage = (RCInformationNotificationMessage *)message.content;
            
            if ([notificationMessage.extra containsString:@"admin"] ||
                [notificationMessage.extra containsString:@"delete"]
                ) {
                
                if([notificationMessage.extra containsString:[Login curLoginUser].userId]){
                    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
                }
            }
        }
    }
    
    RCDUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:message.senderUserId];
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
#if DEBUG
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
            return;
        }
        //该接口需要替换为从消息体获取好友请求的用户信息
        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                              completion:^(RCDUserInfo *user) {
                                  RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                                  rcduserinfo_.name = user.name;
                                  rcduserinfo_.userId = user.userId;
                                  rcduserinfo_.portraitUri = user.portraitUri;
                                  
                                  RCConversationModel *customModel = [RCConversationModel new];
                                  customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
                                  customModel.extend = rcduserinfo_;
                                  customModel.senderUserId = message.senderUserId;
                                  customModel.lastestMessage = _contactNotificationMsg;
                                  //[_myDataSource insertObject:customModel atIndex:0];
                                  
                                  //local cache for userInfo
                                  NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                                                @"portraitUri":rcduserinfo_.portraitUri
                                                                };
                                  [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      //调用父类刷新未读消息数
                                      [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
                                      //              [super didReceiveMessageNotification:notification];
                                      //              [blockSelf_ resetConversationListBackgroundViewIfNeeded];
                                      [self notifyUpdateUnreadMessageCount];
                                      
                                      //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                                      //原因请查看super didReceiveMessageNotification的注释。
                                      NSNumber *left = [notification.userInfo objectForKey:@"left"];
                                      if (0 == left.integerValue){
                                          [super refreshConversationTableViewIfNeeded];
                                      }
                                  });
                              }];
    }else if (userInfo == nil || [userInfo.name hasSuffix:@">"]) {
        //如果为空 请求 自己服务器获取 目标数据
        
        [[RCDHttpTool shareInstance]getUserInfoWithUserId:message.senderUserId SuccessBlock:^(id json) {
            NSArray *tempArray = json[@"list"];
            if (tempArray.count) {
                RCDSearchUserInfo *chatInfo = [RCDSearchUserInfo mj_objectWithKeyValues:json[@"list"][0]];
                RCDUserInfo *userInfo = [[RCDUserInfo alloc]initWithUserId:chatInfo.mid name:chatInfo.realName portrait:chatInfo.photo];
                userInfo.isAlso = chatInfo.isAlso;
                userInfo.position = chatInfo.position;
                [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                [super didReceiveMessageNotification:notification];
            }
        } FailureBlick:^(NSError *error) {}];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            //            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            //            [self notifyUpdateUnreadMessageCount]; super会调用notifyUpdateUnreadMessageCount
        });
    }
}


//会话有新消息通知的时候显示数字提醒，设置为NO,不显示数字只显示红点
//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    RCConversationModel *model= self.conversationListDataSource[indexPath.row];
//
//    if (model.conversationType == ConversationType_PRIVATE) {
//        ((RCConversationCell *)cell).isShowNotificationNumber = NO;
//    }
//}

- (void)notifyUpdateUnreadMessageCount{
    [self updateBadgeValueForTabBarItem];
}

- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyUpdateUnreadMessageCount];
        [__blockSelf refreshConversationTableViewIfNeeded];
    });
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    TempCollectionView *collect = (TempCollectionView *)collectionView;
    
    return collect.imageArr.count;//self.DiscussPhotos.count > 9?9:self.DiscussPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TempCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];

    TempCollectionView *collect = (TempCollectionView *)collectionView;
    
    [cell.bjImage sd_setImageWithURL:[NSURL URLWithString:collect.imageArr[indexPath.row]]];
    
    return cell;
}

#pragma mark - 懒加载
-(RCDSelectedView *)selectedAddressBook{
    if (!_selectedAddressBook) {
        _selectedAddressBook = [RCDSelectedView initWithType:RCDSelectedViewTypeAddressBook];
        __weak __typeof(self) sfself = self;
        [_selectedAddressBook setButtonDidClickBlock:^(RCDSelectedViewType type) {
            [sfself pushAddressBook:nil];
        }];
    }
    return _selectedAddressBook;
}

-(RCDSelectedView *)selectedFinancingLoop{
    if (!_selectedFinancingLoop) {
        _selectedFinancingLoop = [RCDSelectedView initWithType:RCDSelectedViewTypeFinancingLoop];
        RCD_self;
        __weak __typeof(RCDSelectedView *) weakLoop = _selectedFinancingLoop;
        [_selectedFinancingLoop setButtonDidClickBlock:^(RCDSelectedViewType type) {
            
            UIViewController *friendVC = [[CTMediator sharedInstance] FriendCircle_TRZXFriendLineTableViewController];
            [sfself.navigationController pushViewController:friendVC animated:YES];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:RCDCommentCircleKey];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:RCDFriendCircleKey];
            weakLoop.imageView.hidden = YES;
            [weakLoop redViewHidden:YES];
        }];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:RCDCommentCircleKey]){
        [_selectedFinancingLoop redViewHidden:NO];
    }else{
        [_selectedFinancingLoop redViewHidden:YES];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:RCDFriendCircleKey]){
        NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:RCDFriendCircleKey];
        _selectedFinancingLoop.imageView.hidden = NO;
        [_selectedFinancingLoop.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }else{
        _selectedFinancingLoop.imageView.hidden = YES;
    }
    
    return _selectedFinancingLoop;
}

-(RCDSelectedView *)selectedSubscribe{
    if (!_selectedSubscribe) {
        _selectedSubscribe = [RCDSelectedView initWithType:RCDSelectedViewTypeSubscribe];
        __weak __typeof(self) sfself = self;
        [_selectedSubscribe setButtonDidClickBlock:^(RCDSelectedViewType type) {
            [sfself pushAddPublicService:nil];
        }];
    }
    return _selectedSubscribe;
}

-(RCDSelectedView *)selectedAnnouncement{
    if (!_selectedAnnouncement) {
        _selectedAnnouncement = [RCDSelectedView initWithType:RCDSelectedViewTypeAnnouncement];
        __weak __typeof(self) sfself = self;
        __weak __typeof(RCDSelectedView *) weakLoop = _selectedAnnouncement;
        [_selectedAnnouncement setButtonDidClickBlock:^(RCDSelectedViewType type) {
            [sfself pushAnnouncement:nil];
            
//            [KPOUserDefaults deleteAnnouncementNumber];
            [weakLoop redViewHidden:YES];
        }];
    }

    // 红点提示
//    if([KPOUserDefaults getAnnouncementNumber]){
//        [_selectedAnnouncement redViewHidden:NO];
//    }else{
//        [_selectedAnnouncement redViewHidden:YES];
//    }
    
    return _selectedAnnouncement;
}

-(RCDDscussionHeadManager *)dscussionHeadManager{
    if (!_dscussionHeadManager) {
        _dscussionHeadManager = [[RCDDscussionHeadManager alloc]init];
    }
    return _dscussionHeadManager;
}

#pragma mark - RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    [self receiveNeedRefreshNotification:nil];
}


@end
