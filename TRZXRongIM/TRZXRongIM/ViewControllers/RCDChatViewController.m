//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDChatViewController.h"
#import "RCDDiscussGroupSettingViewController.h"
#import "RCDRoomSettingViewController.h"
#import "RCDPrivateSettingViewController.h"
#import "RCDGroupInfo.h"
#import "RCDHttpTool.h"
#import "RealTimeLocationViewController.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationEndCell.h"
#import "RCDPersonDetailViewController.h"
#import "RCDataBaseManager.h"
#import "RCDTestMessage.h"
#import "RCDTestMessageCell.h"
//#import "InvestorsNetworkTool.h"
#import "BPHeadView.h"
#import <MapKit/MapKit.h>
#import <RongIMKit/RCLocationViewController.h>
#import "RCDSelectPersonViewController.h"
#import "RCNewLocationPickerViewController.h"
#import "RCNewLocationViewController.h"
#import "MSSBrowseNetworkViewController.h"
#import "RCDBusinessCardCell.h"
#import "RCDBusinessCardMessage.h"
#import "RCDCollectionMessage.h"
#import "RCDCollectionCell.h"
//#import "ConsultingDetailsViewController.h"
//#import "LiveListPlayViewController.h"
#import "RCDRedPacketsCell.h"
#import "RCDRedPacketsMessage.h"
#import "RCDPublicCell.h"
#import "RCDPublicMessage.h"
#import "RCDPublicServiceProfileViewController.h"
#import "IMBPView.h"
#import "RCDSendSelectedAddressViewController.h"
//#import "NSNumber+Extension.h"
#import "RCDChooseView.h"
//#import "RCDHostUserInfo.h"
//#import "LiveShowViewController.h"
#import "RCDCallSingleCallViewController.h"
#import "RCDPublicWebViewController.h"
//#import "DemandResourDetailsViewController.h"
//#import "KipoMyBusinessPlanViewModel.h"
#import "UIView+RCExtension.h"
#import "UIBarButtonItem+RCExtension.h"
#import "RCDCommonDefine.h"
#import <Masonry/Masonry.h>
#import "NSNumber+RCExtension.h"
#import "UIImageView+WebCache.h"
#import "RCDBPInfo.h"

#define PLUGIN_BOARD_ITEM_BUSINESSCARD_TAG  1005 //分享名片
#define PLUGIN_BOARD_ITEM_COLLECTION_TAG  1007 //分享收藏
#define PLUGIN_BOARD_ITEM_REDPACKETS_TAG  1008 //红包

@interface RCDChatViewController () < RCRealTimeLocationObserver, RealTimeLocationStatusViewDelegate, UIAlertViewDelegate, RCMessageCellDelegate,RCIMReceiveMessageDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,RCLocationPickerViewControllerDelegate,RCChatSessionInputBarControlDelegate>

@property (nonatomic, weak)id<RCRealTimeLocationProxy> realTimeLocation;

@property (nonatomic, strong)RealTimeLocationStatusView *realTimeLocationStatusView;

@property(nonatomic,strong)BPHeadView *headView;

@property (nonatomic,strong)UIView *BPBackgroundView;

@property (nonatomic,strong)UIImageView *backgroundImage;

@property (nonatomic,strong)NSArray *sendPersons;

/**
 *  判断 BPView是否打开关闭
 */
@property (nonatomic,assign)BOOL isBPOpen;

@property (nonatomic,strong)UIImagePickerController *PickerImage;

@property (nonatomic,strong)UIImagePickerController *pickerCamera;

@property (nonatomic,strong)UIImageView *inputToolBackView;;

//@property (nonatomic,strong)InvestorsNetworkTool *investorlistModel;

@property (nonatomic,strong)RCDGroupInfo *groupInfo;

@property (nonatomic, strong) RCDBPInfo *BPInfo;

@end

@implementation RCDChatViewController{
    IMBPView *BPView;
    UIImageView *imageView;
    int BPNumbers;
    RCMessageModel *globalMessModel;
    UIImageView *tiaoImage;
    UIImageView *RecordTouthImage;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.conversationMessageCollectionView.delegate = self;
    
    if (self.closeInputBool) {
        [self.chatSessionInputBarControl updateStatus:KBottomBarDefaultStatus animated:YES];
        self.closeInputBool = NO;
    }
    if(self.collectionHeightChange){
        self.conversationMessageCollectionView.y += 44;
        self.conversationMessageCollectionView.height -= 44;
        self.collectionHeightChange = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableSaveNewPhotoToLocalSystem = YES;
    if (self.conversationType != ConversationType_CHATROOM) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"ic_action_overflow_dark" Target:self action:@selector(rightBarButtonItemClicked:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    /*******************实时地理位置共享***************/
//    [self registerClass:[RealTimeLocationStartCell class] forCellWithReuseIdentifier:RCRealTimeLocationStartMessageTypeIdentifier];
//    [self registerClass:[RealTimeLocationEndCell class] forCellWithReuseIdentifier:RCRealTimeLocationEndMessageTypeIdentifier];
//    [self registerClass:[RCUnknownMessageCell class] forCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier];
    __weak typeof(&*self) weakSelf = self;
    [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:self.conversationType targetId:self.targetId success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
        weakSelf.realTimeLocation = realTimeLocation;
        [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
        [weakSelf updateRealTimeLocationStatus];
    } error:^(RCRealTimeLocationErrorCode status) {
    }];
    
    /******************实时地理位置共享**************/
    
    ///注册自定义测试消息Cell
    [self registerClass:[RCDBusinessCardCell class] forMessageClass:[RCDBusinessCardMessage class]];
    [self registerClass:[RCDPublicCell class] forMessageClass:[RCDPublicMessage class]];
    [self registerClass:[RCDCollectionCell class] forMessageClass:[RCDCollectionMessage class]];
    [self registerClass:[RealTimeLocationStartCell class] forMessageClass:[RCRealTimeLocationStartMessage class]];
    [self registerClass:[RealTimeLocationEndCell class] forMessageClass:[RCRealTimeLocationEndMessage class]];
    [self registerClass:[RCDRedPacketsCell class] forMessageClass:[RCDRedPacketsMessage class]];
    
    [self notifyUpdateUnreadMessageCount];
    
    [self.chatSessionInputBarControl.pluginBoardView removeAllItems];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_Picture"] title:@"照片" tag:PLUGIN_BOARD_ITEM_ALBUM_TAG];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_Camera"] title:@"拍摄" tag:PLUGIN_BOARD_ITEM_CAMERA_TAG];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_Voice"] title:@"语音通话" tag:PLUGIN_BOARD_ITEM_VOIP_TAG];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_Video"] title:@"视频通话" tag:PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_BusinessCard"] title:@"分享名片" tag:PLUGIN_BOARD_ITEM_BUSINESSCARD_TAG];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_Location"] title:@"分享位置" tag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_RedPacket"] title:@"红包" tag:PLUGIN_BOARD_ITEM_REDPACKETS_TAG];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage RC_BundleImgName:@"RCDPluginBoard_Collection"] title:@"分享收藏" tag:PLUGIN_BOARD_ITEM_COLLECTION_TAG];
    
    //默认输入类型为语音
    self.defaultInputType = RCChatSessionInputBarInputExtention;
    
    //***********如何在会话界面插入提醒消息***********************
    
    self.enableContinuousReadUnreadVoice = YES;//开启语音连读功能
    
    //打开单聊强制从demo server 获取用户信息更新本地数据库 临时注释
    if (self.conversationType == ConversationType_PRIVATE) {
        //如果是单聊，不显示发送方昵称
        self.displayUserNameInCell = NO;
        
        //             融云 更新本地 个人数据
        [[RCDHttpTool shareInstance] updateUserInfo:self.targetId success:^(RCDUserInfo *user) {
            if(![user.isAlso isEqualToString:@"Complete"] ){
                UIBarButtonItem *rightBarButton1 = [UIBarButtonItem RC_RightButtonItemWithImageName:@"RCD_Private_addFriend" buttonRect:CGRectMake(0, 8, 30, 23) imageRect:CGRectMake(15, 5, 15, 20) Target:self action:@selector(addFriend:)];
                UIBarButtonItem *rightBarButton2 = [UIBarButtonItem RC_RightButtonItemWithImageName:@"ic_action_overflow_dark" buttonRect:CGRectMake(0, 8, 30, 23) imageRect:CGRectMake(15, 5, 15, 20) Target:self action:@selector(rightBarButtonItemClicked:)];
                self.navigationItem.rightBarButtonItems = @[rightBarButton2,rightBarButton1];
            }
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
        } failure:^(NSError *err) {}];
    }else if(self.conversationType == ConversationType_GROUP && self.title.length == 0){
        [self groupRefreshNotification:nil];
    }
    
    [self requestBP:nil];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"chatBackImage%@",@""]];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        CGFloat width = image.size.width > RC_SCREEN_WIDTH?RC_SCREEN_WIDTH:image.size.width;
        CGFloat height = image.size.width > RC_SCREEN_WIDTH ? image.size.height * (RC_SCREEN_WIDTH / image.size.width) : image.size.height;
        self.backgroundImage.width = width;
        self.backgroundImage.height = height;
        self.backgroundImage.center = self.view.center;
        self.backgroundImage.image = image;
    }else{
        self.view.backgroundColor = [UIColor trzx_BackGroundColor];
    }
    
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    [self addNotification];
    
    //test
    if (self.isChangeEdgeTopBool) {
        self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(50, 0, 10, 0);
    }else{
        self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor trzx_BackGroundColor];
    [self.chatSessionInputBarControl addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatSessionInputBarControl.mas_bottom);
        make.left.equalTo(self.chatSessionInputBarControl);
        make.right.equalTo(self.chatSessionInputBarControl);
        make.height.mas_equalTo(RC_SCREEN_HEIGHT * 0.5);
    }];
    self.chatSessionInputBarControl.emojiBoardView.backgroundColor = [UIColor trzx_BackGroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:248/255.0 alpha:1]];
}

#pragma mark - Override 重写父类方法
/*!
 点击扩展功能板中的扩展项的回调
 
 @param pluginBoardView 当前扩展功能板
 @param tag             点击的扩展项的唯一标示符
 */
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    
    switch (tag) {
        case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
            NSArray *array;
            if (self.conversationType == ConversationType_GROUP) {
                array = @[[RCDChooseModel modelWithStr:@"发送位置"]];
            }else{
                array = @[[RCDChooseModel modelWithStr:@"发送位置"],
                          [RCDChooseModel modelWithStr:@"共享实时位置"]];
            }
            [RCDChooseView ChooseViewWithArray:array didClickBlock:^(NSUInteger index) {
                switch (index) {
                    case 1:{
                        RCNewLocationPickerViewController *locationVC = [[RCNewLocationPickerViewController alloc]init];
                        locationVC.targetId = self.targetId;
                        locationVC.conversationType = self.conversationType;
                        [self.navigationController pushViewController:locationVC animated:YES];
                    }
                        break;
                    case 2:{
                        [self showRealTimeLocationViewController];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        case PLUGIN_BOARD_ITEM_BUSINESSCARD_TAG:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            RCDAddressBookViewController *addressBookVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddressBookViewController"];
            addressBookVC.selectedPresent = YES;
            addressBookVC.conversationType = self.conversationType;
            addressBookVC.conversationTargetId = self.targetId;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addressBookVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case PLUGIN_BOARD_ITEM_COLLECTION_TAG:{
            UIViewController  *collectionVC = [[CTMediator sharedInstance] CollectionViewController];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:collectionVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case PLUGIN_BOARD_ITEM_REDPACKETS_TAG:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
            UIViewController *redPacketsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDRedPacketsViewController"];
            [redPacketsVC setValue:@(self.conversationType) forKey:@"conversationType"];
            [redPacketsVC setValue:self.targetId forKey:@"targetId"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:redPacketsVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case PLUGIN_BOARD_ITEM_VOIP_TAG:{
            if(self.conversationType == ConversationType_GROUP){
                if(self.groupInfo){
                    [self public_board_item_voip_tagDidClick];
                }else{
                    [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *groupInfo) {
                        self.groupInfo = groupInfo;
                        [self public_board_item_voip_tagDidClick];
                    }];
                }
                
                return;
            }else if(self.conversationType == ConversationType_PRIVATE){
                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            }
        }
            break;
        case PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG:{
            if(self.conversationType == ConversationType_PRIVATE){
                RCDCallSingleCallViewController *singleCallViewController = [[RCDCallSingleCallViewController alloc] initWithOutgoingCall:self.targetId mediaType:RCCallMediaVideo];
                [self presentViewController:singleCallViewController animated:YES completion:nil];
                
            }else if(self.conversationType == ConversationType_GROUP){
                if(self.groupInfo){
                    [self public_board_item_video_tagDidCLick];
                }else{
                    [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *groupInfo) {
                        self.groupInfo = groupInfo;
                        [self public_board_item_video_tagDidCLick];
                    }];
                    return;
                }
            }
        }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor trzx_TextColor];
            UIFont *font = [UIFont boldSystemFontOfSize:19.f];
            NSDictionary *textAttributes = @{
                                             NSFontAttributeName : font,
                                             NSForegroundColorAttributeName :[UIColor trzx_TitleColor]
                                             };
            [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
            [[UINavigationBar appearance] setTintColor:[UIColor trzx_TextColor]];
            break;
    }
}

/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
    RCMessageContent *messageContent = model.content;
    RCMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        RealTimeLocationStartCell *__cell = [collectionView
                                             dequeueReusableCellWithReuseIdentifier:RCRealTimeLocationStartMessageTypeIdentifier
                                             forIndexPath:indexPath];
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        //__cell.locationDelegate=self;
        cell = __cell;
        return cell;
    } else if ([messageContent isMemberOfClass:[RCRealTimeLocationEndMessage class]]) {
        RealTimeLocationEndCell *__cell = [collectionView
                                           dequeueReusableCellWithReuseIdentifier:RCRealTimeLocationEndMessageTypeIdentifier
                                           forIndexPath:indexPath];
        [__cell setDataModel:model];
        cell = __cell;
        return cell;
    } else if ([messageContent isMemberOfClass:[RCDTestMessage class]]) {
        RCDTestMessageCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:RCDTestMessageTypeIdentifier
                                    forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    } else {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

/*!
 点击Cell内容的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    self.closeInputBool = YES;
    if ([model.objectName isEqualToString:@"RC:LBSMsg"]) {
        
        RCLocationMessage *locationMessage = (RCLocationMessage *)model.content;
        
        RCNewLocationViewController *location = [[RCNewLocationViewController alloc]init];
        location.location = locationMessage.location;
        
        location.locationName = locationMessage.locationName;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:location];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self.navigationController pushViewController:location animated:YES];
        return ;
    }else if(([model.objectName isEqualToString:RCBusinessCardMessageTypeIdentifier])){//分享名片
        RCDBusinessCardMessage *message = (RCDBusinessCardMessage *)model.content;
        [self didTapCellPortrait:message.userId];
    }else if(([model.objectName isEqualToString:RCCollectionMessageTypeIdentifier])){//分享收藏
        RCDCollectionMessage *message = (RCDCollectionMessage *)model.content;
        [self didTapCollection:message.collectionType mid:message.collectionId];
    }else if([model.objectName isEqualToString:RCPublicServiceMessageTypeIdentifier]){
        RCDPublicMessage *publicMessage = (RCDPublicMessage *)model.content;
        RCDPublicServiceProfileViewController *serviceProfileVC = [[RCDPublicServiceProfileViewController alloc] init];
        RCPublicServiceProfile *profile = [[RCPublicServiceProfile alloc]init];
        profile.name = publicMessage.publicName;
        profile.introduction = publicMessage.introduction;
        profile.portraitUrl = publicMessage.photo;
        profile.publicServiceId = publicMessage.publicId;
        serviceProfileVC.profile = profile;
        serviceProfileVC.publicId = publicMessage.publicId;
        [self.navigationController pushViewController:serviceProfileVC animated:YES];
    }else if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    }else if (![[RCDataBaseManager shareInstance] getVoiceRecordMessageId:[NSString stringWithFormat:@"%ld",model.messageId]]) {//消除未读消息
        if ([model.objectName isEqualToString:@"RC:VcMsg"]) {
            [[RCDataBaseManager shareInstance] insertVoiceRecordMessageId:[NSString stringWithFormat:@"%ld",model.messageId]];
        }
    }
    [super didTapMessageCell:model];
}

/**
 点击收藏

 @param collectionType 收藏类型
 @param mid            目标id
 */
-(void)didTapCollection:(NSString *)collectionType mid:(NSString *)mid{
    if ([collectionType isEqualToString:@"online"] ||
        [collectionType isEqualToString:@"course"]) {
        // 跳转课程
        
//        CourseDetailsViewController *player = [[CourseDetailsViewController alloc]init];
//        player.mid = mid;
//        player.type = 1;
//        [self.navigationController pushViewController:player animated:true];
        
    } else if ([collectionType isEqualToString:@"otoSchool"]) {
        // 跳转一对一约见
//        ConsultingDetailsViewController *otoDetailsVC = [[ConsultingDetailsViewController alloc] init];
//        otoDetailsVC.mid = mid;
//        [self.navigationController pushViewController:otoDetailsVC animated:true];
    } else if ([collectionType isEqualToString:@"video"]) {//直播

        // 跳转直播
//        LiveListPlayViewController *liveListPlayViewController = [[LiveListPlayViewController alloc] init];
//        liveListPlayViewController.mid = mid;
//        [self.navigationController pushViewController:liveListPlayViewController animated:true];
        
    }else if ([collectionType isEqualToString:@"project"]) {
        // 测试注释
//        UIViewController *projectVC = [[CTMediator sharedInstance] projectDetailViewController:mid];
//        [self.navigationController pushViewController:projectVC animated:YES];
    }else if ([collectionType isEqualToString:@"investor"]||
              [collectionType isEqualToString:@"investorHome"]) {

        UIViewController *investorVC = [[CTMediator sharedInstance] investorDetailViewController:mid];
        [self.navigationController pushViewController:investorVC animated:YES];
    }else if([collectionType isEqualToString:@"userHome"]){
        [self didTapCellPortrait:mid];
    }else if([collectionType isEqualToString:@"bp"]){
        [[RCDHttpTool shareInstance] getPlanApiDetailDataWithMid:mid SuccessBlock:^(id json) {
            if (json[@"url"]) {
                [self jumpPDFViewController:json[@"url"] title:@"商业计划书"];
            }
        } FailureBlick:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }else if([collectionType isEqualToString:@"live"]){
        
        // 跳转在线直播
//        [[Kipo_NetAPIManager sharedManager] request_LiveStreamVo_Api_info_mid:mid andBlock:^(id data, NSError *error) {
//            if (data) {
//                if ([data[@"statu"] isEqualToString:@"delete"]) {
//                    [LCProgressHUD showInfoMsg:@"该直播已删除"];
//                }else if([data[@"statu"] isEqualToString:@"wait"]){
//                    [LCProgressHUD showInfoMsg:@"等待生成回看视频"];
//                }else if([data[@"statu"] isEqualToString:@"normal"]){
//                    LatestLiveModel *model = [LatestLiveModel mj_objectWithKeyValues:[data objectForKey:@"data"]] ;
//                    
//                    if([model.liveOrVideo isEqualToString:@"live"]){
//                        
//                        [[Kipo_NetAPIManager sharedManager] request_LiveStream_Api_StartWatching_liveId:model.ID andBlock:^(id data, NSError *error) {
//                            
//                            if (data) {
//                                //  观众进入直播间
//                                RCDHostUserInfo *rcdLiveUserInfo = [[RCDHostUserInfo alloc]init];
//                                rcdLiveUserInfo.hostUserName = model.userName;
//                                rcdLiveUserInfo.hostImg = model.liveImg;
//                                rcdLiveUserInfo.hostUserId = model.userId; // 主播userId
//                                rcdLiveUserInfo.mid = model.ID; // 直播id
//                                
//                                LiveShowViewController *chatRoomVC = [[LiveShowViewController alloc]init];
//                                chatRoomVC.conversationType = ConversationType_CHATROOM;
//                                chatRoomVC.targetId = model.liveRoomId; // 聊天室id
//                                chatRoomVC.contentURL = model.palyR; // 播放地址URL
//                                chatRoomVC.isScreenVertical = YES;
//                                chatRoomVC.liveTitle = model.title; // 直播标题
//                                chatRoomVC.liveImage = model.liveImg; // 直播封面
//                                chatRoomVC.shareUrl = model.shareUrl; // 分享URL
//                                chatRoomVC.rcdHostUserInfo = rcdLiveUserInfo; // 主播信息
//                                
//                                
//                                [self.navigationController setNavigationBarHidden:YES];
//                                [self presentViewController:chatRoomVC animated:true completion:^{
//                                }];
//                            }
//                            
//                        }];
//                        
//                    }else{
//                        
//                        
//                        LiveListPlayViewController *liveListPlayViewController = [[LiveListPlayViewController alloc] init];
//                        model.mid = model.ID;
//                        liveListPlayViewController.mid = model.mid;
//                        [self.navigationController pushViewController:liveListPlayViewController animated:true];
//                        liveListPlayViewController.backLiveListPlayAction = ^(BOOL mid){
//                            
//                        };
//                    }
//                    //=========================
//                }
//                
//                //===========================
//            }
//        }];
    }else if([collectionType isEqualToString:@"publicWeb"]){
        if([mid rangeOfString:@"---"].location == NSNotFound){
            return;
        }
        NSArray *array = [mid componentsSeparatedByString:@"---"];
        RCPublicServiceProfile *profile = [[RCPublicServiceProfile alloc]init];
//        viewUrl+"---"+public_service_id+"---"+public_name+"---"+public_img+"---"+public_content
        profile.publicServiceId = array[1];
        profile.name = array[2];
        profile.portraitUrl = array[3];
        profile.introduction = array[4];
        RCDPublicWebViewController *publicWebVC = [[RCDPublicWebViewController alloc] init];
        publicWebVC.webURL = array[0];
        publicWebVC.profile = profile;
        [self.navigationController pushViewController:publicWebVC animated:YES];
    }else if(([collectionType isEqualToString:@"ResourcesReq"])){
        // 跳转需求详情
//        DemandResourDetailsViewController *Controller = [DemandResourDetailsViewController alloc];
//        Controller.releaseStr = mid;//资源的ID
//        [self.navigationController pushViewController:Controller animated:YES];
    }
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param model 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model{
    
    __block NSMutableArray *tempImage = [NSMutableArray array];
    [self.conversationDataRepository enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[RCMessageModel class]]) {
            RCMessageModel *messageModel = obj;
            if ([messageModel.content isKindOfClass:[RCImageMessage class]]) {
                RCImageMessage *imageMessage = (RCImageMessage *)messageModel.content;
                [tempImage addObject:imageMessage.imageUrl];
            }
        }
    }];
    __block NSUInteger currentIndex;
    [tempImage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.content isKindOfClass:[RCImageMessage class]]) {
            RCImageMessage *imageMessage = (RCImageMessage *)model.content;
            if ([obj isEqualToString:imageMessage.imageUrl]) {
                currentIndex = idx;
            }
        }
    }];
    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [tempImage count];i++){
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = tempImage[i];// 加载网络图片大图地址
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:currentIndex];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    
    [self presentViewController:bvc animated:YES completion:nil];
}

/*!
 即将显示消息Cell的回调
 
 @param cell        消息Cell
 @param indexPath   该Cell对应的消息Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的显示和某些属性。
 */
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    [super willDisplayMessageCell:cell atIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
        RCDUserInfo *info = [[RCDataBaseManager shareInstance] getUserByUserId:cell.model.senderUserId];
        textCell.nicknameLabel.text = info.name;
        
    }else if ([cell isMemberOfClass:[RCImageMessageCell class]]) {
        RCImageMessageCell *imageCell = (RCImageMessageCell *)cell;
        imageCell.bubbleBackgroundView.image = nil;
    }else if ([cell isKindOfClass:[RCVoiceMessageCell class]]) {
        RCVoiceMessageCell *voiceCell = (RCVoiceMessageCell *)cell;
        if ([[RCDataBaseManager shareInstance] getVoiceRecordMessageId:[NSString stringWithFormat:@"%ld",voiceCell.model.messageId]]){
            voiceCell.voiceUnreadTagView.hidden = YES;
        }
        voiceCell.voiceDurationLabel.font = [UIFont systemFontOfSize:15];
    }else if([cell isKindOfClass:[RCLocationMessageCell class]]){
        RCLocationMessageCell *locationCell = (RCLocationMessageCell *)cell;
    }
}

/*!
 长按Cell内容的回调
 
 @param model 消息Cell的数据模型
 @param view  长按区域的View
 */
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    
    BOOL isChangeBack = YES;
    if([self.chatSessionInputBarControl.inputTextView isFirstResponder]){
        [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
        isChangeBack = NO;
    }
    
    if ([model.content isKindOfClass:[RCVoiceMessage class]] ||
        [model.content isKindOfClass:[RCDCollectionMessage class]] ||
        [model.content isKindOfClass:[RCDPublicMessage class]] ||
        [model.content isKindOfClass:[RCDBusinessCardMessage class]] ||
        [model.content isKindOfClass:[RCLocationMessage class]] ){
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menu1 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteLongPressClick)];
        if(model.messageDirection == MessageDirection_SEND &&
           [[NSNumber numberWithLong:model.sentTime] RC_timeCompareWithInterval:180]){
            UIMenuItem *menu2 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(recallMessageClick)];
            menuController.menuItems = @[menu1,menu2];
        }else{
            menuController.menuItems = @[menu1];
        }
        globalMessModel = model;
        [menuController setMenuVisible:YES animated:YES];
        [menuController setTargetRect:CGRectMake(0, 0, 40, 40) inView:view];
        [menuController update];
        if([model.content isKindOfClass:[RCVoiceMessage class]]){
            [self getTouchImage:view model:model];
        }
    }else{
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        NSMutableArray *temp = [NSMutableArray array];
        UIMenuItem *menu1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(ForwardLongPressClick)];
        [temp addObject:menu1];
        UIMenuItem *menu2 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(CopyLongPressClick)];
        if ([model.content isKindOfClass:[RCTextMessage class]]) {
            [temp addObject:menu2];
        }
        UIMenuItem *menu3 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteLongPressClick)];
        [temp addObject:menu3];

        if(model.messageDirection == MessageDirection_SEND &&
           [[NSNumber numberWithLong:model.sentTime] RC_timeCompareWithInterval:180]){
            UIMenuItem *menu4 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(recallMessageClick)];
            [temp addObject:menu4];
        }
        menuController.menuItems = [NSArray arrayWithArray:temp];
        globalMessModel = model;
        if ([model.content isKindOfClass:[RCImageMessage class]]) {
            RCImageMessage *messageModel = (RCImageMessage *)model.content;
            [[[UIImageView alloc]init] sd_setImageWithURL:[NSURL URLWithString:messageModel.imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                messageModel.originalImage = image;
            }];
        }

            [menuController setMenuVisible:YES animated:YES];
            [menuController setTargetRect:CGRectMake(0, 0, 40, 40) inView:view];
            [menuController update];
        
        if(isChangeBack){
            if ([model.content isKindOfClass:[RCTextMessage class]]) {
                [self getTouchImage:view model:model];
            }
        }
    }
}

-(void)getTouchImage:(UIView *)view model:(RCMessageModel *)model{
    
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *touthView = (UIImageView *)view;
        if (model.messageDirection == MessageDirection_SEND) {
            UIImage *image = touthView.image;
            UIImage * img= [UIImage RC_BundleImgName:@"RCDChat_to_bg_highlighted@2x"];
            img = [img stretchableImageWithLeftCapWidth:image.leftCapWidth topCapHeight:image.topCapHeight];
            touthView.highlightedImage = img;
        }else{
            UIImage *image = touthView.image;
            UIImage * img= [UIImage RC_BundleImgName:@"RCDChat_from_bg_highlighted"];
            img = [img stretchableImageWithLeftCapWidth:image.leftCapWidth topCapHeight:image.topCapHeight];
            touthView.highlightedImage = img;
        }
        touthView.highlighted = YES;
        RecordTouthImage = touthView;
    }
}

/*!
 输入框内输入了@符号，即将显示选人界面的回调
 
 @param selectedBlock 选人后的回调
 @param cancelBlock   取消选人的回调
 
 @discussion 开发者如果想更换选人界面，可以重写方法，弹出自定义的选人界面，选人结束之后，调用selectedBlock传入选中的UserInfo即可。
 */
- (void)showChooseUserViewController:(void (^)(RCUserInfo *selectedUserInfo))selectedBlock
                              cancel:(void (^)())cancelBlock{
    NSLog(@"弹出选择人物");
    //跳转个人聊天页面
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDSendSelectedAddressViewController *selectedAddressBookVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSendSelectedAddressViewController"];
    selectedAddressBookVC.title = @"选择提醒的人";
    selectedAddressBookVC.conversationTargetId = self.targetId;
    selectedAddressBookVC.conversationType = ConversationType_GROUP;
    [selectedAddressBookVC setCallBackUserInfo:^(NSArray *users) {
        NSMutableArray *temp = [NSMutableArray array];
        for (RCDUserInfo *userInfo in users) {
            [temp addObject:userInfo.userId];
        }
        self.sendPersons = temp;
        if (users.count == 1) {
            [self.chatSessionInputBarControl.inputTextView insertText:@"@"];
            selectedBlock(users.firstObject);
        }else if(users.count > 1){
            [self.chatSessionInputBarControl.inputTextView insertText:@"@所有人 "];
        }else{
            [self.chatSessionInputBarControl.inputTextView insertText:@"@"];
        }
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectedAddressBookVC];
    [self presentViewController:nav animated:YES completion:nil];
}

/*!
 即将在聊天界面插入消息的回调
 
 @param message 消息实体
 @return        修改后的消息实体
 
 @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在聊天界面中显示。
 */
- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message{
    return message;
}

/*!
 发送新拍照的图片完成之后，将图片在本地另行存储的回调
 
 @param newImage    图片
 
 @discussion 您可以在此回调中按照您的需求，将图片另行保存或执行其他操作。
 */
- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

/*!
 点击Cell中用户头像的回调
 
 @param userId 头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:userId];
    if (personalHomeVC) {
        [self.navigationController  pushViewController:personalHomeVC animated:YES];
    }
}

/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    } else if ([messageContent isMemberOfClass:[RCDTestMessage class]]) {
        return CGSizeMake(collectionView.frame.size.width, [RCDTestMessageCell getBubbleBackgroundViewSize:(RCDTestMessage *)messageContent].height + 40);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

/**
 *  重写方法实现未注册的消息的显示
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageCell *cell = [collectionView
                           dequeueReusableCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier
                           forIndexPath:indexPath];
    [cell setDataModel:model];
    return cell;
}

/**
 *  重写方法实现未注册的消息的显示的高度
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize) rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                       layout:(UICollectionViewLayout *)collectionViewLayout
                       sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    return CGSizeMake(collectionView.frame.size.width, 66);
}

/*!
 重新发送消息
 
 @param messageContent 消息的内容
 
 @discussion 发送消息失败，点击小红点时，会将本地存储的原消息实体删除，会回调此接口将消息内容重新发送。
 如果您需要重写此接口，请注意调用super。
 */
- (void)resendMessage:(RCMessageContent *)messageContent{
    if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    } else {
        [super resendMessage:messageContent];
    }
}

#pragma mark - Private Method (私有方法)
#pragma mark  Navigation Action

/**
 LeftItem Pressed
 */
- (void)leftBarButtonItemPressed:(id)sender {
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
        [self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出当前界面位置共享会终止，确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    } else {
        [self popupChatViewController];
    }
}

/**
 退出
 */
- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
    [self.realTimeLocation removeRealTimeLocationObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(self.isPopRootNav){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonItemClicked:(id)sender {
    if (self.conversationType == ConversationType_PRIVATE) {
        self.closeInputBool = YES;
        RCDPrivateSettingViewController *settingVC = [[RCDPrivateSettingViewController alloc] init];
        settingVC.conversationType = ConversationType_PRIVATE;
        settingVC.targetId = self.targetId;
        //    settingVC.conversationTitle = self.userName;
        //    //设置讨论组标题时，改变当前聊天界面的标题
        //    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
        //      self.title = discussTitle;
        //    };
        //清除聊天记录之后reload data
        __weak RCDChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
        
    } else if (self.conversationType == ConversationType_DISCUSSION) {
        
        RCDDiscussGroupSettingViewController *settingVC =
        [[RCDDiscussGroupSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        settingVC.conversationTitle = self.title;
        //设置讨论组标题时，改变当前聊天界面的标题
        settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
            self.title = discussTitle;
        };
        //清除聊天记录之后reload data
        __weak RCDChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    //聊天室设置
    else if (self.conversationType == ConversationType_CHATROOM) {
        RCDRoomSettingViewController *settingVC =
        [[RCDRoomSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    //群组设置
    else if (self.conversationType == ConversationType_GROUP) {
        RCDDiscussGroupSettingViewController *settingVC = [[RCDDiscussGroupSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        settingVC.conversationTitle = self.title;
        //设置讨论组标题时，改变当前聊天界面的标题
        settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
            self.title = discussTitle;
        };
        //清除聊天记录之后reload data
        __weak RCDChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    //客服设置
    else if (self.conversationType == ConversationType_CUSTOMERSERVICE) {
        RCDSettingBaseViewController *settingVC = [[RCDSettingBaseViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        //清除聊天记录之后reload data
        __weak RCDChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if (ConversationType_APPSERVICE == self.conversationType ||
              ConversationType_PUBLICSERVICE == self.conversationType) {
        RCPublicServiceProfile *serviceProfile = [[RCIMClient sharedRCIMClient]
                                                  getPublicServiceProfile:(RCPublicServiceType)self.conversationType
                                                  publicServiceId:self.targetId];
        
        RCPublicServiceProfileViewController *infoVC =
        [[RCPublicServiceProfileViewController alloc] init];
        infoVC.serviceProfile = serviceProfile;
        infoVC.fromConversation = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}


/**
 添加好友
 */
-(void)addFriend:(UIBarButtonItem *)button{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDPersonDetailViewController *addViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDPersonDetailViewController"];
    addViewController.title = @"加为好友";
    addViewController.userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:self.targetId];
    [self.navigationController pushViewController:addViewController animated:YES];
}

/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    });
}

#pragma mark - BP Action (BP视图相关操作)
/**
 BP视图 点击(隐藏/显示)
 */
-(void)BPSlidebuttonClick:(UIButton *)button{
    [self BPViewAnimation];
}

///**
// BP视图 拖拽
// */
-(void)panMove:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self BPViewAnimation];
    }
}

/**
 BP 按钮点击
 */
-(void)BPSeeDidClick:(BPHeadView *)headView{
    
    __weak __typeof(self) sfself = self;
    
    RCDBPInfo *BPInfo = headView.BPInfo;
    switch (headView.BPInfo.type) {
        case 0:{// 0=投资人申请BP，1=股东投递BP
            
            if ([headView.BPInfo.createById isEqualToString:[Login curLoginUser].userId]) {
                
                switch (headView.BPInfo.status.intValue) {
                    case 0:{
                        //发送网络请求
                        [[RCDHttpTool shareInstance] requestLoadData_updateByShare:BPInfo.mid SuccessBlock:^(id json) {
                            // 融云提示
//                            [LCProgressHUD showSuccess:@"同意成功"];
                            [sfself requestBP:nil];
                        } FailureBlick:^(NSError *error) {
                            
                        }];
                    }
                        break;
                    case 1:{// 查看
                        [self jumpPDFViewController:headView.BPInfo.businessPlan title:@"商业计划书"];
                    }
                        break;
                    default:
                        break;
                }
                
            }else{
                //查看当前状态
                switch (headView.BPInfo.status.intValue) {
                    case -1://未请求
                        //发送网络请求
                        [self pushIMBPView:headView];
                        break;
                    case 0:// 申请中
                        //发送网络请求
                        // 融云提示
//                        [LCProgressHUD showInfoMsg:@"BP申请中"];
                        break;
                    case 1:{// 查看
                        [self jumpPDFViewController:headView.BPInfo.businessPlan title:@"商业计划书"];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case 1:{// 0=投资人申请BP，1=股东投递BP
            //            股东
            switch (headView.BPInfo.status.intValue) {
                case -1://未投递
                    //发送网络请求
                    [self pushIMBPView:headView];
                    break;
                case 0:{//
                    //发送网络请求
                    [[RCDHttpTool shareInstance] requestLoadData_updateByShare:headView.BPInfo.mid SuccessBlock:^(id json) {
                        // 融云提示
                        //                        [LCProgressHUD showSuccess:@"同意成功"];
                        [sfself requestBP:nil];
                    } FailureBlick:^(NSError *error) {
                        
                    }];
                }
                    break;
                case 1:{//已投递
                    //                    [LCProgressHUD showInfoMsg:@"BP已投递"];
                    [self jumpPDFViewController:headView.BPInfo.businessPlan title:@"商业计划书"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

/**
 BP视图执行动画
 */
-(void)BPViewAnimation{
    RCD_self;
    if (self.isBPOpen) {
        // 如果当前打开 则关闭
        [RCDUtilities setRCD_BPViewShow:NO];
        tiaoImage.image = [UIImage RC_BundleImgName:@"RCDDowmTiao"];
        [UIView animateWithDuration:0.2 animations:^{
            self.BPBackgroundView.y -= BPNumbers * 64;
            sfself.conversationMessageCollectionView.y -= 64 * BPNumbers;
            sfself.conversationMessageCollectionView.height += 64 * BPNumbers;
        }];
        self.isBPOpen = NO;
        
    }else{
        [RCDUtilities setRCD_BPViewShow:YES];
        tiaoImage.image = [UIImage RC_BundleImgName:@"RCDUpTiao"];
        // 如果当前关闭则 打开
        [UIView animateWithDuration:0.2 animations:^{
            self.BPBackgroundView.y += BPNumbers * 64;
            sfself.conversationMessageCollectionView.y += 64 * BPNumbers;
            sfself.conversationMessageCollectionView.height -= 64 * BPNumbers;
        }];
        self.isBPOpen = YES;
    }
}

/**
 弹出确认发送 BP 视图
 */
-(void)pushIMBPView:(BPHeadView *)headView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BPView = [[[NSBundle mainBundle]loadNibNamed:@"IMBPView" owner:nil options:nil]lastObject];
        
        BPView.width = RC_SCREEN_WIDTH;
        
        BPView.y = -64;
        
        //isAgree 关键点
        BPView.BPInfo = headView.BPInfo;
        
        RCD_self;
        [BPView setDeliverButtonBlock:^(UIButton *Button) {
            [sfself requestBP:Button];
        }];
        
        [self.view addSubview:BPView];
        
        [UIView animateWithDuration:0.2 animations:^{
            BPView.y = 64;
        }completion:^(BOOL finished) {
            
        }];
    });
}


/**
 BP请求
 */
-(void)requestBP:(UIButton *)button{
    
    RCD_self;
    switch (button.tag) {
        case DeliverButtonTag1:{//同意
            [[RCDHttpTool shareInstance] requestLoadData_updateByShare:self.BPInfo.mid SuccessBlock:^(id json) {
                // 融云提示
//                [LCProgressHUD showSuccess:@"同意成功"];
                [sfself requestBP:nil];
            } FailureBlick:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
        case DeliverButtonTag2:{//申请

//            [self.investorlistModel requestLoadData_saveByInvestor:self.targetId SuccessBlock:^(id json) {
//                [LCProgressHUD showSuccess:@"申请已发送"];
//                [self requestBP:nil];
//            }];
        }
            break;
        case DeliverButtonTag3:{//投递
            [[RCDHttpTool shareInstance] requestLoadData_saveByInvestor:self.targetId SuccessBlock:^(id json) {
                // 融云提示
//                [LCProgressHUD showSuccess:@"投递已发送"];
                [self requestBP:nil];
            } FailureBlick:^(NSError *error) {
                
            }];
        }
            break;
        default:
            if(self.conversationType == ConversationType_PRIVATE){
                //查询
                [[RCDHttpTool shareInstance] requestLoadData_findInfo:self.targetId SuccessBlock:^(id json) {
                   
                    NSArray *temp = [RCDBPInfo mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    if (temp.count != 0) {
                        self.BPInfo = temp.firstObject;
                        
                        if (self.headView != nil) {
                            self.headView.BPInfo = self.BPInfo;
                        }else{
                            [self AddBPHeadViewBPHeadViewType:BPHeadViewTypeProject1 RCDBPInfo:self.BPInfo];
                        }
                        //滚到最下面一行
                        [self scrollToBottomAnimated:NO];
                    }
                } FailureBlick:^(NSError *error) {
                    
                }];
                break;
            }
    }
}

// BP相关注释
/**
 *  添加BP headView
 */
-(void)AddBPHeadViewBPHeadViewType:(BPHeadViewType)HeadViewType RCDBPInfo:(RCDBPInfo *)BPInfo{
    
    //    if (HeadViewType == BPHeadViewTypeProject1) {
    if (!self.headView) {
        BPHeadView *headView = [BPHeadView BPHeadViewInitAnimation:BPInfo];
        RCD_self;
        [headView setBPButtonClickBlock:^(BPButtonType buttonType ,BPHeadView *headView) {
            
            switch (buttonType) {
                case BPButtonTypeHead:
                    [sfself BPHeadImageClick:headView];
                    break;
                case BPButtonTypeAction:
//                    [sfself BPHeadImageClick:headView];
                    [sfself BPSeeDidClick:headView];
                    //                    weakSelf.headView = nil;
                    break;
                default:
                    break;
            }
        }];
        
        if (HeadViewType == BPHeadViewTypeProject1) {
            headView.frame = CGRectMake(0, 0, RC_SCREEN_WIDTH, 64);
            _headView = headView;
            _headView.HeadViewType = BPHeadViewTypeProject1;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, RC_SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [UIColor trzx_BackGroundColor];
            [_headView addSubview:lineView];
        }
        [self.BPBackgroundView addSubview:headView];
    }
}

// BP相关注释
/**
 BPHeadView 按钮点击
 */
-(void)BPHeadImageClick:(BPHeadView *)headView{
    
    switch (headView.direction) {// 0=投资人申请BP，1=股东投递BP
        case HeadViewDirectionProject:{//路演项目
            // 测试注释
//            UIViewController *projectVC = [[CTMediator sharedInstance] projectDetailViewController:headView.BPInfo.projectzId];
//            [self.navigationController pushViewController:projectVC animated:YES];
        }
            break;
        case HeadViewDirectionInvestor:{//投资人
            UIViewController *investorVC = [[CTMediator sharedInstance] investorDetailViewController:self.targetId];
            [self.navigationController pushViewController:investorVC animated:YES];
        }
        default:
            break;
    }
}

/**
 跳转PDF
 
 @param url BP地址
 */
-(void)jumpPDFViewController:(NSString *)url title:(NSString *)title{
    
        // 测试注释
//    UIViewController *webVC = [[CTMediator sharedInstance] webViewControllerWithWebURL:url];
//    [self.navigationController pushViewController:webVC animated:true];
}

#pragma mark 视频通话/语音通话
/**
 群组语音通话点击
 */
-(void)public_board_item_voip_tagDidClick{
    NSMutableArray *templaceArray = [NSMutableArray array];
    for (RCDUserInfo *userInfo in self.groupInfo.users) {
        
        if(![userInfo.userId isEqualToString:[Login curLoginUser].userId]){
            [templaceArray addObject:userInfo.userId];
        }
    }
    RCCallSelectMemberViewController *selectMemberViewController = [[RCCallSelectMemberViewController alloc] initWithConversationType:self.conversationType targetId:self.targetId mediaType:RCCallMediaAudio exist:nil success:^(NSArray *addUserIdList) {
        //成功
        [[RCCall sharedRCCall ] startMultiCallViewController:ConversationType_GROUP targetId:self.targetId mediaType:RCCallMediaAudio userIdList:addUserIdList];
    }];
    selectMemberViewController.listingUserIdList = templaceArray;
    [self presentViewController:selectMemberViewController animated:YES completion:nil];
}

/**
 群组视频通话点击
 */
-(void)public_board_item_video_tagDidCLick{
    
    NSMutableArray *templaceArray = [NSMutableArray array];
    for (RCDUserInfo *userInfo in self.groupInfo.users) {
        
        if(![userInfo.userId isEqualToString:[Login curLoginUser].userId]){
            [templaceArray addObject:userInfo.userId];
        }
    }
    RCCallSelectMemberViewController *selectMemberViewController = [[RCCallSelectMemberViewController alloc] initWithConversationType:self.conversationType targetId:self.targetId mediaType:RCCallMediaVideo exist:nil success:^(NSArray *addUserIdList) {
        //成功
        [[RCCall sharedRCCall ] startMultiCallViewController:ConversationType_GROUP targetId:self.targetId mediaType:RCCallMediaVideo userIdList:addUserIdList];
        
    }];
    selectMemberViewController.listingUserIdList = templaceArray;
    [self presentViewController:selectMemberViewController animated:YES completion:nil];
}

#pragma mark  长按菜单 列表 方法
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)ForwardLongPressClick{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDSelectPersonViewController *selectPersonVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSelectPersonViewController"];
    selectPersonVC.forwardMessage = globalMessModel;
    [self.navigationController pushViewController:selectPersonVC animated:YES];
}
#pragma mark  复制 粘贴

/**
 复制
 */
-(void)CopyLongPressClick{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if ([globalMessModel.content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *imageMessage = (RCImageMessage *)globalMessModel.content;
        pasteboard.image = imageMessage.thumbnailImage;
    }
    
    if ([globalMessModel.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *text = (RCTextMessage *)globalMessModel.content;
        pasteboard.string = text.content;
    }
}

/**
 粘贴
 */
//-(void)pase{
//    
//    if ([globalMessModel.content isKindOfClass:[RCImageMessage class]]) {
//        
//        if(globalMessModel != nil){
//            [[RCIM sharedRCIM] sendMediaMessage:self.conversationType targetId:self.targetId content:globalMessModel.content pushContent:nil pushData:nil progress:^(int progress, long messageId) {
//                
//            } success:^(long messageId) {
//                
//            } error:^(RCErrorCode errorCode, long messageId) {
//                
//            } cancel:^(long messageId) {
//                
//            }];
//        }
//    }
//    
//    if ([globalMessModel.content isKindOfClass:[RCTextMessage class]]) {
//        RCTextMessage *text = (RCTextMessage *)globalMessModel.content;
//        self.chatSessionInputBarControl.inputTextView.text = text.content;
//    }
//}

/**
 删除消息并更新UI
 */
-(void)deleteLongPressClick{
    [self deleteMessage:globalMessModel];
}

/**
 撤回消息
 */
-(void)recallMessageClick{
    [self recallMessage:globalMessModel.messageId];
}

#pragma mark - Delegate 代理方法
#pragma mark  RCIMReceiveMessageDelegate
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    if ([message.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage *)message.content;
        
        if ([textMessage.extra isEqualToString:@"SysTxt"]) {
            // BP相关注释
//            [self requestBP:nil];
        }
    }
}

#pragma mark RCRealTimeLocationObserver 地理位置
/*!
 实时位置共享状态改变的回调
 
 @param status  当前实时位置共享的状态
 */
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

/*!
 参与者位置发生变化的回调
 
 @param location    参与者的当前位置
 @param userId      位置发生变化的参与者的用户ID
 */
- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

/*!
 有参与者加入实时位置共享的回调
 
 @param userId      加入实时位置共享的参与者的用户ID
 */
- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享", userId]];
            }
        }];
    }
}

/*!
 有参与者退出实时位置共享的回调
 
 @param userId      退出实时位置共享的参与者的用户ID
 */
- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享", userId]];
            }
        }];
    }
}

/*!
 更新位置信息失败的回调
 
 @param messageId     失败信息
 */
- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
    });
}


/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController{
    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    }else if([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE){
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc animated:YES completion:^{
        
    }];
}

- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
                break;
            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
                    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
                        if (userInfo.name.length) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%@正在共享位置", userInfo.name]];
                            });
                        }
                    }];
                } else {
                    if(participants.count<1)
                        [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark  RealTimeLocationStatusViewDelegate
/**
 加入共享位置
 */
- (void)onJoin {
    [self showRealTimeLocationViewController];
}

/**
 获取共享位置状态
 */
- (RCRealTimeLocationStatus)getStatus {
    return [self.realTimeLocation getStatus];
}

/**
 显示共享位置
 */
- (void)onShowRealTimeLocationView {
    [self showRealTimeLocationViewController];
}

/**
 加入位置共享 显示文字调用

 @param text 需要显示的文本
 */
- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}

#pragma mark RCChatSessionInputBarControlDelegate
/*!
 点击键盘Return按钮的回调
 
 @param inputTextView 文本输入框
 */
- (void)inputTextViewDidTouchSendKey:(UITextView *)inputTextView{
    RCTextMessage *textMessage;
    if ([inputTextView.text containsString:@"@所有人"]) {
        textMessage = [RCTextMessage messageWithContent:inputTextView.text];
        RCMentionedInfo *mentioned = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_All userIdList:self.sendPersons mentionedContent:inputTextView.text];
        [textMessage setMentionedInfo:mentioned];
    }else if([inputTextView.text hasPrefix:@"@"]){
        textMessage = [RCTextMessage messageWithContent:inputTextView.text];
        RCMentionedInfo *mentioned = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_Users userIdList:self.sendPersons mentionedContent:inputTextView.text];
        [textMessage setMentionedInfo:mentioned];
    }else{
        textMessage = [RCTextMessage messageWithContent:inputTextView.text];
    }
    [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:textMessage pushContent:@"你有新的消息请注意查收" pushData:nil success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
}

#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.realTimeLocation quitRealTimeLocation];
        [self popupChatViewController];
    }
}

#pragma mark  UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *icImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [[RCIM sharedRCIM] sendMediaMessage:self.conversationType targetId:self.targetId content:[RCImageMessage messageWithImage:icImage] pushContent:@"您有新的消息,请注意查收" pushData:nil progress:^(int progress, long messageId) {
    } success:^(long messageId) {
    } error:^(RCErrorCode errorCode, long messageId) {
    } cancel:^(long messageId) {
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  RCLocationPickerViewControllerDelegate
-(void)locationPicker:(RCLocationPickerViewController *)locationPicker didSelectLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName mapScreenShot:(UIImage *)mapScreenShot{
    [locationPicker.navigationController popViewControllerAnimated:YES];
    RCLocationMessage *locationVC = [RCLocationMessage messageWithLocationImage:mapScreenShot location:location locationName:locationName];
    [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:locationVC pushContent:@"你有新的消息请注意查收" pushData:nil success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
//        融云提示
//        [LCProgressHUD showFailure:@"发送失败"];   // 显示失败
    }];
}

#pragma mark - NSNotification
/**
 *  注册通知
 */
-(void)addNotification{
    //注册通知 更换背景图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector: @selector(replaceBakcground:) name:replaceRCDChatViewControllerBakcground object:nil];
    //系统 UIMenu 隐藏通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuControllerWillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    
    if(self.conversationType == ConversationType_GROUP){
        //更新群组通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupRefreshNotification:) name:RCDGroupRefreshNotification object:nil];
    }else if(self.conversationType == ConversationType_PRIVATE){
        //删除好友通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriendNotification:) name:RCDDeleteFriendNotification object:nil];
    }
}

/**
 群组更新通知
 */
-(void)groupRefreshNotification:(NSNotification *)notifi{
    [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *group) {
        self.title = group.inName;
        self.groupInfo = group;
    }];
}

/**
 删除好友通知
 */
-(void)deleteFriendNotification:(NSNotification *)notifi{
    if ([notifi.object isKindOfClass:[NSString class]]) {
        if ([notifi.object isEqualToString:self.targetId]) {
            [self leftBarButtonItemPressed:nil];
        }
    }
}

/**
 更换背景图片通知
 */
-(void)replaceBakcground:(NSNotification *)notifi{
    
    UIImage *image = notifi.object;
    
    CGFloat width = image.size.width > RC_SCREEN_WIDTH?RC_SCREEN_WIDTH:image.size.width;
    CGFloat height = image.size.width > RC_SCREEN_WIDTH ? image.size.height * (RC_SCREEN_WIDTH / image.size.width) : image.size.height;
    self.backgroundImage.width = width;
    self.backgroundImage.height = height;
    self.backgroundImage.center = self.view.center;
    self.backgroundImage.image = image;
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    // 聊天背景
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"chatBackImage%@",[Login curLoginUser].userId]];
}

/**
 UIMenuController 隐藏
 */
-(void)menuControllerWillHideMenu:(NSNotification *)noti{
    if (RecordTouthImage) {
        
        RecordTouthImage.highlighted = NO;
        
        RecordTouthImage = nil;
    }
}

- (void)setRealTimeLocation:(id<RCRealTimeLocationProxy>)realTimeLocation {
    _realTimeLocation = realTimeLocation;
}

- (RealTimeLocationStatusView *)realTimeLocationStatusView {
    if (!_realTimeLocationStatusView) {
        _realTimeLocationStatusView = [[RealTimeLocationStatusView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        _realTimeLocationStatusView.delegate = self;
        [self.view addSubview:_realTimeLocationStatusView];
    }
    return _realTimeLocationStatusView;
}


#pragma mark - Properties 懒加载

//-(InvestorsNetworkTool *)investorlistModel{
//    if (!_investorlistModel) {
//        _investorlistModel =[[InvestorsNetworkTool alloc]init];
//    }
//    return _investorlistModel;
//}

-(UIImageView *)inputToolBackView{
    if (!_inputToolBackView) {
        _inputToolBackView = [[UIImageView alloc]init];
        _inputToolBackView.backgroundColor = [UIColor trzx_BackGroundColor];
    }
    return _inputToolBackView;
}

-(UIImagePickerController *)pickerCamera{
    if (!_pickerCamera) {
        _pickerCamera=[[UIImagePickerController alloc]init];
        _pickerCamera.sourceType=UIImagePickerControllerSourceTypeCamera;
        _pickerCamera.delegate=self;
    }
    return _pickerCamera;
}

-(UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RC_SCREEN_WIDTH, RC_SCREEN_HEIGHT)];
        [self.view insertSubview:_backgroundImage atIndex:0];
    }
    return _backgroundImage;
}

-(UIView *)BPBackgroundView{
    
    if (!_BPBackgroundView) {
        self.isBPOpen = YES;
        
        _BPBackgroundView = [[UIView alloc]init];
        _BPBackgroundView.frame = CGRectMake(0, 64, RC_SCREEN_WIDTH, 64 * BPNumbers + 20);
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMove:)];
        UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMove:)];
        
        _BPBackgroundView.backgroundColor = [UIColor clearColor];
        [_BPBackgroundView addGestureRecognizer:pan];
        _BPBackgroundView.userInteractionEnabled = YES;
        [self.navigationController.navigationBar addGestureRecognizer:pan1];
        
        UIButton *slideView = [[UIButton alloc]initWithFrame:CGRectMake(0, 64 * BPNumbers, RC_SCREEN_WIDTH, 70)];
        slideView.userInteractionEnabled = YES;
        slideView.backgroundColor = [UIColor clearColor];
        [slideView addTarget:self action:@selector(BPSlidebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_BPBackgroundView addSubview:slideView];
        //        tiao
        tiaoImage = [[UIImageView alloc]initWithFrame:CGRectMake((RC_SCREEN_WIDTH  - 50 )* 0.5, 2, 50, 15)];
        
        self.conversationMessageCollectionView.y += 64 * BPNumbers;
        self.conversationMessageCollectionView.height -= 64 * BPNumbers;
        
        tiaoImage.image = [UIImage RC_BundleImgName:@"RCDUpTiao"];
        
        if (![RCDUtilities RCD_BPViewShow]) {
            _BPBackgroundView.y -= BPNumbers * 64;
            self.conversationMessageCollectionView.y -= 64 * BPNumbers;
            self.conversationMessageCollectionView.height += 64 * BPNumbers;
            self.isBPOpen = NO;
            tiaoImage.image = [UIImage RC_BundleImgName:@"RCDDowmTiao"];
        }
        
        [slideView addSubview:tiaoImage];
    }
    return _BPBackgroundView;
}

+ (UIViewController *)getStandardViewController:(NSString *)userId title:(NSString *)title{
    
    RCConversation *conversation = [[RCConversation alloc]init];
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = userId;
    conversation.conversationTitle = title;
    
    RCConversationModel *model = [[RCConversationModel alloc]init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:conversation extend:nil];
    model.isTop = false;
    model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_NORMAL;
    model.conversationType = ConversationType_PRIVATE;
    model.objectName = @"RC:TxtMsg";
    
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName = model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    conversationVC.conversation = model;
    conversationVC.unReadMessage = model.unreadMessageCount;
    conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    conversationVC.enableUnreadMessageIcon=YES;
    if (model.conversationType == ConversationType_SYSTEM) {
        conversationVC.userName = @"系统消息";
        conversationVC.title = @"系统消息";
    }
    conversationVC.isChangeEdgeTopBool = YES;
    return conversationVC;
}
    
@end
