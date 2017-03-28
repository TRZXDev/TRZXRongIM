//
//  TRZXPersonalHomeViewController.m
//  TRZXPersonalHome
//
//  Created by 张江威 on 2017/2/20.
//  Copyright © 2017年 张江威. All rights reserved.
//
#import "TRZXPersonalHomeViewController.h"
#import "MJExtension.h"
#import "Masonry.h"
#import <UIKit/UIKit.h>
#import "TRZXNetwork.h"
#import "UIImageView+AFNetworking.h"
#import "PersonalTopView.h"
#import "StudentJianJieCell.h"
#import "StudentJingLiBTCell.h"
#import "PersonalJianJieCell.h"
#import "PersonalCollectionView.h"
#import "TRZXPersonalNModel.h"
#import "presonalNavgationViw.h"
#import "CeHuaTableViewCell.h"
#import "CeHuaCollectionViewCell.h"
#import "xihuanTableViewCell.h"
#import "TRZSJAvatarBrowser.h"
#import "PhotoDTableViewCell.h"
#import "TRZXZHScrollViewLB.h"
#import "PersonalLiveVideoModel.h"

#import "TRZPersonalModell.h"

#import "CeHuaTableView2Cell.h"
#import "PersonalZBCollectionView.h"
#import "GifView.h"
#import "xiaoxiCell.h"
#import "xiaoxi2Cell.h"
#import "PersonalJiaoYiTabCell.h"
#import "PersonalBottomView.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"

#import "Target_TRZXPersonalHome.h"
#import "Login.h"

#import "TRZXPersonalCareAboutController.h"//关注（自己）
#import "TRZXPersonalWatchController.h"//观看课程
#import "TRZXPersonalTopButtonController.h"//关注、粉丝、路演观众等
#import "TRZXPersonalMyBuyController.h"//我的购买
#import "TRZXStrategyViewController.h"//攻略
#import "TRZXPersonalYYSViewController.h"//成为合伙人
#import "TRZXCollectionViewController.h"//收藏
#import "WoWenWoDaViewController.h"//我问我答
#import "TRNewShareViewController.h"//邀请好友
#import "PersonalChengJiuVC.h"//更多成果
#import "PersonalZhiBoViewController.h"//更多直播

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define kBlackColor         [UIColor blackColor]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define  zjself __weak __typeof(self) sfself = self
// 关注点击 同时改变
NSString *const collectionStasusChangeKey = @"collectionStasusChange";

@interface TRZXPersonalHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,PersonalDelegate,GuanZhuDelegate,GuanKanDelegate,yysDelegate,gengduoDelegate,VideoDelegate>
//,UMSocialUIDelegate,AllSettingDelegate,PhotoDelegate>


//@property (strong, nonatomic) NSDictionary *dataDic;
//@property (strong, nonatomic) NSArray *chengjiuArr;
@property (strong, nonatomic) NSString * otherTwoStr;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) PersonalBottomView *PersonalBottomView;
@property (copy, nonatomic)NSString *quxiaoStr;

@property (copy, nonatomic) NSString * guanzhuStr;

//@property (copy, nonatomic) NSString * gjStr;

//@property (copy, nonatomic) NSString * peopleStr;


@property (nonatomic, strong)TRZXZHScrollViewLB *scrollView;
@property (strong, nonatomic) PersonalTopView *PersonalTopView;
@property (strong, nonatomic) PersonalCollectionView *PersonalCollectionView;
@property (strong, nonatomic) PersonalZBCollectionView*PersonalZBCollectionView;
//@property (strong, nonatomic) TRZPersonalModell *PersonalMode;

@property (strong, nonatomic) TRZXPersonalNModel *personalModes;


@property (strong, nonatomic) presonalNavgationViw *presonalNavgationViw;

@property (copy, nonatomic)NSString * refreshStr;//下拉刷新的

@property (copy, nonatomic)NSString *ckptyhStr;

//@property (strong, nonatomic) NSArray *jiaoyuArr;
//@property (strong, nonatomic) NSArray *gongzuoArr;


//侧滑的
@property (copy, nonatomic)NSMutableArray *cehuatiteArr;
//o菜单o
//@property (copy, nonatomic)NSMutableArray * omenuArr;

//菜单
@property (copy, nonatomic)NSMutableArray * menuArr;
//运营商
@property (copy, nonatomic)NSMutableArray * proxyArr;

//@property (copy, nonatomic)NSArray * personalArr;


@property (strong, nonatomic) TRZPersonalModell * menuModel;
@property (strong, nonatomic) TRZPersonalModell * proxyModel;


@property (nonatomic, strong) NSMutableArray * gonggaoArr;
@property (nonatomic ,strong) NSMutableArray * huodongArr;

@property (nonatomic, strong) NSString * HDGGStr; // notice公告   activity活动

@property (copy, nonatomic) NSString * dangqianStr;
@property (strong, nonatomic) DVSwitch * switcher;

//@property (strong, nonatomic) NSArray * xiangceArr;

@property (strong, nonatomic) NSString * zhenfuStr;
@property (strong, nonatomic) NSString * jiaoyiStr;

//@property (nonatomic,copy) NSString * smsUrl;
//@property (nonatomic,copy) NSString * smsInviteUrl;

@property (strong, nonatomic) NSString * rzyysStr;//认证运营商

@property (strong, nonatomic) NSString * syqhsStr;//商业企划书标题

@property (strong, nonatomic) NSString * fkhdStr;//反馈红点 有1，无0

@property (strong, nonatomic) NSString * hongdianXStr;
@property (strong, nonatomic) NSString * hongdianZStr;

@property (nonatomic, copy)void (^maxImageComplete)();

@property (nonatomic, assign)BOOL isImageComplete;

@property (nonatomic, assign)BOOL isImageCompleteSecond;

//@property (strong, nonatomic) NSString * imageStr;

@property (nonatomic, strong) NSString * vipStr;


@property (nonatomic, strong) NSArray * liveVedioArray;

//@property (strong, nonatomic) NSArray * dangqianArr;


@property (strong, nonatomic) NSArray * NewbtnArr;
@property (strong, nonatomic) NSArray * NewLabArr;


@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isRefersh;
@property (nonatomic, assign) BOOL statusBarType;

@end

@implementation TRZXPersonalHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self bgTableview];
}


//view 不显示的时候删除数据
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    if(_personalModes.data == nil)[self caidanShuJu];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)caidanShuJu{
    if ([_otherTwoStr isEqualToString:@"2"]||[_otherTwoStr isEqualToString:@"1"]||_personalModes.data == nil) {
        if (![_guanzhuStr isEqualToString:@"1"]) {
            
        }
    }
    
    NSDictionary *params = @{@"requestType":@"Live_Video_Api",
                             @"apiType":@"list",
                             @"beVistedId":_midStrr?_midStrr:@""};
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
        
        // 请求完成后，更新UI
        if (data) {
            self.liveVedioArray = [PersonalLiveVideoModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            [self jiazaishuju];
        }else{
            [self wuwang];
        }
    }];
}


//通知
- (void)jiazaishuju{
    if (_midStrr == nil || _midStrr.length <= 0) {
        return;
    }
    NSDictionary *params = @{@"requestType":@"UserHomePage_Api",
                             @"apiType":@"findData",
                             @"id":_midStrr};
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        _personalModes = [TRZXPersonalNModel mj_objectWithKeyValues:object];
        
        if (object) {
//            _personalArr = object[@"data"];
            [_menuArr removeAllObjects];
            [_proxyArr removeAllObjects];
            for (int i = 0; i<_personalModes.menus.count; i++) {
                Menus * mode = [_personalModes.menus objectAtIndex:i];
                if ([mode.mid isEqualToString:@"y129"]||
                    [mode.mid isEqualToString:@"y130"]||
                    [mode.mid isEqualToString:@"y131"]) {
                    
                    NSDictionary *dict = @{@"mid":mode.mid,@"name":mode.name};
                    [_proxyArr addObject:dict];
                    [_menuArr addObject:dict];
                }
            }
            if ([_otherTwoStr isEqualToString:@"0"]||[_otherTwoStr isEqualToString:@"1"]) {
                _vipStr = object[@"vip"];
            }
            for (int i = 0; i<_personalModes.sessionUserType.count; i++) {
                if ([_personalModes.sessionUserType[i] isEqualToString:@"Tourist"]||[_personalModes.sessionUserType[i] isEqualToString:@"User"]) {
                    _dangqianStr = @"1";
                }else{
                    _dangqianStr = @"0";
                }
                if ([_personalModes.sessionUserType[i] isEqualToString:@"TradingCenter"]) {
                    _jiaoyiStr = @"1";
                }else{
                    _jiaoyiStr = @"0";
                }
            }
            
            if (_personalModes.data) {
                
//                _PersonalMode = [TRZPersonalModell mj_objectWithKeyValues:_personalArr];
                _personalModes.data.currentUser = object[@"currentUser"];
                _personalModes.data.isAlso = _personalModes.isAlso;
                if ([_otherTwoStr isEqualToString:@"2"]&&([_personalModes.data.userType isEqualToString:@"Tourist"]||[_personalModes.data.userType isEqualToString:@"User"]||[_personalModes.data.userType isEqualToString:@"Proxy"])) {
                    _ckptyhStr = @"1";
                    _presonalNavgationViw.fenxiangBtn.hidden = YES;
                }else{
                    _ckptyhStr = @"0";
                }
                if ([_otherTwoStr isEqualToString:@"2"]&&[_ckptyhStr isEqualToString:@"0"]) {
                    _vipStr = _personalModes.data.vip;
                }else if ([_otherTwoStr isEqualToString:@"2"]&&[_ckptyhStr isEqualToString:@"1"]){
                    _vipStr = _personalModes.data.vip;
                }
                
                if ([_otherTwoStr isEqualToString:@"0"]) {
                    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
                }else if ([_otherTwoStr isEqualToString:@"2"]){
                    if ([_personalModes.data.userType isEqualToString:@"User"]||
                        [_personalModes.data.userType isEqualToString:@"TradingCenter"]||
                        [_personalModes.data.userType isEqualToString:@"Tourist"]) {
                        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    }else if ((![_personalModes.data.userType isEqualToString:@"Proxy"])&&[_personalModes.data.currentUser isEqualToString:@"Proxy"]) {
                        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    }else{
                        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
                    }
                }else{
                    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                }
                
                _PersonalTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
                if ([_otherTwoStr isEqualToString:@"2"]&&
                    ![_personalModes.data.currentUser isEqualToString:@"User"] &&
                    ![_personalModes.data.currentUser isEqualToString:@"Tourist"] &&
                    ![_personalModes.data.userType isEqualToString:@"User"] &&
                    ![_personalModes.data.userType isEqualToString:@"Tourist"] &&
                    ![_personalModes.data.userType isEqualToString:@"TradingCenter"] &&
                    _PersonalBottomView == nil) {
                    
                    [self.view addSubview:self.PersonalBottomView];
                    self.PersonalBottomView.model = _personalModes.data;
                }
                if (![_personalModes.data.userType isEqualToString:@"Proxy"]&&[_personalModes.data.currentUser isEqualToString:@"Proxy"]){
                    self.PersonalBottomView.hidden = YES;
                }
                //先注销了
                [_PersonalTopView.btnView removeFromSuperview];
                _PersonalTopView.hidden = NO;
                [_PersonalTopView.icmBtn addTarget:self action:@selector(touxiangClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //_chengjiuArr = [TRZPersonalModell mj_objectArrayWithKeyValuesArray:_dataDic[@"achievements"]];
                _PersonalTopView.AmplifyImageView = [[UIImageView alloc]init];
                [_PersonalTopView.AmplifyImageView sd_setImageWithURL:[NSURL URLWithString:_personalModes.data.maxPhoto] placeholderImage:[UIImage imageNamed:@"展位图1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        weakSelf.maxImageComplete();
                        _isImageComplete = YES;
                    });
                    
                }];
                _PersonalTopView.nameLabel.text = _personalModes.data.name;//姓名
                _PersonalTopView.delegatee = self;
                _PersonalTopView.vipStr = _vipStr;
                _PersonalTopView.midStrr = _midStrr;
                _PersonalTopView.model = _personalModes.data;

                [self.PersonalTopView.beijiagImage sd_setImageWithURL:[NSURL URLWithString:_personalModes.data.bgImage] placeholderImage:[UIImage imageNamed:@"个人主页图"]];

                
                if ([_personalModes.data.userType isEqualToString:@"ShareProxy"]||[_personalModes.data.userType isEqualToString:@"ExpertProxy"]||[_personalModes.data.userType isEqualToString:@"OrgInvestorProxy"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]){
                    
                    _rzyysStr = @"1";//认证运营商
                }else{
                    _rzyysStr = @"0";//非认证运营商
                }
                if ([_personalModes.data.userType isEqualToString:@"Tourist"]||[_personalModes.data.userType isEqualToString:@"User"]) {//普通用户
                    _cehuatiteArr =  [NSMutableArray arrayWithArray:@[@"一键认证",@"钱包",@"客服中心"]]  ;
                }else if ([_personalModes.data.userType isEqualToString:@"Proxy"]) {//代理用户
                    _cehuatiteArr =  [NSMutableArray arrayWithArray:@[@"钱包",@"客服中心",@"我的购买"]]  ;
                }else {
                    _cehuatiteArr = [NSMutableArray arrayWithArray:@[@"钱包",@"收藏",@"客服中心"]];
                }
                
                if([_personalModes.data.userType isEqualToString:@"trzx"]){
                    [_cehuatiteArr removeObject:@"钱包"];
                    [_cehuatiteArr addObject:@""];
                }
                
                [_tableView reloadData];
            }
            
            
        }else{
            [self wuwang];
            
        }
        
        
    }];
    //    // 在信号量作废时，取消网络请求
    //    return [RACDisposable disposableWithBlock:^{
    //
    //        [TRZXNetwork cancelRequestWithURL:nil];
    //    }];
    
    //    }];
    
}



-(void)maxImageRemove{
    _isImageCompleteSecond = YES;
}

-(void)wuwang{
    if (![_otherTwoStr isEqualToString:@"2"]) {
        _PersonalTopView.iconImage.image = [UIImage imageNamed:@""];//默认头像
    }
    _PersonalTopView.xingbieImage.hidden = YES;
    _PersonalTopView.fuhuaImage.hidden = YES;
    _PersonalTopView.proxyImage.hidden = YES;
    [_tableView reloadData];
}
- (void)bgTableview
{
    if ([_otherStr isEqualToString:@"1"]){
        if ([_midStrr isEqualToString:[Login curLoginUser].userId]) {//其他方式自己看自己（默认的id）
            _otherTwoStr = @"1";
        }else{//看其他人
            _otherTwoStr = @"2";
        }
    }else{//自己看自己
        _midStrr = [Login curLoginUser].userId;//默认的id
        if (_midStrr.length == 0) {
            _midStrr = @"9cbde6d2b93a4c21ad20219af1b0f33b";
        }
        _otherTwoStr = @"0";
    }
    
    _HDGGStr = @"activity";
    _proxyArr = [[NSMutableArray alloc]init];
    _cehuatiteArr = [[NSMutableArray alloc]init];
    _menuArr = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = backColor;
    _gonggaoArr = [NSMutableArray array];
    _huodongArr = [NSMutableArray array];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.backgroundColor = backColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
    _PersonalTopView = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"PersonalTopView" owner:self options:nil] objectAtIndex:0];
    
    if ([_otherTwoStr isEqualToString:@"2"]) {
        _PersonalTopView.tiaozhaunView.hidden = YES;
    }
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shezhiClick:)];
    [_PersonalTopView.tiaozhaunView addGestureRecognizer:singleTap];
    self.tableView.tableHeaderView = _PersonalTopView;
    if ([_otherStr isEqualToString:@"1"]) {
        _PersonalTopView.hidden = YES;
    }else{
        _PersonalTopView.iconImage.image = [UIImage imageNamed:@""];
        _PersonalTopView.nameLabel.text = @"";//默认的名字
    }
    [self createUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(maxImageRemove) name:@"maxImageRemove" object:nil];
    
    _isImageCompleteSecond = YES;
    __block zjself;
    self.maxImageComplete = ^{
//        先注销放大图片
                [TRZSJAvatarBrowser showImage:sfself.PersonalTopView.AmplifyImageView];//调用方法
    };
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refersh) name:RCDUmengNotification object:nil];
    
}

//更新
-(void)refersh{
    
    //    [self.tableView reloadData];
    //    [self.collectionView reloadData];
    if(_midStrr == nil){
        _midStrr = [Login curLoginUser].userId;//默认的id
        [self bgTableview];
    }
    
    [self caidanShuJu];
}

-(void)createUI{
    _presonalNavgationViw = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"presonalNavgationViw" owner:self options:nil] objectAtIndex:0];
    _presonalNavgationViw.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    _titleLab = [[UILabel alloc]init];
    _titleLab.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
    [_presonalNavgationViw addSubview:_titleLab];
    _titleLab.hidden = YES;
    if ([_otherTwoStr isEqualToString:@"0"]) {
        _presonalNavgationViw.fanhuiBtn.hidden = YES;
    }
    _presonalNavgationViw.fanhuiBtn.adjustsImageWhenHighlighted = NO;
    [_presonalNavgationViw.fanhuiBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _presonalNavgationViw.shoucangBtn.hidden = YES;
    
    //    [_presonalNavgationViw.shoucangBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    _presonalNavgationViw.shoucangBtn.hidden = YES;
    [_presonalNavgationViw.fenxiangBtn addTarget:self action:@selector(fenxiangClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_presonalNavgationViw];
    if ([_personalModes.data.currentUser isEqualToString:@"TradingCenter"]){//交易中心
        _presonalNavgationViw.biaotiLabel.text = @"交易中心的主页";
    }else{
        if ([_otherTwoStr isEqualToString:@"2"]) {
            _presonalNavgationViw.biaotiLabel.text = @"个人主页";
        }else{
            _presonalNavgationViw.biaotiLabel.text = @"我";
        }
    }
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_presonalNavgationViw.mas_top).offset(63.5);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@(0.5));
    }];
    _presonalNavgationViw.backgroundColor=[[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1] colorWithAlphaComponent:0];
    _presonalNavgationViw.bgView.backgroundColor=[[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1] colorWithAlphaComponent:0];
    _titleLab.tag = 10002112;
    _presonalNavgationViw.tag = 10002112;
    _presonalNavgationViw.biaotiLabel.tag = 1920219;
    _presonalNavgationViw.biaotiLabel.textColor = [UIColor clearColor];
    
    
    //    NSData *datae = [[NSUserDefaults standardUserDefaults] objectForKey:@"BackBJImage"];
    //    if (datae) {
    //        UIImage *image = [UIImage imageWithData:datae];
    //        self.PersonalTopView.beijiagImage.image = image;
    //    }else{
    //        [self.PersonalTopView.beijiagImage sd_setImageWithURL:[NSURL URLWithString:_personalModes.data.bgImage] placeholderImage:[UIImage imageNamed:@"个人主页图"]];
    //    }
    
    //    注册通知 更换背景图片
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBackGroundView:) name:ImageGoBack object:nil];
    
}

#pragma mark - 加载数据
-(void)setIsRefersh:(BOOL)isRefersh{
    _isRefersh = isRefersh;
    if (isRefersh) {
        [self caidanShuJu];
        _isRefersh = NO;
    }
}


#pragma mark - 更换背景图片

-(void)changeBackGroundView:(NSNotification *)notifi{
    
    UIImage *image = notifi.object;
    
    self.PersonalTopView.beijiagImage.image = image;
    [self caidanShuJu];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1001010||scrollView.tag == 2001010) {
    }else{
        UILabel *mainTitle = [_presonalNavgationViw viewWithTag:1920219];
        UIColor *color=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
        CGFloat offset=scrollView.contentOffset.y;
        
        if (offset<10) {
            _presonalNavgationViw.backgroundColor = [color colorWithAlphaComponent:0];
            _presonalNavgationViw.bgView.backgroundColor = [color colorWithAlphaComponent:0];
            _titleLab.hidden = YES;
            mainTitle.backgroundColor = [color colorWithAlphaComponent:0];
            mainTitle.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:0];
            [_presonalNavgationViw.shoucangBtn setImage:[UIImage imageNamed:@"bianjiW"] forState:UIControlStateNormal];
            [_presonalNavgationViw.fanhuiBtn setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
            [_presonalNavgationViw.fanhuiBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
            [_presonalNavgationViw.fenxiangBtn setImage:[UIImage imageNamed:@"shareW"] forState:UIControlStateNormal];
            _statusBarType = NO;
        }else {
            [_presonalNavgationViw.fanhuiBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
            [_presonalNavgationViw.fanhuiBtn setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
            [_presonalNavgationViw.shoucangBtn setImage:[UIImage imageNamed:@"bianjiG"] forState:UIControlStateNormal];
            [_presonalNavgationViw.fenxiangBtn setImage:[UIImage imageNamed:@"shareG"] forState:UIControlStateNormal];
            CGFloat alpha=1-((64+10-offset)/64);
            //            _presonalNavgationViw.backgroundColor=[color colorWithAlphaComponent:alpha];
            _presonalNavgationViw.bgView.backgroundColor=[color colorWithAlphaComponent:alpha];
            mainTitle.textColor = [color colorWithAlphaComponent:alpha];
            _titleLab.hidden = YES;
            mainTitle.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:alpha];
            //            [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:alpha];
            _statusBarType = YES;
        }
        
        
        CGPoint contentOffset = scrollView.contentOffset;
        if (contentOffset.y < 0) {
            CGRect rect =self.PersonalTopView.frame;
            rect.origin.y = contentOffset.y;
            rect.size.height =CGRectGetHeight(rect)-contentOffset.y;
            self.PersonalTopView.beijiagImage.frame = rect;
            self.PersonalTopView.clipsToBounds=NO;
        }
        if (scrollView.contentOffset.y <= -80) {
            _refreshStr = @"1";
        }else if (scrollView.contentOffset.y >= 0)  {
            if ([_refreshStr isEqualToString:@"1"]) {
                _refreshStr = @"0";
                [self caidanShuJu];
                
            }
        }
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    control.tintColor = [UIColor clearColor];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [control beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:control];
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    [self caidanShuJu];
    [control endRefreshing];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarType?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

#pragma mark collection data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([_personalModes.data.userType isEqualToString:@"Tourist"]||[_personalModes.data.userType isEqualToString:@"User"]||[_dangqianStr isEqualToString:@"1"]) {
        return 2;
    }else if ([_rzyysStr isEqualToString:@"1"]) {//认证运营商
        return 3;
    }else{
        return 2;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, 0);
    }else{
        return CGSizeMake(self.view.frame.size.width, 10);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _cehuatiteArr.count;
    }else if (section == 1) {
        if ([_personalModes.data.userType isEqualToString:@"Proxy"]) {//代表
            if (_proxyArr.count <= 3) {
                return 3;
            }else if (_proxyArr.count <= 6) {
                return 6;
            }else{
                return 9;
            }
        }else{
            if (_menuArr.count <= 3) {
                return 3;
            }else if (_menuArr.count <= 6) {
                return 6;
            }else{
                return 9;
            }
        }
    }else{
        if (_proxyArr.count <= 3) {
            return 3;
        }else if (_proxyArr.count <= 6) {
            return 6;
        }else{
            return 9;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CeHuaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CeHuaCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = _cehuatiteArr[indexPath.row];
        
        cell.icmImage.image = [UIImage imageNamed:_cehuatiteArr[indexPath.row]];
    }else if (indexPath.section == 1) {
        if ([_personalModes.data.userType isEqualToString:@"Proxy"]) {
            NSArray * proxy1Arr = [LatestLiveModel mj_objectArrayWithKeyValuesArray:_proxyArr];
            if (indexPath.row < proxy1Arr.count) {
                _proxyModel = [proxy1Arr objectAtIndex:indexPath.row];
                cell.model = _proxyModel;
            }
        }else{
            NSArray * menu1Arr = [LatestLiveModel mj_objectArrayWithKeyValuesArray:_menuArr];
            if (indexPath.row < menu1Arr.count) {
                _menuModel = [menu1Arr objectAtIndex:indexPath.row];
                cell.model = _menuModel;
            }
        }
    }else{
        NSArray * proxy1Arr = [LatestLiveModel mj_objectArrayWithKeyValuesArray:_proxyArr];
        if (indexPath.row < proxy1Arr.count) {
            _proxyModel = [proxy1Arr objectAtIndex:indexPath.row];
            cell.model = _proxyModel;
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width-2)/3, 66);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CeHuaCollectionViewCell *cell = (CeHuaCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.hongdian.hidden = YES;
    if ([cell.titleLabel.text isEqualToString:@"收藏"]){
        TRZXCollectionViewController * collectionController = [[TRZXCollectionViewController alloc]init];
        [self.navigationController pushViewController:collectionController animated:true];
    }else if ([cell.titleLabel.text isEqualToString:@"客服中心"]){
        UIViewController *vc = [Target_TRZXPersonalHome Action_TRZXCustomerCenterController];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"我的购买"]&&[_personalModes.data.userType isEqualToString:@"Proxy"]){
        
    }else if ([cell.titleLabel.text isEqualToString:@"一键认证"]){
        
    }else if ([cell.titleLabel.text isEqualToString:@"钱包"]){
        UIViewController *vc = [Target_TRZXPersonalHome Action_MyWalletViewController:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.midLab.text isEqualToString:@"y129"]){//我的客户
        
    }else if ([cell.midLab.text isEqualToString:@"y130"]){//我的团队
        
    }else if ([cell.midLab.text isEqualToString:@"y131"]){ // 我的业绩
       
    }else if ([cell.midLab.text isEqualToString:@"y126"]) {//我的约见
        if ([_personalModes.data.userType isEqualToString:@"ShareInvestor"]||[_personalModes.data.userType isEqualToString:@"Share"]||[_personalModes.data.userType isEqualToString:@"ShareProxy"]) {//股东（我的专家）
            UIViewController *vc = [Target_TRZXPersonalHome Action_PersonalAppointment_MyExpertViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//专家、投资人（我的学员）
            UIViewController *vc = [Target_TRZXPersonalHome Action_PersonalAppointment_MyStudensController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([cell.midLab.text isEqualToString:@"y128"]){
        WoWenWoDaViewController * wowenView = [[WoWenWoDaViewController alloc] init];
        
        wowenView.midStrr = _midStrr;
        if ([_personalModes.data.userType isEqualToString:@"OrgInvestor"]||[_personalModes.data.userType isEqualToString:@"Expert"]||[_personalModes.data.userType isEqualToString:@"Brokerage"]||[_personalModes.data.userType isEqualToString:@"ExpertProxy"]||[_personalModes.data.userType isEqualToString:@"OrgInvestorProxy"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]) {//机构投资人、专家、券商
            wowenView.titleStrr = @"我的答复";
        }else if ([_personalModes.data.userType isEqualToString:@"Investor"]||[_personalModes.data.userType isEqualToString:@"ShareInvestor"]||[_personalModes.data.userType isEqualToString:@"Share"]||[_personalModes.data.userType isEqualToString:@"ShareProxy"]) {//股东、投资人
            wowenView.titleStrr = @"我的问答";
        }
        wowenView.title2Str = @"我的问答";
        [self.navigationController pushViewController:wowenView animated:YES];
    }else if ([cell.midLab.text isEqualToString:@"y109"]){//我的主题
        UIViewController *vc = [Target_TRZXPersonalHome Action_MyTheme_MyThemeViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.midLab.text isEqualToString:@"y132"]){//成为运营商
        TRZXPersonalYYSViewController * myThemeViewController = [[TRZXPersonalYYSViewController alloc]init];
        myThemeViewController.titleStr = @"成为合伙人";
        myThemeViewController.delegate = self;
        [self.navigationController pushViewController:myThemeViewController animated:true];
    }else if ([cell.midLab.text isEqualToString:@"y110"]){//我要讲课
        
    }else if ([cell.midLab.text  isEqualToString:@"y101"]){ // 录制路演
        
        
    }else if ([cell.midLab.text  isEqualToString:@"y100"]){ //发布项目
        
    }else if ([cell.midLab.text  isEqualToString:@"y118"]){// 商业计划书
        
    }else if ([cell.midLab.text  isEqualToString:@"y200"]){//我的购买
        TRZXPersonalMyBuyController * guanzhu = [[TRZXPersonalMyBuyController alloc] init];
        [self.navigationController pushViewController:guanzhu animated:YES];
    }else if ([cell.midLab.text  isEqualToString:@"y201"]){//我的发布
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0||section == 2||section == 5) {
        if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {
            return 0;
        }else{
            return 1;
        }
    }else if (section == 1){
        if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {
            return 0;
        }else{
            if (_personalModes.menus.count == 0) {
                return 0;
            }else{
                return 1;
            }
        }
    }else if (section == 3) {
        if ([_personalModes.data.userType isEqualToString:@"Tourist"]||[_personalModes.data.userType isEqualToString:@"User"]||[_personalModes.data.userType isEqualToString:@"TradingCenter"]||[_personalModes.data.userType isEqualToString:@"Proxy"]) {
            return 0;
        }else{
            if ([_otherTwoStr isEqualToString:@"2"]){
                return 2;
            }else{
                return 1;
            }
        }
        //        return 0;
    }else if (section == 4){
        if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {
            return 0;
        }else{
            if ([_ckptyhStr isEqualToString:@"1"]) {
                return 0;
            }else{
                return 1;
            }
        }
    }else if (section == 6) {
        if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {
            return 1;
        }else{
            return 0;
        }
    }else{
        if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {
            if ([_HDGGStr isEqualToString:@"activity"]) {
                return _huodongArr.count;
            }else{
                return _gonggaoArr.count;
            }
        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 35;
        
    }else if (indexPath.section == 1) {
        if ([_otherTwoStr isEqualToString:@"2"]){
            return 50;
        }else{
            if ([_personalModes.data.userType isEqualToString:@"Tourist"]||[_personalModes.data.userType isEqualToString:@"User"]||[_dangqianStr isEqualToString:@"1"]) {//普通用户
                return (_cehuatiteArr.count+2)/3*66+2+60+(12+66);
            }else if ([_personalModes.data.userType isEqualToString:@"Proxy"]) {//业务代表
                return (_cehuatiteArr.count+2)/3*66+(_proxyArr.count+2)/3*67+12+60;
            }else if ([_rzyysStr isEqualToString:@"1"]) {//代理商
                return (_cehuatiteArr.count+2)/3*66+(_menuArr.count+2)/3*67+(_proxyArr.count+2)/3*67+22+60;
            }else{
                return (_cehuatiteArr.count+2)/3*66+(_menuArr.count+2)/3*67+12+60;
            }
        }
    }else if (indexPath.section == 2) {
        return 100;
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            if (self.liveVedioArray.count == 0) {
                return 53;
            }else{
                return 210;
            }
        }else{
            if (_personalModes.data.achievements.count == 0) {
                return 53;
            }else{
                return 210;
            }
        }
    }else if (indexPath.section == 4) {
        return 60;
    }else if (indexPath.section == 5) {
        return 70;
    }else if (indexPath.section == 6) {
        return 95;
    }else {
        if ([_HDGGStr isEqualToString:@"notice"]){
            return 67;
        }else{
            return ((9*(SCREEN_WIDTH))/16)+120;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_personalModes.data) {
        return 8;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        xihuanTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"xihuanTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"xihuanTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        NSString * roadSeeCount = [NSString stringWithFormat:@"%ld",(long)_personalModes.data.roadSeeCount];
        NSString * roadSeeUserCount = [NSString stringWithFormat:@"%ld",(long)_personalModes.data.seeUserCount];
        NSString * roadFollowCount = [NSString stringWithFormat:@"%ld",(long)_personalModes.data.followCount];
        NSString * roadSangCount = [NSString stringWithFormat:@"%ld",(long)_personalModes.data.sangCount];
        if ([_personalModes.data.userType isEqualToString:@"User"]||[_personalModes.data.userType isEqualToString:@"Proxy"]) {
            _NewbtnArr = @[@"观看课程(集)",@"润嗓(次)"];
            _NewLabArr = @[roadSeeUserCount,roadSangCount];
        }else if([_personalModes.data.userType isEqualToString:@"Gov"]||[_personalModes.data.userType isEqualToString:@"TradingCenter"]){
            _NewbtnArr = @[@"关注(人)",@"观看课程(集)",@"观看路演(次)"];
            _NewLabArr = @[roadFollowCount,roadSeeUserCount,roadSeeCount];
            
        }else{
            _NewbtnArr = @[@"关注(人)",@"观看课程(集)",@"观看路演(次)",@"润嗓(次)"];
            _NewLabArr = @[roadFollowCount,roadSeeUserCount,roadSeeCount,roadSangCount];
        }
        CGSize sizee;
        sizee.width = (self.view.frame.size.width-(_NewbtnArr.count-1))/_NewbtnArr.count;
        for (int i = 0; i < _NewbtnArr.count; i ++) {
            UILabel * lable = [[UILabel alloc]init];
            //        lab.backgroundColor = [UIColor redColor];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = _NewLabArr[i];
            lable.textColor = moneyColor;
            lable.font = [UIFont systemFontOfSize:10];
            lable.frame = CGRectMake(sizee.width*i+ i*(i-1), 0, sizee.width, 20);
            [cell addSubview:lable];
            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [Btn setTitle:_NewbtnArr[i] forState:UIControlStateNormal];
            
            Btn.titleEdgeInsets = UIEdgeInsetsMake(15,0,0,0);
            Btn.frame = CGRectMake(sizee.width*i+ i*(i-1), 0, sizee.width, 35);
            [Btn setTitleColor:moneyColor forState:UIControlStateNormal];
            Btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [Btn addTarget:self action:@selector(BtnPushClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Btn];
        }
        for (int i = 0; i < _NewbtnArr.count-1; i ++) {
            UILabel * lable = [[UILabel alloc]init];
            lable.backgroundColor = moneyColor;
            lable.frame = CGRectMake(sizee.width*(i+1), 10, 1, 15);
            [cell addSubview:lable];
            
        }
        return cell;
    }else if (indexPath.section == 1) {
        if ([_otherTwoStr isEqualToString:@"2"]) {
            CeHuaTableView2Cell*cell = [tableView dequeueReusableCellWithIdentifier:@"CeHuaTableView2Cell"];
            if (!cell) {
                cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"CeHuaTableView2Cell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.backgroundColor = backColor;
            GifView *pathView =[[GifView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-233)/2, 0, 233, 58) filePath:[[NSBundle bundleForClass:[self class]] pathForResource:@"shenniu" ofType:@"gif"]];
            [cell addSubview:pathView];
            return cell;
        }else{
            CeHuaTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"CeHuaTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"CeHuaTableViewCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            UIButton * tiaozhuan = [UIButton buttonWithType:UIButtonTypeCustom];
            GifView *pathView =[[GifView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-233)/2, 0, 233, 58) filePath:[[NSBundle bundleForClass:[self class]] pathForResource:@"shenniu" ofType:@"gif"]];
            [cell addSubview:pathView];
            tiaozhuan.frame = CGRectMake((self.view.frame.size.width-233)/2, 0, 233, 58);
            [tiaozhuan addTarget:self action:@selector(gengduorenClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:tiaozhuan];
            UINib *cellNib = [UINib nibWithNibName:@"CeHuaCollectionViewCell" bundle:nil];
            [cell.cehuaCollection registerNib:cellNib forCellWithReuseIdentifier:@"CeHuaCollectionViewCell"];
            cell.cehuaCollection.tag = 1001010;
            
            self.collectionView = cell.cehuaCollection;
            cell.cehuaCollection.userInteractionEnabled = YES;
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }
    }else if (indexPath.section == 2) {
        PhotoDTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoDTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PhotoDTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.lineLab.backgroundColor = backColor;
        if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {//交易中心
            cell.titleLab.text = @"相册";
        }
        cell.imageOne.hidden = YES;
        cell.imageTwo.hidden = YES;
        cell.imageThree.hidden = YES;
        if (_personalModes.picList.count >3) {
            if (IS_IPHONE_4_OR_LESS||IS_IPHONE_5){
                for (int i = 0; i < 3; i ++) {
                    UIImageView * images = [[UIImageView alloc]init];
                    images.contentMode = UIViewContentModeScaleAspectFill;
                    images.clipsToBounds = YES;
                    [images sd_setImageWithURL:[NSURL URLWithString:[_personalModes.picList objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"展位图"]];
                    images.frame = CGRectMake(i*56 + 10 *(i + 1)+78, 27, 56, 56);
                    [cell addSubview:images];
                }
            }else{
                for (int i = 0; i < 4; i ++) {
                    UIImageView * images = [[UIImageView alloc]init];
                    images.contentMode = UIViewContentModeScaleAspectFill;
                    images.clipsToBounds = YES;
                    [images sd_setImageWithURL:[NSURL URLWithString:[_personalModes.picList objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"展位图"]];
                    images.frame = CGRectMake(i*56 + 10 *(i + 1)+78, 27, 56, 56);
                    [cell addSubview:images];
                }
            }
        }else{
            for (int i = 0; i < _personalModes.picList.count; i ++) {
                UIImageView * images = [[UIImageView alloc]init];
                images.contentMode = UIViewContentModeScaleAspectFill;
                images.clipsToBounds = YES;
                [images sd_setImageWithURL:[NSURL URLWithString:[_personalModes.picList objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"展位图"]];
                images.frame = CGRectMake(i*56 + 10 *(i + 1)+78, 27, 56, 56);
                [cell addSubview:images];
            }
        }
        return cell;
    }else if (indexPath.section == 3) {
        PersonalJianJieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalJianJieCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalJianJieCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        
        if (indexPath.row == 1) {
            if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {//交易中心
                cell.chengguo2Lab.text = @"成果";
            }else{
                cell.chengguo2Lab.text = @"个人成果";
            }
            [cell.gengduoBtn setTitle:@"更多成果" forState:UIControlStateNormal];
            cell.personalMode = _personalModes;
            [cell jiazaichegguoView];
            [cell.gengduoBtn addTarget:self action:@selector(gengduoClick:) forControlEvents:UIControlEventTouchUpInside];
            //先注销
            cell.moreDelegate = self;
            cell.chengguoStr = @"2";
        }else{
            if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {//交易中心
                cell.chengguo2Lab.text = @"直播";
            }else if ([_personalModes.data.userType isEqualToString:@"OrgInvestor"]||[_personalModes.data.userType isEqualToString:@"Expert"]||[_personalModes.data.userType isEqualToString:@"Brokerage"]||[_personalModes.data.userType isEqualToString:@"ExpertProxy"]||[_personalModes.data.userType isEqualToString:@"OrgInvestorProxy"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]) {//投资人、专家、券商
                cell.chengguo2Lab.text = @"直播课堂";
            }else if ([_personalModes.data.userType isEqualToString:@"ShareInvestor"]||[_personalModes.data.userType isEqualToString:@"Share"]||[_personalModes.data.userType isEqualToString:@"ShareProxy"]) {//股东
                cell.chengguo2Lab.text = @"路演直播";
            }else{
                cell.chengguo2Lab.text = @"个人直播";
            }
            cell.zhiboViewArr = self.liveVedioArray;
            [cell.gengduoBtn setTitle:@"更多直播" forState:UIControlStateNormal];
            [cell jiazaizhiboView];
            [cell.gengduoBtn addTarget:self action:@selector(zhiBoClick:) forControlEvents:UIControlEventTouchUpInside];
            //先注销
//            cell.moreDelegate = self;
            cell.zhiboStr = @"2";
        }
        return cell;
    }else if (indexPath.section == 4||indexPath.section == 5)  {
        StudentJingLiBTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentJingLiBTCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"StudentJingLiBTCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (indexPath.section == 4) {
            if ([_otherTwoStr isEqualToString:@"2"]) {
                if ([_personalModes.data.userType isEqualToString:@"OrgInvestor"]||[_personalModes.data.userType isEqualToString:@"Expert"]||[_personalModes.data.userType isEqualToString:@"Brokerage"]||[_personalModes.data.userType isEqualToString:@"ExpertProxy"]||[_personalModes.data.userType isEqualToString:@"OrgInvestorProxy"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]) {//机构投资人、专家、券商
                    if ([_personalModes.data.sex isEqualToString:@"女"]) {
                        cell.jingli2Lab.text = @"她的问答";//以前是答复
                    }else{
                        cell.jingli2Lab.text = @"他的问答";
                    }
                }else if ([_personalModes.data.userType isEqualToString:@"Investor"]||[_personalModes.data.userType isEqualToString:@"ShareInvestor"]||[_personalModes.data.userType isEqualToString:@"Share"]||[_personalModes.data.userType isEqualToString:@"ShareProxy"]) {//股东、投资人
                    if ([_personalModes.data.sex isEqualToString:@"女"]) {
                        cell.jingli2Lab.text = @"她的问答";
                    }else{
                        cell.jingli2Lab.text = @"他的问答";
                    }
                }
            }else{
                cell.jingli2Lab.text = @"邀请好友";
                cell.jingli2Lab.textColor = TRZXMainColor;
                cell.jingli2Lab.font =[UIFont boldSystemFontOfSize:17];
                
            }
        }else{
            cell.lineLab.backgroundColor = backColor;
            if ([_otherTwoStr isEqualToString:@"2"]) {
                if ([_personalModes.data.sex isEqualToString:@"女"]) {
                    cell.jingli2Lab.text = @"关于她";
                }else{
                    cell.jingli2Lab.text = @"关于他";
                }
            }else{
                cell.jingli2Lab.text = @"关于我";
            }
        }
        cell.xianLabel.hidden = YES;
        //            cell.jingliImage.image = [UIImage imageNamed:@"个人介绍"];
        cell.yanzhanImage.image = [UIImage imageNamed:@"延展"];
        return cell;
        
    }else if (indexPath.section == 6){
        PersonalJiaoYiTabCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalJiaoYiTabCell"];
            if (!cell) {
                cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalJiaoYiTabCell" owner:self options:nil] lastObject];
            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BzhiboClick:)];
        [cell.zhiboView addGestureRecognizer:tap1];
        
        cell.qiyeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qiyeClick:)];
        [cell.qiyeView addGestureRecognizer:tap2];
        
        if ([_HDGGStr isEqualToString:@"notice"]) {
            
            [_switcher forceSelectedIndex:1 animated:NO];
        }
        if ([_HDGGStr isEqualToString:@"activity"]) {
            [_switcher forceSelectedIndex:0 animated:NO];
            
        }
        
        zjself;
        [cell.switcher setPressedHandler:^(NSUInteger index) {
            if (index == 0) {
                _HDGGStr = @"activity";
                if ((sfself.huodongArr.count == 0)) {
                    [sfself createCommentData];
                }
            } else {
                _HDGGStr = @"notice";
                if ((sfself.gonggaoArr.count == 0)) {
                    [sfself createCommentData];
                }
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:7];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        return cell;
    }else{
        if ([_HDGGStr isEqualToString:@"notice"]) {
            xiaoxiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xiaoxiCell"];
            if (!cell) {
                cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"xiaoxiCell" owner:self options:nil] lastObject];
            }
            cell.line1Image.backgroundColor = backColor;
            TRZPersonalModell *mode = [_gonggaoArr objectAtIndex:indexPath.row];
            cell.biaotiLabel.text = mode.msgTitle;
            cell.shijianLabel.text = mode.date;
            return cell;
        }else{
            xiaoxi2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"xiaoxi2Cell"];
            if (!cell) {
                cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"xiaoxi2Cell" owner:self options:nil] lastObject];
            }
            cell.backgroundColor = backColor;
            TRZPersonalModell *mode = [_huodongArr objectAtIndex:indexPath.row];
            
            [cell.topImage sd_setImageWithURL:[NSURL URLWithString:mode.msgzPic]placeholderImage:[UIImage imageNamed:@"展位图"]];
            cell.timeLabel.text = mode.date;
            
            cell.whoLabel.text = mode.authName;
            cell.biaotiLabel.text = mode.msgTitle;
            cell.jianjieLabel.text = mode.msgDigest;
            
            return cell;
        }
    }
    
}
//交易中心网络请求
- (void)createCommentData{
    NSDictionary *params = @{@"requestType":@"Temple_Exchange_Api",
                            @"apiType":@"noticeOrActivity",
                            @"type":_HDGGStr?_HDGGStr:@"",
                            @"exchangeId":_personalModes.exchangeId?_personalModes.exchangeId:@""
                            };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
    
        if ([object[@"status_code"] isEqualToString:@"200"]) {

            if ([_HDGGStr isEqualToString:@"notice"]) {
                NSDictionary *Dic1 = object[@"data"];
                _gonggaoArr = [TRZPersonalModell mj_objectArrayWithKeyValuesArray:Dic1];
            }else {
                NSDictionary *Dic = object[@"data"];
                _huodongArr = [TRZPersonalModell mj_objectArrayWithKeyValuesArray:Dic];
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:7];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];


        } else {

        }

    }];
}


//润嗓的跳转
- (void)runsangClick:(UIButton *)btn
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if ([_otherTwoStr isEqualToString:@"2"]) {
            if ([_personalModes.isAlso isEqualToString:@"Complete"]) {
                UIViewController *vc = [Target_TRZXPersonalHome FriendCircle_PhotoTimeLineTableViewController];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([_personalModes.data.userType isEqualToString:@"Proxy"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂无权限查看" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加好友才可以查看相册" message:nil delegate:self cancelButtonTitle:@"添加好友" otherButtonTitles:@"取消", nil];
                [alert show];
                [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                    if ([indexNumber intValue] == 0) {
                        //加好友
                    }
                }];
            }
        }else{
            UIViewController *vc = [Target_TRZXPersonalHome FriendCircle_PhotoTimeLineTableViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 4) {
        if ([_otherTwoStr isEqualToString:@"2"]) {
            if ([_personalModes.data.userType isEqualToString:@"OrgInvestor"]||[_personalModes.data.userType isEqualToString:@"Expert"]||[_personalModes.data.userType isEqualToString:@"Brokerage"]||[_personalModes.data.userType isEqualToString:@"ExpertProxy"]||[_personalModes.data.userType isEqualToString:@"OrgInvestorProxy"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]) {//机构投资人、专家、券商
                WoWenWoDaViewController * wowenView = [[WoWenWoDaViewController alloc] init];
                wowenView.midStrr = _midStrr;
                if ([_personalModes.data.sex isEqualToString:@"女"]) {
                    wowenView.titleStrr = @"她的答复";
                    wowenView.title2Str = @"她的问答";
                }else{
                    wowenView.titleStrr = @"他的答复";
                    wowenView.title2Str = @"他的问答";
                }
                [self.navigationController pushViewController:wowenView animated:YES];
            }else if ([_personalModes.data.userType isEqualToString:@"Investor"]||[_personalModes.data.userType isEqualToString:@"ShareInvestor"]||[_personalModes.data.userType isEqualToString:@"Share"]||[_personalModes.data.userType isEqualToString:@"ShareProxy"]) {//股东、投资人
                WoWenWoDaViewController * wowenView = [[WoWenWoDaViewController alloc] init];
                wowenView.midStrr = _midStrr;
                if ([_personalModes.data.sex isEqualToString:@"女"]) {
                    wowenView.titleStrr = @"她的问答";
                    wowenView.title2Str = @"她的问答";
                }else{
                    wowenView.titleStrr = @"他的问答";
                    wowenView.title2Str = @"他的问答";
                }
                [self.navigationController pushViewController:wowenView animated:YES];
            }
        }else{
            TRNewShareViewController *InviteFriend = [[TRNewShareViewController alloc]initWithNibName:@"TRNewShareViewController" bundle:nil];
            InviteFriend.imageUrl = _personalModes.twoCode;
            InviteFriend.smsUrl = _personalModes.inviteUrl;
            InviteFriend.smsInviteUrl = _personalModes.smsInviteUrl;
            [self.navigationController pushViewController:InviteFriend animated:YES];
        }
    }
    if (indexPath.section == 5) {
        //关于我
        UIViewController *vc = [Target_TRZXPersonalHome Action_PersonalProfileViewControllerTitle:@"" eduArr:_personalModes.data.userEducationExperiences workArr:_personalModes.data.userWorkExperience userType:_personalModes.data.userType abstract:_personalModes.data.abstractz];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//关注的跳转
- (void)topGuanzhuClick:(UIButton *)sender{
    TRZXPersonalTopButtonController * guanzhu = [[TRZXPersonalTopButtonController alloc] init];
    guanzhu.midStrr = _midStrr;
    guanzhu.titleStrr = @"关注";
    [self.navigationController pushViewController:guanzhu animated:YES];
}
#pragma 直播股所
- (void)BzhiboClick:(UITapGestureRecognizer *)tap
{
    
    //直播股所的跳转
    
}

//孵化企业
- (void)qiyeClick:(UITapGestureRecognizer *)tap
{
    
}

// view 的代理方法
-(void)pushPersonalController:(UIViewController *)Controller{
    [self.navigationController pushViewController:Controller animated:YES];
    
}

//更多直播点击事件
- (void)zhiBoClick:(UITapGestureRecognizer *)tap
{
    PersonalZhiBoViewController *zhiBoVc = [[PersonalZhiBoViewController alloc]init];
    zhiBoVc.isSelf  = YES;
    
    zhiBoVc.delegate = self;
    
    if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {//交易中心
        zhiBoVc.titleStr = @"直播";
    }else if ([_personalModes.data.userType isEqualToString:@"OrgInvestor"]||[_personalModes.data.userType isEqualToString:@"Expert"]||[_personalModes.data.userType isEqualToString:@"Brokerage"]||[_personalModes.data.userType isEqualToString:@"ExpertProxy"]||[_personalModes.data.userType isEqualToString:@"OrgInvestorProxy"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]) {//投资人、专家、券商
        zhiBoVc.titleStr = @"直播课堂";
    }else if ([_personalModes.data.userType isEqualToString:@"ShareInvestor"]||[_personalModes.data.userType isEqualToString:@"Share"]||[_personalModes.data.userType isEqualToString:@"ShareProxy"]) {//股东
        zhiBoVc.titleStr = @"路演直播";
    }else{
        zhiBoVc.titleStr = @"个人直播";
    }
    zhiBoVc.otherStr = _otherTwoStr;
    zhiBoVc.beVistedId = self.midStrr;
    [self.navigationController pushViewController:zhiBoVc animated:YES];
}

//更多
- (void)gengduoClick:(UIButton *)sender{
    
    PersonalChengJiuVC * gengduo = [[PersonalChengJiuVC alloc] init];
    if ([_personalModes.data.userType isEqualToString:@"Brokerage"]||[_personalModes.data.userType isEqualToString:@"BrokerageProxy"]) {//券商
        gengduo.titleStrr = @"个人成果";
    }else if ([_personalModes.data.userType isEqualToString:@"TradingCenter"]) {//交易中心
        gengduo.titleStrr = @"交易中心的成果";
    }else if ([_personalModes.data.userType isEqualToString:@"Gov"]) {//政府
        gengduo.titleStrr = @"政府的成果";
    }else{
        gengduo.titleStrr = @"个人成果";
    }
    gengduo.midStrr = _midStrr;
    [self.navigationController pushViewController:gengduo animated:YES];
    
}

-(void)pushAllSetting{
    [self caidanShuJu];
}
//设置的跳转
- (void)shezhiClick:(UITapGestureRecognizer *)sender{
    
    
}

//返回
- (void)backBtnClick:(UIButton *)sender{
    //    if ([_fanhuiStr isEqualToString:@"1"]) {
    //
    //        _statusBarType = YES;
    //        [self setNeedsStatusBarAppearanceUpdate];
    //        [self.navigationController popViewControllerAnimated:true];
    //    }else{
    //
    //        if ([_headBackStr isEqualToString:@"1"]) {
    //            self.navigationController.navigationBarHidden = NO;
    //            self.automaticallyAdjustsScrollViewInsets = YES;
    //        }
    [self.navigationController popViewControllerAnimated:true];
    //    }
}

//头像
- (void)touxiangClick:(UIButton *)sender{
    
    if (_isImageComplete) {
        if (_isImageCompleteSecond) {
            
            self.maxImageComplete();
            _isImageCompleteSecond = NO;
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self touxiangClick:nil];
        });
    }
}


//投融在线攻略跳转
- (void)gengduorenClick:(UIButton *)sender{
    TRZXStrategyViewController * setController = [[TRZXStrategyViewController alloc] init];
    [self.navigationController pushViewController:setController animated:YES];
}
//分享的事件
- (void)fenxiangClick:(UIButton *)sender{
    
}

//按钮的跳转
- (void)BtnPushClick:(UIButton *)sender{
    //顶部的按钮跳转
    if([sender.titleLabel.text isEqualToString:@"关注(人)"]){
        if ([_otherTwoStr isEqualToString:@"2"]) {
            TRZXPersonalTopButtonController * guanzhu = [[TRZXPersonalTopButtonController alloc] init];
            guanzhu.midStrr = _midStrr;
            guanzhu.titleStrr = @"关注";
            [self.navigationController pushViewController:guanzhu animated:YES];
        }else{
            TRZXPersonalCareAboutController * guanzhu = [[TRZXPersonalCareAboutController alloc] init];
            guanzhu.midStr = _midStrr;
            guanzhu.delegate = self;
            [self.navigationController pushViewController:guanzhu animated:YES];
        }
        
    }else if([sender.titleLabel.text isEqualToString:@"观看课程(集)"]){
        TRZXPersonalWatchController * sanjiVC = [[TRZXPersonalWatchController alloc] init];
        sanjiVC.midStr = _midStrr;
        sanjiVC.panduanStr = @"观看课程";
        sanjiVC.delegate = self;
        [self.navigationController pushViewController:sanjiVC animated:YES];
    }else if([sender.titleLabel.text isEqualToString:@"观看路演(次)"]){
        TRZXPersonalWatchController * sanjiVC = [[TRZXPersonalWatchController alloc] init];
        sanjiVC.midStr = _midStrr;
        sanjiVC.panduanStr = @"观看路演";
        sanjiVC.delegate = self;
        [self.navigationController pushViewController:sanjiVC animated:YES];
    }
}
//加关注
- (void)bottomGuanzhuClick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
        _quxiaoStr = @"1";
    NSDictionary *params = @{@"requestType":@"OnlineSchool_Api",
                            @"watchId":_midStrr,
                            @"apiType":@"watch"};
    
     [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
         
        if ([data[@"status_code"] isEqualToString:@"200"]) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关注成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            _guanzhuStr = @"1";
            [self caidanShuJu];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关注失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        sender.userInteractionEnabled = YES;
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.PersonalBottomView guanzhuBtnStatusChange];
    [[NSNotificationCenter defaultCenter] postNotificationName:collectionStasusChangeKey object:nil];
}


//投递BP事件
-(void)BPButtonDidClick:(UIButton *)button{
    
    
}

#pragma mark - properties
-(PersonalBottomView *)PersonalBottomView{
    if (!_PersonalBottomView) {
        _PersonalBottomView = [[PersonalBottomView alloc]init];
        _PersonalBottomView.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
        [_PersonalBottomView.guanzhuBtn addTarget:self action:@selector(bottomGuanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [_PersonalBottomView.sixinBtn addTarget:self action:@selector(sixinClick:) forControlEvents:UIControlEventTouchUpInside];
        [_PersonalBottomView.BPButton addTarget:self action:@selector(BPButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _PersonalBottomView.hidden = YES;
    }
    return _PersonalBottomView;
}

@end


