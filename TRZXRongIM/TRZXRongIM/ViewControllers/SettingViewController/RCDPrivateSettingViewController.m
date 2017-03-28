//
//  RCDPrivateViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDPrivateSettingViewController.h"
#import "RCDChatViewController.h"
#import "RCDSettingBackgroundViewController.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDConversationSettingClearMessageCell.h"
#import "RCDCommonDefine.h"

@interface RCDPrivateSettingViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,AJPhotoPickerProtocol,AJPhotoBrowserDelegate>
@property (nonatomic,strong) UIImagePickerController * pickerCamera;
@property (nonatomic,strong) UIImagePickerController * PickerImage;

@property (nonatomic,weak) AJPhotoPickerViewController * customPhotoVC;
/**
 *  UIActionSheet
 */
@property(nonatomic, readonly, strong) UIActionSheet *myClearMsgHistoryActionSheet;
@property (nonatomic,assign) BOOL isChangeBackground;

@end

@implementation RCDPrivateSettingViewController

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
        _PickerImage = [[UIImagePickerController alloc]init];
        _PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        _PickerImage.delegate=self;
    }
    return _PickerImage;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[UIView new];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
//    [self.header.users removeLastObject];
    [self.header.users addObject:[[RCDataBaseManager shareInstance] getUserByUserId:self.targetId]];
    [self disableInviteMemberEvent:YES];
    [self.header reloadData];
    
    self.tableView.backgroundColor = [UIColor trzx_BackGroundColor];
    
    [[RCDHttpTool shareInstance] getUserInfoByUserID:self.targetId completion:^(RCDUserInfo *user) {
        if ([user.isAlso isEqualToString:@"Complete"] && ![user.name isEqualToString:@"投融小秘书"]) {
            UIButton *deleteFriendBtn = [UIButton RC_buttonWithTitle:@"删除好友" color:[UIColor whiteColor] imageName:nil target:self action:@selector(deleteFriendBtn:)];
            deleteFriendBtn.backgroundColor = [UIColor trzx_YellowColor];
            deleteFriendBtn.RC_cornerRadius = 6;
            deleteFriendBtn.frame = CGRectMake(20, 30,  RC_SCREEN_WIDTH - 40, 40);
            UIView *tablViewFooterView = [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
            tablViewFooterView.frame = CGRectMake(0, 0, 0, 80);
            [tablViewFooterView addSubview:deleteFriendBtn];
            self.tableView.tableFooterView = tablViewFooterView;
        }
    }];
}

#pragma mark - Action
-(void)deleteFriendBtn:(UIButton *)button{
    RCUserInfo *userInfo = [self.header.users firstObject];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"将联系人“%@”删除,同时删除与该联系人的聊天记录",userInfo.name] message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除联系人", nil];
    [alertView show];
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
        if ([indexNumber intValue] == 1) {
            // 融云提示
//            [LCProgressHUD showLoading:@"正在加载"];
            [[RCDHttpTool shareInstance] deleteFriend:self.targetId complete:^(BOOL result) {
                //删除好友
                
                [[RCIMClient sharedRCIMClient] deleteMessages:self.conversationType targetId:self.targetId success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //成功
                        // 融云提示
//                        [LCProgressHUD hide];
                        [[RCDataBaseManager shareInstance] deleteFriendFromDB:self.targetId];
                        [[RCIMClient sharedRCIMClient] removeConversation:self.conversationType targetId:self.targetId];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                } error:^(RCErrorCode status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 融云提示
//                        [LCProgressHUD hide];
                    });
                }];
            }];
        }
    }];
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.defaultCells[indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 设置聊天页面背景
-(void)replaceBackGround:(id)sender{
    RCDSettingBackgroundViewController *settingBackground = [[RCDSettingBackgroundViewController alloc]init];
    settingBackground.chatViewController = self;
    [self.navigationController pushViewController:settingBackground animated:YES];
}

//清除聊天记录
- (void)onClickClearMessageHistory:(id)sender {
    
    _isChangeBackground = NO;
    
//    [super onClickClearMessageHistory:sender];
    
    _myClearMsgHistoryActionSheet =
    [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"IsDeleteHistoryMsg", @"RongCloudKit", nil)
                                delegate:self
                       cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"RongCloudKit", nil)
                  destructiveButtonTitle:NSLocalizedStringFromTable(@"OK", @"RongCloudKit", nil)
                       otherButtonTitles:nil, nil];
    [_myClearMsgHistoryActionSheet showInView:self.view];
    
}

//设置sheetButtonAction
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_isChangeBackground) {
        if (buttonIndex==0)
        {
            if ([UIDevice RC_isCameraAvailable])
            {
                
                [self presentViewController:self.pickerCamera animated:YES completion:NULL];
                
            }else{
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"该设备没有摄像头" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if (buttonIndex==1)
        {
            [self presentViewController:self.PickerImage animated:YES completion:nil];
        }
        else
        {

        }
    }else{
        
        if (buttonIndex == 0) {
            [self clearHistoryMessage];
        }
    }
}

- (void)settingTableViewHeader:(RCDConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users{
    return;
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
    
    // 融云提示
//    [LCProgressHUD showSuccess:@"更换成功"];   // 显示成功

    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)ComplaintsUser:(id)sender{
    
    RCUserInfo *userInfo = [self.header.users firstObject];
    UIViewController *complaintsVC = [[CTMediator sharedInstance] TRZXComplaint_TRZXComplaintViewController:@{@"type":@"2",                                                                                                     @"targetId":self.targetId,                                                                                                   @"userTitle":userInfo.name}];
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
//    [vc.navigationController popViewControllerAnimated:YES];
    [vc dismissViewControllerAnimated:YES completion:nil];
}
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos{
    [[NSNotificationCenter defaultCenter]postNotificationName:replaceRCDChatViewControllerBakcground object:photos[0]];
    
    UIImage *newImage = [photos[0] RC_imageCompressToTagetSize:CGSizeMake(RC_SCREEN_WIDTH, RC_SCREEN_HEIGHT)];
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1);
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"chatBackImage%@",[Login curLoginUser].userId]];
    
    // 融云提示
//    [LCProgressHUD showSuccess:@"更换成功"];   // 显示成功
    
    [self.customPhotoVC dismissViewControllerAnimated:NO completion:nil];
    [vc dismissViewControllerAnimated:YES completion:nil];
}


@end
