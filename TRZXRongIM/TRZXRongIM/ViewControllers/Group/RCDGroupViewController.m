//
//  SecondViewController.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDGroupViewController.h"
 
#import "RCDHttpTool.h"
#import "RCDGroupTableViewCell.h"
#import "RCDGroupInfo.h"

#import "RCDCommonDefine.h"
#import "RCDLoginInfo.h"

#import "RCDChatViewController.h"
#import "UIColor+RCColor.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"

@interface RCDGroupViewController ()<UITableViewDataSource,UITableViewDelegate,JoinQuitGroupDelegate>

@property(nonatomic, strong) NSMutableArray* groups;

@end

@implementation RCDGroupViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置为不用默认渲染方式
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_group"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_group_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView样式
    self.tableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.tableView.tableFooterView = [UIView new];
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12)];
    
//    __weak RCDGroupViewController *weakSelf = self;
//    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
//        _groups = result;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView reloadData];
//        });
//        
//    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"群组";
    self.tabBarController.navigationItem.titleView = titleView;

    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    __weak RCDGroupViewController *weakSelf = self;
    _groups=[NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance]getAllGroup]];
    

    if (_groups==nil||_groups.count<1) {
        [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
            _groups =[NSMutableArray arrayWithArray: result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _groups.count;
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    RCDGroupInfo *groupInfo=[_groups objectAtIndex:indexPath.row];

    [destination setValue:groupInfo forKey:@"groupInfo"];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RCDGroupCell";
    RCDGroupTableViewCell *cell = (RCDGroupTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    RCDGroupInfo*group = _groups[indexPath.row];
    cell.lblGroupName.text=group.groupName;
    cell.groupID=group.groupId;
    cell.lblInstru.text = @"群组介绍";
    cell.delegate=self;
    cell.isJoin = group.isJoin;
    if ([group.number isEqualToString:@""]) {
         cell.lblPersonNumber.text=@"";
    }else{
        cell.lblPersonNumber.text=[NSString stringWithFormat:@"%@/%@",group.number,group.maxNumber];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}


- (void)joinGroupCallback:(BOOL) result withGroupId:(NSString *)groupId
{
    if (result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"加入成功！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }else
    {
        NSString *msg=@"加入失败";
        for (RCDGroupInfo *group in _groups) {
            if ([group.groupId isEqualToString:groupId]) {
                if(group.number==group.maxNumber)
                    msg=@"群组人数已满";
            }
        }

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    [RCDDataSource syncGroups];
    __weak RCDGroupViewController *weakSelf = self;
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        _groups = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    }];


}

-(void) launchGroupChatPageByGroupId:(NSString*)groupId
{
    RCDGroupInfo *groupInfo;
    for (RCDGroupInfo *group in _groups) {
        if ([group.groupId isEqualToString:groupId]) {
            groupInfo=group;
        }
    }
    if (groupInfo) {
        RCDChatViewController *temp = [[RCDChatViewController alloc]init];
        temp.targetId = groupInfo.groupId;
        temp.conversationType = ConversationType_GROUP;
        temp.userName = groupInfo.groupName;
        temp.title = groupInfo.groupName;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
}

-(void) quitGroupCallback:(BOOL) result withGroupId:(NSString *)groupId
{
    if (result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"退出成功！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"加入失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    [RCDDataSource syncGroups];

}
@end
