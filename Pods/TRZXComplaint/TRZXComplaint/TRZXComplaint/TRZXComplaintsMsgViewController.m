//
//  ComplaintsMsgViewController.m
//  tourongzhuanjia
//
//  Created by Rhino on 16/5/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "TRZXComplaintsMsgViewController.h"
#import "ComplaintsTitleTableViewCell.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "LCActionSheet.h"
#import "TRZXComplaintViewModel.h"
#import "UIImage+Com_Load.h"

static NSInteger photoCount = 9;

@interface TRZXComplaintsMsgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate>{
    ComplaintsTitleTableViewCell *firstCell;
    BOOL _isSelectOriginalPhoto;
}

@property (weak, nonatomic ) UICollectionView *collectionview;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,assign) BOOL isChooseOrigan;

@property (nonatomic,strong) NSMutableArray *imageAttids;
/*! 数据源 */
@property (nonatomic,strong)NSMutableArray *dataSource;
/*! tableView */
@property (nonatomic,strong)UITableView *tableView;


@end

@implementation TRZXComplaintsMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = 1;
    [self createUI];
}

- (void)createUI
{
    self.isChooseOrigan = NO;
    self.title = @"投诉";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(0, 0, 80, 44);
    [btn setTitle:@"提交"  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    
    UIView *headerView             = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UILabel *lable                 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 24)];
    lable.text                     = @"请举证";
    lable.font                     = [UIFont systemFontOfSize:14];
    lable.textColor                = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [headerView addSubview:lable];
    self.tableView.tableHeaderView = headerView;
    self.dataSource = [NSMutableArray arrayWithArray:@[@"图片证据",@""]];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
}

#pragma mark - cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return [self tableView:tableView cellForChoosePhotos:indexPath];
    }else
    {
        return [self tableView:tableView cellForTitle:indexPath];
    }
}
- (ComplaintsTitleTableViewCell *)tableView:(UITableView *)tableView cellForTitle:(NSIndexPath *)indexPath
{
    ComplaintsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComplaintsTitleTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"ComplaintsTitleTableViewCell" owner:self options:nil] firstObject];
    }
    
    cell.titlesLabel.text = self.dataSource[indexPath.row];
    if (self.selectedPhotos.count > 0) {
        cell.statusLable.text = [NSString stringWithFormat:@"%ld张图片",(unsigned long)self.selectedPhotos.count];
    }
    
    cell.titlesLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    cell.titlesLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        firstCell = cell;
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForChoosePhotos:(NSIndexPath *)indexPath
{
    //照片
    UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:@"photos"];
    if (cells == nil) {
        cells = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"photos"];
    }
    cells.contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    for (UIView *view in cells.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    UICollectionView *collec = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.width/3 * 3+7.5*2+10) collectionViewLayout:flow];
    collec.backgroundColor =[UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    collec.delegate = self;
    collec.dataSource  =self;
    self.collectionview = collec;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"midCell"];
    [cells.contentView addSubview:self.collectionview];
    cells.selectionStyle = UITableViewCellSelectionStyleNone;
    return cells;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1) {
        return self.view.bounds.size.width/3 * 3+7.5*2+10;
    }
    return 44;
}

#pragma mark -collectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"midCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *im = [[UIImageView alloc] initWithFrame:cell.bounds];
    
    im.contentMode = UIViewContentModeScaleAspectFill;
    im.layer.masksToBounds = YES;
    im.userInteractionEnabled  = YES;
    if (indexPath.row == self.selectedPhotos.count && self.selectedPhotos.count != photoCount) {
        im.image = [UIImage loadImage:@"TRZXAlbumcss" class:[self class]];
    }else{
        im.image = self.selectedPhotos[indexPath.row];
    }
    
    [cell.contentView addSubview:im];
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.selectedPhotos.count == 9) {
        return self.selectedPhotos.count;
    }
    return self.selectedPhotos.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.bounds.size.width/3 - 7.5, self.view.bounds.size.width/3 - 7.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7.5/2, 7.5/2, 7.5/2, 7.5/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7.5;
}

#pragma mark- EventHandle
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self alertChoose];
}

//最多9张图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.selectedPhotos.count) {
        [self alertChoose];
    }else
    {
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        
        //图片浏览器
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = photoCount;
        imagePickerVc.allowPickingOriginalPhoto = self.isChooseOrigan;
        
        __weak __typeof(self)weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            weakSelf.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            weakSelf.selectedAssets =[NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [weakSelf.collectionview reloadData];
            if (weakSelf.selectedPhotos.count == 0) {
                firstCell.statusLable.text = @"未选择";
            }else
            {
                firstCell.statusLable.text = [NSString stringWithFormat:@"%ld张图片",(unsigned long)weakSelf.selectedPhotos.count];
            }
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)alertChoose{
    
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@""
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"拍照", @"手机相册选择", nil];
    actionSheet.titleColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    
    actionSheet.buttonColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];;
    actionSheet.titleFont = [UIFont systemFontOfSize:15];
    actionSheet.buttonFont = [UIFont systemFontOfSize:15];
    actionSheet.tag = 2599;
    
    [actionSheet show];
    
}

- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 2) {
        //相册
        [self pushImagePickerController];
    }
    
}


#pragma mark - TZImagePickerControllerDelegate
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self.collectionview reloadData];
    if (self.selectedPhotos.count == 0) {
        firstCell.statusLable.text = @"未选择";
    }else
    {
        firstCell.statusLable.text = [NSString stringWithFormat:@"%ld张图片",(unsigned long)self.selectedPhotos.count];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//使用照片--拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:photoCount delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
#define push @#clang diagnostic pop
                [alert show];
            } else {
                
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self.selectedAssets addObject:assetModel.asset];
                        [self.selectedPhotos addObject:image];
                        [self.collectionview  reloadData];
                        if (self.selectedPhotos.count == 0) {
                            firstCell.statusLable.text = @"未选择";
                        }else
                        {
                            firstCell.statusLable.text = [NSString stringWithFormat:@"%ld张图片",(unsigned long)self.selectedPhotos.count];
                        }
                        
                    }];
                }];
            }
        }];
    }
}

#pragma maek - 提交按钮点击事件~~~++++++++++++++++++++++++++++++++++++++++++++++

- (void)rightBarItemAction:(UIButton *)gesture{

    if (self.selectedPhotos.count == 0) {
//        [LCProgressHUD showMessage:@"请至少上传一张图片"];
        return;
    }
    
    [TRZXComplaintViewModel getComplaint_ApiReason:self.subType beComplaintId:self.targetId imageArray:self.selectedPhotos Success:^(id json) {
        
        if ([json[@"status_code"] isEqualToString:@"200"]) {
            
            NSArray *array = self.navigationController.viewControllers;
            UIViewController *viewController = array[array.count-3];
            [self.navigationController popToViewController:viewController animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    if (photoCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:photoCount columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (photoCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
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
    imagePickerVc.allowPickingOriginalPhoto = self.isChooseOrigan;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

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
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
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

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
#pragma mark - setter/getter------------------------------------------------------------------------

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

- (NSMutableArray *)selectedAssets
{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}
- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}
- (NSMutableArray *)imageAttids{
    if (!_imageAttids) {
        _imageAttids = [NSMutableArray array];
    }
    return _imageAttids;
}
#pragma mark - 懒加载

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate =self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];;
        tableView.estimatedRowHeight = 280;
        _tableView = tableView;
    }
    return _tableView;
}
@end
