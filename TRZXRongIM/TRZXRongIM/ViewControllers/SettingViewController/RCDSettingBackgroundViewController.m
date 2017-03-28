//
//  RCDSettingBackgroundViewController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 16/6/4.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "RCDSettingBackgroundViewController.h"
#import "RCNewImagePickerController.h"
#import "RCDSelectedBackgroundViewController.h"
#import "RCDCommonDefine.h"

static  NSString * const RCDSettingReuseIdentifier = @"RCDSettingReuseIdentifier";

@interface RCDSettingBackgroundViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AJPhotoBrowserDelegate>
@property (strong, nonatomic) UITableView *settingsTableView;
@property (strong, nonatomic) NSArray *items;
@property (nonatomic,strong) UIImagePickerController * pickerCamera;
@property (nonatomic,strong) RCNewImagePickerController * PickerImage;
@property (nonatomic,assign) BOOL  isPickerImage;
@end

@implementation RCDSettingBackgroundViewController
#pragma mark - 懒加载
-(RCNewImagePickerController *)PickerImage{
    if (!_PickerImage) {
        _PickerImage = [[RCNewImagePickerController alloc]init];
        _PickerImage.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
//        _PickerImage.videoQuality = UIImagePickerControllerQualityTypeLow;
        _PickerImage.delegate=self;
        
//        [_PickerImage.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
        //                [location.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
    }
    return _PickerImage;
}
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
-(UITableView *)settingsTableView{
    if (!_settingsTableView) {
        _settingsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, RC_SCREEN_WIDTH, RC_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _settingsTableView.delegate = self;
        _settingsTableView.dataSource = self;
        _settingsTableView.backgroundColor = [UIColor trzx_BackGroundColor];
    }
    return _settingsTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天背景";
    self.items = @[@[@"选择背景图"],@[@"从手机相册选择",@"拍一张"]];
    [self.view addSubview:self.settingsTableView];
    
//    [self addBackItem];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
}
//-(void)addBackItem{
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 8, 50, 23);
//    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回白"]];
//    backImg.frame = CGRectMake(-5, 3, 10, 16);
//    [backBtn addSubview:backImg];
//    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 85, 22)];
//    backText.text = @"返回";
//    backText.font = [UIFont systemFontOfSize:16];//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
//    [backText setTextColor:[UIColor whiteColor]];
//    [backBtn addSubview:backText];
//    [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
//}
-(void)leftBarButtonItemPressed:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RCDSettingReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RCDSettingReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [self.items[indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当前 cell 点击后 当前状态反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
//        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"此功能尚未开放" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [alert show];
        RCDSelectedBackgroundViewController *selectedVC = [[RCDSelectedBackgroundViewController alloc]init];
        [self.navigationController pushViewController:selectedVC animated:YES];
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                _isPickerImage =  YES;
                [self presentViewController:self.PickerImage animated:YES completion:nil];
//                [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
//                UIFont *font = [UIFont boldSystemFontOfSize:19.f];
//                NSDictionary *textAttributes = @{
//                                                 NSFontAttributeName : font,
//                                                 NSForegroundColorAttributeName : [UIColor trzx_RedColor]
//                                                 };
//                [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
//                [[UINavigationBar appearance] setTintColor:[UIColor trzx_TextColor]];
//
//                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//                [self setNeedsStatusBarAppearanceUpdate];
            }
                break;
            case 1:{
                if ([UIDevice RC_isCameraAvailable])
                {
                    _isPickerImage = NO;
                    [self presentViewController:self.pickerCamera animated:YES completion:NULL];
                    
                }
                else
                {
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"该设备没有摄像头" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIImagePicker delegate
//六、实现ImagePicker delegate 事件
//选取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    
//    UIImage *newImage = [self imageCompressForSize:icImage targetSize:CGSizeMake(RC_SCREEN_WIDTH, RC_SCREEN_HEIGHT)];
    
    //获得已选择的图片
    if (_isPickerImage) {
        
        
        AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:@[newImage] index:0];
        photoBrowserViewController.delegate = self;
        
        //    photoBrowserViewController.navigationController.navigationBarHidden = YES;
        //    [picker.navigationController pushViewController:photoBrowserViewController animated:YES];
        [picker presentViewController:photoBrowserViewController animated:YES completion:nil];
        [photoBrowserViewController setCustomTitle:@""];
        [photoBrowserViewController setCustomDelBtnString:@"取消"];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"replaceRCDChatViewControllerBakcground" object:newImage];
        
        // 融云提示
//        [LCProgressHUD showSuccess:@"更换成功"];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToViewController:self.chatViewController animated:NO];
    }
}



#pragma mark -
-(void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"replaceRCDChatViewControllerBakcground" object:photos[0]];
    
    // 融云提示
//    [LCProgressHUD showSuccess:@"更换成功"];
    //    [vc.navigationController popToViewController:self animated:YES];
    //    [vc.navigationController popToViewController:self.chatViewController animated:NO];
    [vc dismissViewControllerAnimated:YES completion:nil];
    [self.PickerImage dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
