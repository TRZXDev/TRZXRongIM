//
//  RCDSelectedBackgroundViewController.m
//  TRZX
//
//  Created by 移动微 on 16/6/29.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#define kMargin 10

#import "RCDSelectedBackgroundViewController.h"
#import "RCDCommonDefine.h"
#import "TempCollectionViewCell.h"

@interface RCDSelectedBackgroundViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *myCollection;

@property(nonatomic, strong)NSArray *dataImages;

@end

@implementation RCDSelectedBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor trzx_BackGroundColor];
    [self setupUI];
//    [self addBackItem];
    
    self.title = @"选择背景图";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    [self loadData];
}

#pragma mark - 加载数据
-(void)loadData{

    NSDictionary *params = @{@"requestType":@"Default_Pic_Api",
                             @"type":@"backGround"};
    
    //
//    [KipoNetworking post:[KipoServerConfig serverURL] params:params success:^(id json) {
//        
//        self.dataImages = json[@"data"];
//        
//        [self.myCollection reloadData];
//        
//    } failure:^(NSError *error) {
//        
//    }];
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
//    
//    self.title = @"选择聊天背景";
//}
-(void)leftBarButtonItemPressed:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/// 调整状态栏 颜色 (高亮)
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


-(void)setupUI{
    [self.view addSubview:self.myCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataImages.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    TempCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BJCollectionCell" forIndexPath:indexPath];
    
    [cell.bjImage sd_setImageWithURL:[NSURL URLWithString:self.dataImages[indexPath.row]] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    TempCollectionViewCell *cell = (TempCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIImage *newImage = cell.bjImage.image;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"replaceRCDChatViewControllerBakcground" object:newImage];
    
    [self.navigationController popViewControllerAnimated:YES];
    // 融云提示
//    [LCProgressHUD showSuccess:@"更换背景成功"];   // 显示成功
}


#pragma mark - 懒加载
-(UICollectionView *)myCollection{

    if (!_myCollection) {
        CGFloat itemSize = RC_SCREEN_WIDTH / 4;
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.itemSize = CGSizeMake(itemSize, itemSize);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //    flowlayout.minimumLineSpacing = 10;
        //    flowlayout.minimumInteritemSpacing = 10;
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:flowlayout];
        _myCollection.delegate = self;
        _myCollection.dataSource = self;
        //    BJCollectionCell *cell = [NSbun]
        UINib *nib = [UINib nibWithNibName:@"BJCollectionCell" bundle:[NSBundle mainBundle]];
        [_myCollection registerNib:nib forCellWithReuseIdentifier:@"BJCollectionCell"];
    }
    return _myCollection;
}

-(NSArray *)dataImages{
    if (!_dataImages) {
        _dataImages = [NSArray array];
    }
    
    return _dataImages;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
