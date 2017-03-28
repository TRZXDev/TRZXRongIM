//
//  RCDAddFriendListViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/4.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDAddFriendListViewController.h"
#import "RCDAddFriendCell.h"
#import "RCDHttpTool.h"
#import "RCDSearchFriendViewController.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"
#import "KPTableViewDataSource.h"

@interface RCDAddFriendListViewController ()
/**
  添加新的好友数据
 */
@property(nonatomic, strong) NSMutableArray *addFriends;

@property(nonatomic, assign) NSUInteger pageNo;

@property(nonatomic, assign) NSUInteger totalPageNo;

@end

@implementation RCDAddFriendListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor trzx_BackGroundColor];
    self.title = @"新的好友";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    UIButton *button = [UIButton RC_buttonWithTitle:@"添加好友" color:[UIColor trzx_YellowColor] imageName:nil target:self action:@selector(rightBarButtonItemPressed:)];
//    button.cornerRadius = 6;
//    button.backgroundColor = [UIColor trzx_YellowColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(0, 0, 70, 25);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[RCDHttpTool shareInstance] requestAddFriendListPageNo:self.pageNo complete:^(NSArray *addFriends , NSUInteger totalPageNo) {
        if (addFriends.count) {
            [self.addFriends removeAllObjects];
            [self.addFriends addObjectsFromArray:addFriends];
            self.totalPageNo = totalPageNo;
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    }];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pageNo = 1;
//        [[RCDHttpTool shareInstance] requestAddFriendListPageNo:self.pageNo complete:^(NSArray *addFriends , NSUInteger totalPageNo) {
//            if (addFriends.count) {
//                [self.addFriends removeAllObjects];
//                [self.addFriends addObjectsFromArray:addFriends];
//                self.totalPageNo = totalPageNo;
//                [self.tableView reloadData];
//            }
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer setState:MJRefreshStateIdle];
//        }];
//    }];
//    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.pageNo++;
//        if(self.pageNo <= self.totalPageNo){
//            [[RCDHttpTool shareInstance] requestAddFriendListPageNo:self.pageNo complete:^(NSArray *addFriends , NSUInteger totalPageNo) {
//                [self.addFriends addObjectsFromArray:addFriends];
//                self.totalPageNo = totalPageNo;
//                [self.tableView reloadData];
//                [self.tableView.mj_footer endRefreshing];
//            }];
//        }else{
//            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
//        }
//    }];
    [self.tableView kipo_makeDataSource:^(KPTableViewDataSourceMaker *make) {
        [make commitEditing:^(UITableView *tableView, UITableViewCellEditingStyle *editingStyle, NSIndexPath *indexPath) {// 左滑删除
            RCDAddFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [[RCDHttpTool shareInstance] deleteAddFriendListWithId:cell.userInfo.friendRelationshipId complete:^(BOOL isSuccess) {
                [self.addFriends removeObject:cell.userInfo];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [[RCDataBaseManager shareInstance] deleteAddFriendMessage:cell.userInfo.friendRelationshipId];
            }];
        }];
       [make makeSection:^(KPTableViewSectionMaker *section) {
           section.cell([RCDAddFriendCell class])       //cell
           .data(self.addFriends)                       //数据
           .adapter(^(RCDAddFriendCell *cell , id data , NSUInteger index){ //适配器:提供参数
               cell.userInfo = data;
           }).autoHeight()                                //高度
           .Event(^(NSUInteger index , RCDUserInfo *userInfo){
               
               UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:userInfo.userId];
               if (personalHomeVC) {
                   [self.navigationController  pushViewController:personalHomeVC animated:YES];
               }
           });
       }];
    }];
}
#pragma mark - Action
-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBarButtonItemPressed:(UIButton *)button{
    RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
    [self.navigationController pushViewController:searchFirendVC  animated:YES];
}

#pragma mark - Properites
-(NSMutableArray *)addFriends{
    if (!_addFriends) {
        _addFriends = [NSMutableArray array];
    }
    return _addFriends;
}
@end
