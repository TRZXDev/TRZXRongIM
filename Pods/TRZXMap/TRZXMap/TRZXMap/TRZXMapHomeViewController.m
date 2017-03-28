//
//  TRZXMapHomeViewController.m
//  TRZXMap
//
//  Created by N年後 on 2017/2/28.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapHomeViewController.h"
#import "TRZXMapViewController.h"
#import "TRZXMapListViewController.h"
#import "Masonry.h"
#import "TRZXKit.h"
#import <TRZXProjectScreeningBusinessCategory/CTMediator+TRZXProjectScreening.h>
#import "TRZXMapCityViewController.h"
#import "TRZXMap.h"


@interface TRZXMapHomeViewController ()
@property (strong, nonatomic) TRZXMapViewController *mapViewController; //
@property (strong, nonatomic) TRZXMapListViewController *mapListViewController; //
@property (strong, nonatomic) UIViewController *projectScreeningVC; //
@property (strong, nonatomic) TRZXMapCityViewController *mapCityViewController;
@property (strong, nonatomic) UIButton *rightButton; //

@property (nonatomic) BOOL isReloadData; //


//筛选
@property (nonatomic,strong)UIButton *fiterBtn;
@end

@implementation TRZXMapHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {



    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.isReloadData) {
        self.isReloadData = !self.isReloadData;
        [self reloadData];
    }

}




- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleSizeSelected = 15;
    self.pageAnimatable = YES;
    self.menuHeight = 40;
    //    self.menuItemWidth = 100;
    self.showOnNavigationBar = YES;
    self.titleSizeSelected = 15;
    self.progressWidth = 60;
    self.menuViewStyle = WMMenuViewStyleSegmented;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.titleColorSelected = [UIColor whiteColor];
    self.menuBGColor = [UIColor whiteColor];

    self.titleColorNormal = [UIColor trzx_RedColor];
    self.progressColor = [UIColor trzx_RedColor];
    self.titles = @[@"地图", @"列表"];


    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.view addSubview:self.fiterBtn];
    [self.fiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(71);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(40));
    }];



}

-(void)clickEvent{


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {

    __weak TRZXMapHomeViewController *weakSelf = self;


    switch (index) {
        case 0: {
            self.mapViewController = [[TRZXMapViewController alloc] init];
            self.mapViewController.mapInitCompleteBlock = ^(TRZXMapViewModel *mapViewModel){
                [weakSelf setRightButtonTitle:mapViewModel.locality];
            };
            return self.mapViewController;
        }
            break;
        case 1: {
            self.mapListViewController = [[TRZXMapListViewController alloc] init];
            [self.mapListViewController setCurrentCoordinate:self.mapViewController.mapViewModel.currentCoordinate];
            return self.mapListViewController;
        }
        default: {
            return [[UIViewController alloc] init];
        }
            break;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return nil;
    }

    return self.titles[index];
}



- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@", info);




}



- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSInteger index = [info[@"index"] integerValue];
    [self.menuView updateBadgeViewAtIndex:index];
}

- (void)menuView:(WMMenuView *)menu didLayoutItemFrame:(WMMenuItem *)menuItem atIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromCGRect(menuItem.frame));
}

- (WMMenuItem *)menuView:(WMMenuView *)menu initialMenuItem:(WMMenuItem *)initialMenuItem atIndex:(NSInteger)index {
    initialMenuItem.attributedText = [[NSAttributedString alloc] initWithString:self.titles[index]];
    return initialMenuItem;
}


- (UIButton *)fiterBtn{
    if (!_fiterBtn) {
        _fiterBtn = [[UIButton alloc]init];
        [_fiterBtn setBackgroundImage:[UIImage imageNamed:@"map_fifter"] forState:UIControlStateNormal];
        _fiterBtn.adjustsImageWhenDisabled = NO;
        [_fiterBtn addTarget:self action:@selector(fiterBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _fiterBtn;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 56, 30);
        _rightButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail; //加上这句话就可以
        [_rightButton setTitleColor:[UIColor trzx_RedColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightButton;
}

-(void)rightAction:(UIButton *)button{

    [self.navigationController pushViewController:self.mapCityViewController animated:true];

}


-(UIViewController *)mapCityViewController{
    __weak TRZXMapHomeViewController *weakSelf = self;

    if (!_mapCityViewController) {
        _mapCityViewController = [[TRZXMapCityViewController alloc]init];
        _mapCityViewController.cityCallback = ^(NSDictionary *dic){
            [weakSelf setRightButtonTitle:dic[@"name"]];
            [weakSelf.mapViewController setCity:dic];
            [weakSelf.mapListViewController setCity:dic];
        };
    }
    return _mapCityViewController;
}


-(void)setRightButtonTitle:(NSString*)title{

    if (title.length>0) {
        if ([title hasSuffix:@"市"]) {
            [self.rightButton setTitle: [title substringToIndex:[title length]-1] forState:UIControlStateNormal];
        }else{
            [self.rightButton setTitle:title forState:UIControlStateNormal];
        }
    }
}



#pragma mark - 项目筛选
- (void)fiterBtnClick:(UIButton *)button{

    if (self.projectScreeningVC) {
        [self.navigationController pushViewController:self.projectScreeningVC animated:true];
    }

}


-(UIViewController *)projectScreeningVC{
    if (!_projectScreeningVC) {
        _projectScreeningVC = [[CTMediator sharedInstance] projectScreeningViewControllerWithScreeningType:@"1" projectTitle:@"项目筛选" confirmComplete:^(NSString *trade, NSString *stage) {

            NSArray *tradeIds;
            NSArray *stageIds; //阶段id数组
            if (trade.length>0) {
                tradeIds = [trade componentsSeparatedByString:@","]; //领域id数组
            }
            if (stage.length>0) {
                stageIds = [stage componentsSeparatedByString:@","]; //阶段id数组
            }

            [self.mapViewController setTradeIds:tradeIds stageIds:stageIds];
            [self.mapListViewController setTradeIds:tradeIds stageIds:stageIds];;

        }];
    }
    return _projectScreeningVC;
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
