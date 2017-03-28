//
//  TRZXProjectPageController.m
//  TRZXProject
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectPageViewController.h"
#import "TRZXHotProjectViewController.h"
#import "TRZXAllProjectViewController.h"
#import "TRZXKit.h"
#import <TRZXProjectScreeningBusinessCategory/CTMediator+TRZXProjectScreening.h>

@interface TRZXProjectPageViewController ()

@property (strong, nonatomic) TRZXHotProjectViewController *hotProjectViewController; //
@property (strong, nonatomic) TRZXAllProjectViewController *allProjectViewController; //
@property (strong, nonatomic) UIViewController *projectScreeningVC; //

@end

@implementation TRZXProjectPageViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.projectTitle;

    [self setRightBarItemImage:[UIImage imageNamed:@"筛选"] title:@"筛选"];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];


    NSInteger viewTop = 64;
    
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 14.0f;
    self.titleSizeNormal = 14.0f;
    self.titleColorSelected = [UIColor trzx_NavTitleColor];
    self.titleColorNormal = [UIColor trzx_TextColor];
    self.progressWidth = self.view.width/4;
    self.progressColor = [UIColor redColor];
    self.menuBGColor = [UIColor whiteColor];
    self.menuHeight = 45;
    self.titles = @[@"推荐项目", @"海量项目"];
    self.viewFrame = CGRectMake(0, viewTop, self.view.width, self.view.height - viewTop);

    [self reloadData];

    // Do any additional setup after loading the view.
}

/**
 *  需继承实现右侧点击事件
 */
- (void)rightBarItemAction:(UITapGestureRecognizer *)gesture{

    if (self.projectScreeningVC) {
        [self.navigationController pushViewController:self.projectScreeningVC animated:true];
    }


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
    switch (index) {
        case 0: {
            self.hotProjectViewController = [[TRZXHotProjectViewController alloc] init];
            return self.hotProjectViewController;
        }
            break;
        case 1: {
            self.allProjectViewController = [[TRZXAllProjectViewController alloc] init];
            return self.allProjectViewController;
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

//- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
//    NSLog(@"%@", info);
//}

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


-(UIViewController *)projectScreeningVC{
    if (!_projectScreeningVC) {
        _projectScreeningVC = [[CTMediator sharedInstance] projectScreeningViewControllerWithScreeningType:@"1" projectTitle:@"项目筛选" confirmComplete:^(NSString *trade, NSString *stage) {
            if (self.selectIndex==0) {
                [self.hotProjectViewController refreshTrade:trade stage:stage];
            }else{
                [self.allProjectViewController refreshTrade:trade stage:stage];
            }
            
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
