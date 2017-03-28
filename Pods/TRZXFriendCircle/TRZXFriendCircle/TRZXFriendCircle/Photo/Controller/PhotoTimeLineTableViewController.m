//
//  PhotoTimeLineTableViewController.m
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PhotoTimeLineTableViewController.h"
#import "SDTimeLineTableHeaderView.h"
#import "PhotoTimeLineCell.h"
#import "SendTimeLineViewController.h"
#import "TimeLineDetailsViewController.h"
#import "PhotoTimeModel.h"
#import "AJPhotoPickerViewController.h"
#import "StitchingImage.h"
#import "DynamicHomeViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TRZXDIYRefresh.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PhotoTimeModel.h"
#import "SharePhotoTimeLineCell.h"
#import "TextTimeLineCell.h"
//#import "PersonalInformationVC.h"
//#import "TRZXFriendDetailsViewController.h"


#import "TRZXNetwork.h"
#import "MJRefresh.h"
#import "MJExtension.h"
//#import "MJDIYAutoFooter.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]


@interface PhotoTimeLineTableViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
//,NewDetailsDelegate
{


    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;

    NSInteger imagePickerTag;


}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;



@property (nonatomic,strong) PhotoTimeModel * photoTimeModel;
@property (nonatomic,strong) UILabel * noLabelView;

@property (nonatomic,strong) NSDictionary * photoTopDic;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) SDTimeLineTableHeaderView *headerView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic,strong)NSArray *data;
@property (nonatomic)NSInteger photoMaxCount;


@end

@implementation PhotoTimeLineTableViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(UILabel *)noLabelView{
    if (!_noLabelView) {
        _noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        _noLabelView.text = @"— 暂无内容 —";
        _noLabelView.textAlignment = NSTextAlignmentCenter;
        _noLabelView.textColor = zideColor;
    }
    return _noLabelView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 83, 43);
    [_rightBtn setTitle:@"..." forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(-5,40,10,10);
    [_rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _photoTimeModel = [[PhotoTimeModel alloc]init];


    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];

    _headerView = [SDTimeLineTableHeaderView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [_headerView.backgroundImageView addGestureRecognizer:tap];

    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcionImageView:)];
    [_headerView.iconView addGestureRecognizer:iconTap];
    _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1];
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = _headerView;
    [self getPhoto_Api_getTop];
    [self refresh];
    _tableView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载数据
        [self refreshMore];
    }];


    _tableView.mj_footer.automaticallyHidden = YES;


}

- (void)refresh{
    _photoTimeModel.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore{
    if (!_photoTimeModel.canLoadMore) {
        [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        return;

    }
    _photoTimeModel.willLoadMore = YES;
    [self sendRequest];
}


-(void)sendRequest{

//    if (_photoTimeModel.data.count <= 0) {
//        [self.view beginLoading];
//    }

    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{
                             @"requestType":@"Circle_Api",
                             @"apiType":@"myList"
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
        _photoTimeModel.isLoading = NO;
        if (data) {
            _photoTimeModel = [PhotoTimeModel mj_objectWithKeyValues:data];

            [weakSelf.photoTimeModel configWithObj:_photoTimeModel];

            [weakSelf.tableView reloadData];
        }
        if (_photoTimeModel.willLoadMore) {
            [_tableView.mj_footer endRefreshing];
        }else{
            [_tableView.mj_header endRefreshing];
        }

         if (!weakSelf.photoTimeModel.canLoadMore) {
             [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
         }


         if([_otherIdStr isEqualToString:_photoTopDic[@"userId"]]){//默认的空id判断

             if (weakSelf.photoTimeModel.data.count<=1) {
                 
                 self.tableView.tableFooterView = self.noLabelView;
                 weakSelf.tableView.mj_footer.hidden = YES;
             }else{
                 _noLabelView.text = @"";
                 self.tableView.tableFooterView = self.noLabelView;
                 weakSelf.tableView.mj_footer.hidden = NO;
                 
             }


         }else{

             if (weakSelf.photoTimeModel.data.count==0) {
                 UILabel * noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
                 noLabelView.text = @"— 暂无内容 —";
                 noLabelView.textAlignment = NSTextAlignmentCenter;
                 noLabelView.textColor = zideColor;
                 self.tableView.tableFooterView = noLabelView;
                 weakSelf.tableView.mj_footer.hidden = YES;
             }else{
                 _noLabelView.text = @"";
                 self.tableView.tableFooterView = self.noLabelView;
                 weakSelf.tableView.mj_footer.hidden = NO;
                 
             }

         }



//        [self.view configBlankPage:EaseBlankPageTypeTask hasData:(weakSelf.photoTimeModel.data.count > 0) hasError:(error != nil) reloadButtonBlock:^(id sender) {
//            [weakSelf refresh];
//        }];

        
        
        
    }];
    
}



//获取顶部图片 和 用户的头像
-(void)getPhoto_Api_getTop{
    NSDictionary *params = @{@"requestType":@"Photo_Api",
                             @"otherId":_otherIdStr?_otherIdStr:@"",
                             @"apiType":@"getTop"};
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        _headerView.photoTopDic = object;
        _photoTopDic = object;
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)tapIcionImageView:(UITapGestureRecognizer *)tap
{
//跳转先注销
//    PersonalInformationVC * studentPersonal=[[PersonalInformationVC alloc]init];
//    studentPersonal.otherStr = @"1";
//    studentPersonal.headBackStr = @"1";
//    studentPersonal.midStrr = _otherIdStr;
//    [self.navigationController pushViewController:studentPersonal animated:true];

}



- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    _photoMaxCount = 1;
    if(![_otherIdStr isEqualToString:_photoTopDic[@"userId"]]){//自己的ID判断
        return;
    }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    sheet.tag = 1000;
    #pragma clang diagnostic pop
        [sheet showInView:self.view];
}






-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}




// 视图将被从屏幕上移除之前执行
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _photoTimeModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  

    TRZXPhotoTextModel *model = _photoTimeModel.data[indexPath.row];


    if ([model.type isEqualToString:@"my"]) {

        PhotoTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTimeLineCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"PhotoTimeLineCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dayLabel.hidden = NO;
        cell.monthLabel.hidden = YES;
        cell.numberLabel.hidden = YES;
        cell.photoView.hidden = NO;
        cell.topLineView.hidden = YES;


        return cell;
    }else if ([model.type isEqualToString:@"course"]|| //课程
              [model.type isEqualToString:@"live"]|| //直播回看
              [model.type isEqualToString:@"project"]|| //项目
              [model.type isEqualToString:@"userHome"]|| //个人主页
              [model.type isEqualToString:@"bp"]|| //BP分享
              [model.type isEqualToString:@"otoSchool"]|| //BP分享
              [model.type isEqualToString:@"ResourcesReq"]|| //发布的分享
              [model.type isEqualToString:@"live"]|| //直播

              [model.type isEqualToString:@"investorHome"]){ // 投资人主页

        SharePhotoTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SharePhotoTimeLineCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"SharePhotoTimeLineCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;


    }else if ([model.type isEqualToString:@"photo"]&&model.pics.count==0){

        TextTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextTimeLineCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"TextTimeLineCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;


    }else if ([model.type isEqualToString:@"photo"]&&model.pics.count>0){


        PhotoTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTimeLineCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"PhotoTimeLineCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.photoImageView = [self createImageViewWithCanvasView:cell.photoImageView pics:model.pics];
        cell.model = model;
        return cell;



    }

    return [[UITableViewCell alloc]init];

}

- (UIImageView *)createImageViewWithCanvasView:(UIImageView *)canvasView pics:(NSArray*)pics {

    NSMutableArray *imageViews = [[NSMutableArray alloc] init];

    for (int index = 0; index < pics.count; index++) {
        if (index<4) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:pics[index]] placeholderImage:[UIImage imageNamed:@"展位图.png"]];
            imageView.clipsToBounds  = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;

            [imageViews addObject:imageView];
        }

    }

    // also can use:
    return [[StitchingImage alloc] stitchingOnImageView:canvasView withImageViews:imageViews marginValue:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TRZXPhotoTextModel *model = _photoTimeModel.data[indexPath.row];
    if ([model.type isEqualToString:@"photo"]&&model.shareImg==nil){
        return 80;
    }
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{




    TRZXPhotoTextModel *model = _photoTimeModel.data[indexPath.row];
    if ([model.type isEqualToString:@"my"]) {
        _photoMaxCount = 9;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        sheet.tag = 2000;
#pragma clang diagnostic pop
        [sheet showInView:self.view];
    }else{
//跳转先注销
        
//        TRZXFriendDetailsViewController * DetailsVC = [[TRZXFriendDetailsViewController alloc]init];
//        DetailsVC.indexTeger = indexPath.row;
//        DetailsVC.userIdStr = model.mid;
//        DetailsVC.delegate = self;
//        [self.navigationController pushViewController:DetailsVC animated:true];
        
    }


    
    
}

- (void)backAction
{
    [self.delegate pushAllSetting];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setPhoto{

    if(imagePickerTag==1000){

        //上传图片的暂时先隐藏
//        [PhotoViewModel getPhoto_Api_topUpload:_selectedPhotos[0] otherId:_otherIdStr success:^(id object) {
//
//            [self getPhoto_Api_getTop];
//
//        } failure:^(NSError *error) {
//
//        }];



    }else if (imagePickerTag==2000){

        SendTimeLineViewController *sendTimeLineViewController = [[SendTimeLineViewController alloc] initWithSendTimeLineype:SendTimeLineypeImageText];
        sendTimeLineViewController.selectedPhotos= _selectedPhotos;
        sendTimeLineViewController.selectedAssets= _selectedAssets;
        __weak PhotoTimeLineTableViewController *weakSelf = self;
        sendTimeLineViewController.sendSuccessTimeLineBlock = ^(void){
            [_selectedPhotos removeAllObjects];
            [_selectedAssets removeAllObjects];
            [weakSelf refresh];
        };

        [self.navigationController pushViewController:sendTimeLineViewController animated:true];


    }
    

}




#pragma mark - ========================================相册相机图库操作详细介绍

#pragma mark - UIImagePickerController初始化

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


#pragma mark - ==============================访问相机

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
        }
    }
}


- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;  ///< 照片排列按修改时间升序
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];


                        [self setPhoto];




//                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
}


#pragma mark -
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    if (_photoMaxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_photoMaxCount columnNumber:4 delegate:self];


#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;

    if (_photoMaxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮

    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];

    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;

    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止

    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate



// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;



    [self setPhoto];



}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];

}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {


    imagePickerTag = actionSheet.tag;


#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        if (actionSheet.tag == 20161121) {
            DynamicHomeViewController * newMessage=[[DynamicHomeViewController alloc]init];
            [self.navigationController pushViewController:newMessage animated:true];
        }else{
            [_selectedPhotos removeAllObjects];
            [_selectedAssets removeAllObjects];
            
            [self takePhoto];
        }
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];

    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            if (alertView.tag == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
            }
        }
    }
}
//跳转列表
-(void)saveAction{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"消息列表", nil];
    sheet.tag = 20161121;
    [sheet showInView:self.view];
    
}
    
@end
