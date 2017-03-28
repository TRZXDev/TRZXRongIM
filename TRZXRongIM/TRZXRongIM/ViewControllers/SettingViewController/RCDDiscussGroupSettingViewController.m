//
//  RCDiscussGroupSettingViewController.m
//  RongIMToolkit
//
//  Created by Liv on 15/3/30.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDDiscussGroupSettingViewController.h"
#import "RCDUpdateNameViewController.h"
#import "RCDDiscussSettingCell.h"
#import "RCDDiscussSettingSwitchCell.h"
#import "RCDSelectPersonViewController.h"
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDPersonDetailViewController.h"
#import "RCDataBaseManager.h"
#import "RCDAddFriendViewController.h"
#import "RCDSettingBackgroundViewController.h"
#import "RCDGroupInfo.h"
#import "RCDConversationSettingClearMessageCell.h"
#import "RCDGroupTransferViewController.h"
#import "RCDDscussionHeadManager.h"
#import "RCDGroupChatViewController.h"
#import "RCDCommonDefine.h"

@interface RCDDiscussGroupSettingViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AJPhotoBrowserDelegate,AJPhotoPickerProtocol>

@property (nonatomic, copy) NSString* discussTitle;
@property (nonatomic, copy) NSString* creatorId;
@property (nonatomic, strong) NSMutableDictionary* members;
@property (nonatomic,strong) UIImagePickerController * pickerCamera;
@property (nonatomic,strong) UIImagePickerController * PickerImage;
/**
 是否是群管理
 */
@property (nonatomic)BOOL isOwner;
@property (nonatomic,assign) BOOL isClick;
@property (nonatomic,assign) BOOL isChangeBackground;
@property (nonatomic,strong) RCDGroupInfo * groupInfo;

@property (nonatomic, strong) RCDDscussionHeadManager *groupHeadManager;

@property (nonatomic, strong) UIImageView *tempGroupImage;

@end

@implementation RCDDiscussGroupSettingViewController
#pragma mark - 懒加载
-(UIImagePickerController *)pickerCamera{
    if (!_pickerCamera) {
        _pickerCamera=[[UIImagePickerController alloc]init];
        _pickerCamera.sourceType=UIImagePickerControllerSourceTypeCamera;
        _pickerCamera.delegate=self;
//        _PickerImage.videoQuality = UIImagePickerControllerQualityType640x480;
//        _PickerImage.allowsEditing=YES;
    }
    return _pickerCamera;
}

-(UIImagePickerController *)PickerImage{
    if (!_PickerImage) {
        _PickerImage=[[UIImagePickerController alloc]init];
        _PickerImage.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _PickerImage.delegate=self;
//        [_PickerImage.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
//        _PickerImage.videoQuality = UIImagePickerControllerQualityType640x480;
//        _PickerImage.allowsEditing=YES;
    }
    return _PickerImage;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     _isClick = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //显示顶部视图
    self.headerHidden = NO;
    _members = [[NSMutableDictionary alloc]init];
    
    //添加当前聊天用户
//    if (self.conversationType == ConversationType_PRIVATE) {
//        [RCDHTTPTOOL getUserInfoByUserID:self.targetId
//                              completion:^(RCDUserInfo* user) {
//                                          [self addUsers:@[user]];
//                                          [_members setObject:user forKey:user.userId];
//                              }];
//    }
    
    //添加讨论组成员
    if (self.conversationType == ConversationType_GROUP) {
        [self requestData];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    
//    UIImage *image =[UIImage imageNamed:@"group_quit"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width - 42, 90/2)];
    
//    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"删除并退出" forState:UIControlStateNormal];
    [button setCenter:CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor trzx_YellowColor];
    button.RC_cornerRadius = 6;
    [view addSubview:button];
    self.tableView.tableFooterView = view;
    
//    [self addBackItem];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    self.tableView.backgroundColor = [UIColor trzx_BackGroundColor];
}

-(void)requestData{
    __weak RCDSettingBaseViewController* weakSelf = self;
    // 融云提示
//    [LCProgressHUD showLoading:@"正在加载"];
    [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *group) {
        if (group) {
            // 融云提示
//            [LCProgressHUD hide];
            self.groupInfo = group;
            _creatorId = group.creatorId;
            //1.更新群组头像 (同时会更新到本地)
//            [self.groupHeadManager kipo_setGroupListHeader:self.tempGroupImage groupInfo:group isSave:YES];
            [self.groupHeadManager kipo_setGroupListHeader:nil groupInfo:group isSave:YES];
            
            if ([[Login curLoginUser].userId isEqualToString:group.adminId])
                [weakSelf disableDeleteMemberEvent:NO];
//                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
                self.isOwner = YES;
            }else{
                //                    [weakSelf disableDeleteMemberEvent:YES];
                self.isOwner = NO;
                if (group.openInvitation.integerValue == 0) {
                    [self disableInviteMemberEvent:YES];
                }
                self.header.isAllowedDeleteMember = NO;
            }
            //自己是否在群组里
            BOOL isSide = YES;
            NSMutableArray *users = [NSMutableArray new];
            for (NSDictionary *dict in group.users) {
                RCDUserInfo *userInfo = [RCDUserInfo mj_objectWithKeyValues:dict];
                if ([group.creatorId isEqualToString:userInfo.userId]) {
                    [users insertObject:userInfo atIndex:0];
                }else{
                    [users addObject:userInfo];
                }

                if ([userInfo.userId isEqualToString:[Login curLoginUser].userId]) {
                    isSide = NO;
                }
                [_members     setObject:userInfo forKey:userInfo.userId];
            }
            if (isSide) {
                [self disableInviteMemberEvent:YES];
            }
            [weakSelf addUsers:users];
            [self.header reloadData];
            [self.tableView reloadData];
//        }
    }];
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    if (self.setDiscussTitleCompletion) {
        self.setDiscussTitleCompletion(self.groupInfo.inName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)buttonAction:(UIButton*)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"删除并且退出群聊" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_isChangeBackground) {
        if (buttonIndex==0){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [self presentViewController:self.pickerCamera animated:YES completion:NULL];
            }else{
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"该设备没有摄像头" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else if (buttonIndex==1){
            [self presentViewController:self.PickerImage animated:YES completion:nil];
        }else{
            
        }
    }else{
        if ([actionSheet isEqual:self.clearMsgHistoryActionSheet]) {
            if (buttonIndex == 0) {
                [self clearHistoryMessage];
            }
            
        }else{
            if (0 == buttonIndex) {
                //退出群组
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
                [[RCDHttpTool shareInstance] quitGroup:self.targetId userId:nil complete:^(BOOL result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
                    
                        
                        UIViewController *targetViewController;
                        
                        for (UIViewController *viewController in self.navigationController.childViewControllers) {
                            if ([viewController isKindOfClass:[RCDGroupChatViewController class]]) {
                                targetViewController = viewController;
                            }
                        }
                        if (targetViewController) {
                            [self.navigationController popToViewController:targetViewController animated:YES];
                        }else{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    });
                }];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isOwner) {
        if (section == 0) {
            return 5;
        }else{
            return 4;//self.defaultCells.count + 4;
        }
    } else {
        if (section == 0) {
            return 4;
        }else{
            return 3;//self.defaultCells.count + 2;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44.f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell* cell = nil;
    if (self.isOwner) {//群主
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    RCDDiscussSettingCell *discussCell = [[RCDDiscussSettingCell alloc] initWithFrame:CGRectZero];
                    discussCell.lblDiscussName.text = self.groupInfo.name;
                    discussCell.lblTitle.text = @"群名称";
                    cell = discussCell;
                    _discussTitle = discussCell.lblDiscussName.text;
                }break;
                case 1:{
                    RCDDiscussSettingSwitchCell *switchCell = [[RCDDiscussSettingSwitchCell alloc] initWithFrame:CGRectZero];
                    switchCell.label.text = @"开放成员邀请";
                    if (self.groupInfo && [self.groupInfo.openInvitation isEqualToString:@"1"]) {
                        switchCell.swich.on = YES;
                    }
                    [switchCell.swich addTarget:self action:@selector(openMemberInv:) forControlEvents:UIControlEventTouchUpInside];
                    cell = switchCell;
                }break;
                case 2:{
                    cell = self.defaultCells[0];
                }break;
                case 3:{
                    cell = self.defaultCells[1];
                }break;
                case 4:{
                    RCDDiscussSettingSwitchCell *switchCell = [[RCDDiscussSettingSwitchCell alloc] initWithFrame:CGRectZero];
                    switchCell.label.text = @"保存到群聊";
                    if ([self.groupInfo.isSave isEqualToString:@"1"]) {
                        switchCell.swich.on = YES;
                    }
                    [switchCell.swich addTarget:self action:@selector(saveContactList:) forControlEvents:UIControlEventTouchUpInside];
                    cell = switchCell;
                }break;
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:{
                    cell = self.defaultCells[2];
                }break;
                case 1:{
                    cell = self.defaultCells[3];
                }break;
                case 2:{
                    cell = self.defaultCells[4];
                }break;
                case 3:{
                    RCDConversationSettingClearMessageCell *cell_Complaints =
                    [[RCDConversationSettingClearMessageCell alloc] initWithFrame:CGRectZero];
                    [cell_Complaints.touchBtn addTarget:self
                                                 action:@selector(transferGroup)
                                       forControlEvents:UIControlEventTouchUpInside];
                    cell_Complaints.nameLabel.text = @"管理权转让";
                    cell = cell_Complaints;
                }break;
                default:
                    break;
            }
        }

    }else{//非群主
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    RCDDiscussSettingCell *discussCell = [[RCDDiscussSettingCell alloc] initWithFrame:CGRectZero];
                    discussCell.lblDiscussName.text = self.groupInfo.name;
                    discussCell.lblTitle.text = @"群名称";
                    cell = discussCell;
                    _discussTitle = discussCell.lblDiscussName.text;
                }break;
                case 1:{
                    cell = self.defaultCells[0];
                }break;
                case 2:{
                    cell = self.defaultCells[1];
                }break;
                case 3:{
                    RCDDiscussSettingSwitchCell *switchCell = [[RCDDiscussSettingSwitchCell alloc] initWithFrame:CGRectZero];
                    switchCell.label.text = @"保存到群聊";
                    if ([self.groupInfo.isSave isEqualToString:@"1"]) {
                        switchCell.swich.on = YES;
                    }else{
                        switchCell.swich.on = NO;
                    }
                    [switchCell.swich addTarget:self action:@selector(saveContactList:) forControlEvents:UIControlEventTouchUpInside];
                    cell = switchCell;
                }break;
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:{
                    cell = self.defaultCells[2];
                }break;
                case 1:{
                    cell = self.defaultCells[3];
                }break;
                case 2:{
                    cell = self.defaultCells[4];
                }break;
                default:
                    break;
            }
        }
    }
    return cell;
}

#pragma mark - 设置聊天页面背景
-(void)replaceBackGround:(id)sender{
    RCDSettingBackgroundViewController *settingBackground = [[RCDSettingBackgroundViewController alloc]init];
    settingBackground.chatViewController = self;
    [self.navigationController pushViewController:settingBackground animated:YES];
}

#pragma mark - UIImagePicker delegate
//六、实现ImagePicker delegate 事件
//选取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //获得已选择的图片
    UIImage *icImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *newImage = [icImage RC_imageCompressToTagetSize:CGSizeMake(RC_SCREEN_WIDTH, RC_SCREEN_HEIGHT)];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:replaceRCDChatViewControllerBakcground object:newImage];
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1);

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"chatBackImage%@",[Login curLoginUser].userId]];
    
    _isChangeBackground = NO;
    // 融云提示
//    [LCProgressHUD showSuccess:@"更换成功"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //    //    //上传头像
    //    //    [self.button setBackgroundImage:self.image forState:UIControlStateNormal];
    //    if (picker==_pickerCamera)
    //    {
    //        //将图片保存到相册
    //        UIImageWriteToSavedPhotosAlbum(icImage, self, nil, nil);
    //    }
    //    //    保存到本地
    //    _data = UIImagePNGRepresentation(icImage);
    //    [self shangchuandanzhangtupian];
}

#pragma mark - RCConversationSettingTableViewHeader Delegate
//点击最后一个+号事件
- (void)settingTableViewHeader:(RCConversationSettingTableViewHeader*)settingTableViewHeader indexPathOfSelectedItem:(NSIndexPath*)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray*)users{
    //点击最后一个+号,调出选择联系人UI
    if (indexPathOfSelectedItem.row == settingTableViewHeader.users.count) {
        
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
        RCDSelectPersonViewController* selectPersonVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSelectPersonViewController"];
        [selectPersonVC setSeletedUsers:users];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            if (selectedUsers && selectedUsers.count) {
                NSMutableArray *newUsers = [[NSMutableArray alloc]init];
                for (int i=0;i<selectedUsers.count; i++) {
                    RCDUserInfo *user = (RCDUserInfo *)selectedUsers[i];
                    if (![_members.allKeys containsObject:user.userId]) {
                        [_members setObject:user forKey:user.userId];
                        [newUsers addObject:user];
                    }
                }
                //创建者第一个显示
                RCDUserInfo *creator = _members[_creatorId];
                if(creator){
                    [_members removeObjectForKey:_creatorId];
                    NSMutableArray *users = [[NSMutableArray alloc]initWithArray: _members.allValues];
                    [users insertObject:creator atIndex:0];
                    [self addUsers:users];
                    [_members setObject:creator forKey:creator.userId];
                }else{
                    NSMutableArray *users = [[NSMutableArray alloc]initWithArray: _members.allValues];
                    [self addUsers:users];
                }
                
                [self createDiscussionOrInvokeMemberWithSelectedUsers:selectedUsers];
            }
            
            [selectPersonViewController.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
}

#pragma mark - private method
- (void)createDiscussionOrInvokeMemberWithSelectedUsers:(NSArray*)selectedUsers{
    
    //    __weak RCDSettingViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ConversationType_GROUP == self.conversationType) {
            //invoke new member to current discussion
            
            //加入讨论组
            if(selectedUsers.count != 0){
                NSString *targetId = self.groupInfo.mid;
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.groupInfo.users];
                NSString *userIds = @"";
                for (RCDUserInfo *user in selectedUsers) {
                    if (![tempArray containsObject:user]) {
                        [tempArray addObject:user];
                        userIds = [userIds stringByAppendingString:[NSString stringWithFormat:@"%@,",user.userId]];
                    }
                }
//                userIds = [userIds substringToIndex:userIds.length - 1];
                if (userIds.length) {
                    [[RCDHttpTool shareInstance] joinGroupWithUserIds:userIds groupId:targetId complete:^(BOOL result) {
                        [self.groupHeadManager kipo_updateGroupInfoWithGroupId:self.targetId backGroupInfo:^(RCDGroupInfo *group) {
                            self.groupInfo = group;
                        }];
                    }];
                    
                    self.groupInfo.users = tempArray;
                    //1.更新群组头像 (同时会更新到本地)
//                    [self.groupHeadManager kipo_setGroupListHeader:self.tempGroupImage groupInfo:self.groupInfo isSave:YES];

                }
            }
        }
    });
}

//设置成员邀请权限
- (void)openMemberInv:(UISwitch*)swch{
    [[RCDHttpTool shareInstance] inviteGroupMemberById:self.targetId closeOrOpen:swch.on complete:^(BOOL result) {
    }];
}

//保存到通讯录
-(void)saveContactList:(UISwitch *)swch{
    [[RCDHttpTool shareInstance] saveGroupToList:self.targetId saveOrRemove:swch.on complete:^(BOOL result) {
    }];
}

/**
 管理权转让
 */
-(void)transferGroup{
    //弹出选择人
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
//    [storyboard instantiateViewControllerWithIdentifier:@"RCDGroupTransferViewController"];
    RCDGroupTransferViewController* groupTransferVC = [[RCDGroupTransferViewController alloc] init];
    
    groupTransferVC.groupInfo = self.groupInfo;
    [groupTransferVC setRefresh:^{
        [self requestData];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:groupTransferVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isChangeBackground = NO;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        RCDDiscussSettingCell* discussCell = (RCDDiscussSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
        discussCell.lblTitle.text = @"群名称";
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
        RCDUpdateNameViewController* updateNameViewController = [storyboard instantiateViewControllerWithIdentifier:@"RCDUpdateNameViewController"];
        updateNameViewController.targetId = self.targetId;
        updateNameViewController.displayText = discussCell.lblDiscussName.text;
        updateNameViewController.setDisplayTextCompletion = ^(NSString* text) {
            discussCell.lblDiscussName.text = text;
            _discussTitle = text;
            [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *group) {
                if (group) {
                    self.groupInfo = group;
                    _creatorId = group.creatorId;
                    [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                }
            }];
        };
        [self.navigationController pushViewController:updateNameViewController animated:YES];
    }
}

/**
 *  override
 *
 *  @param users 添加顶部视图显示的user,必须继承以调用父类添加user
 */
- (void)addUsers:(NSArray*)users{
    [super addUsers:users];
}

/**
 *  override 左上角删除按钮回调
 *
 *  @param indexPath indexPath description
 */
- (void)deleteTipButtonClicked:(NSIndexPath*)indexPath{
    RCDUserInfo* user = self.users[indexPath.row];
    
    if ([user.userId isEqualToString:[Login curLoginUser].userId]) {
        return;
    }
    NSString *targetId = self.groupInfo.mid;
    [[RCDHttpTool shareInstance] quitGroup:targetId userId:user.userId complete:^(BOOL result) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.groupInfo.users];
        [tempArray removeObject:user];
        self.groupInfo.users = tempArray;
        //1.更新群组头像 (同时会更新到本地)
        [self.groupHeadManager kipo_setGroupListHeader:self.tempGroupImage groupInfo:self.groupInfo isSave:YES];
        [self.users removeObject:user];
            [self requestData];
    }];
    [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *group) {
        self.groupInfo = group;
    }];
}

- (void)didTipHeaderClicked:(NSString*)userId{

    UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:userId];
    if (personalHomeVC) {
        [self.navigationController pushViewController:personalHomeVC animated:YES];
    }
}


- (void)ComplaintsUser:(id)sender{    
    UIViewController *complaintsVC = [[CTMediator sharedInstance] TRZXComplaint_TRZXComplaintViewController:@{@"type":@"2",                                                                                                     @"targetId":self.targetId,                                                                                                   @"userTitle":self.groupInfo.name}];
    [self.navigationController pushViewController:complaintsVC animated:YES];
}


#pragma mark - AJPhotoPickerProtocol
//点击选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset*)asset{
    
    UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    
    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:@[tempImg] index:0];
    photoBrowserViewController.delegate = self;
    
    [picker presentViewController:photoBrowserViewController animated:YES completion:nil];
    [photoBrowserViewController setCustomTitle:@"预览"];
    [photoBrowserViewController setCustomDelBtnString:@"取消"];
    picker.indexPathsForSelectedItems = nil;
    
}

// 取消
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AJPhotoBrowserDelegate
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc deleteWithIndex:(NSInteger)index{
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos{
    [[NSNotificationCenter defaultCenter]postNotificationName:replaceRCDChatViewControllerBakcground object:photos[0]];
    UIImage *icImage = photos[0];
    UIImage *newImage = [icImage RC_imageCompressToTagetSize:CGSizeMake(RC_SCREEN_WIDTH, RC_SCREEN_HEIGHT)];
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1);
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"chatBackImage%@",[Login curLoginUser].userId]];
    
    // 融云提示
//    [LCProgressHUD showSuccess:@"更换成功"];

    [vc dismissViewControllerAnimated:YES completion:nil];
}

-(RCDDscussionHeadManager *)groupHeadManager{
    if (!_groupHeadManager) {
        _groupHeadManager = [[RCDDscussionHeadManager alloc] init];
    }
    return _groupHeadManager;
}
@end
