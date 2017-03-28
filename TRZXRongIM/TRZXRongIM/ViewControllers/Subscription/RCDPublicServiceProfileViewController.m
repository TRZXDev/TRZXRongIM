
//
//  RCDPublicServiceProfileViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicServiceProfileViewController.h"
#import "RCDPublicPodfileHeaderCell.h"
#import "RCDPublicProfileContentCell.h"
#import "RCDSendSelectedViewController.h"
#import "RCDPublicProfileFooterView.h"
#import "RCDPublicServiceChatViewController.h"
#import "RCDSubscriptionViewController.h"
#import "RCDChatViewController.h"
#import "RCDChooseView.h"
#import <UIKit/UIKit.h>
#import "RCDCommonDefine.h"
#import "OpenShare.h"
#import "KPTableViewDataSource.h"

@interface RCDPublicServiceProfileViewController ()

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) RCDPublicProfileFooterView *footerView;

@end

@implementation RCDPublicServiceProfileViewController{
    BOOL oneceBool;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    if(self.profile.publicServiceId.length && !self.publicId.length){
        
        [[RCIMClient sharedRCIMClient] getPublicServiceProfile:self.profile.publicServiceId?:@"" conversationType:ConversationType_PUBLICSERVICE onSuccess:^(RCPublicServiceProfile *serviceProfile) {
            self.profile = serviceProfile;
            self.title = self.profile.name;
            [self tableView];
            if(self.profile.followed){
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"ic_action_overflow_dark" Target:self action:@selector(rightBarButtomItemPressed:)];
            }
        }onError:^(NSError *error) {
            
            self.title = self.profile.name;
            
            [self tableView];
        }];
        
    }else{
        [[RCIMClient sharedRCIMClient] getPublicServiceProfile:self.publicId?self.publicId:@"" conversationType:ConversationType_PUBLICSERVICE onSuccess:^(RCPublicServiceProfile *serviceProfile) {
            self.profile = serviceProfile;
            if(self.profile.followed){
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"ic_action_overflow_dark" Target:self action:@selector(rightBarButtomItemPressed:)];
            }
            self.title = self.profile.name;
            [self tableView];
            
        } onError:^(NSError *error) {
            
            self.title = self.profile.name;
            
            [self tableView];
        }];
    }
}

#pragma mark - Action
-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtomItemPressed:(UIButton *)button{
    NSLog(@"弹出菜单");
    
//    @[@"推荐给朋友",@"投诉",@"清空内容",@"不再订阅"]
    NSArray *array = @[[RCDChooseModel modelWithStr:@"推荐给朋友"],
                       [RCDChooseModel modelWithStr:@"投诉"],
                       [RCDChooseModel modelWithStr:@"清空内容"],
                       [RCDChooseModel modelWithStr:@"不再订阅" textColor:[UIColor trzx_RedColor]]
                       ];
    [RCDChooseView ChooseViewWithArray:array didClickBlock:^(NSUInteger index) {
        switch (index) {
            case 1:{
                // 咨询详情分享
                OSMessage *msg=[[OSMessage alloc]init];
                msg.title= self.profile.name;
                msg.desc= self.profile.introduction;
//                        msg.link= link;
//                        msg.image=testImage;//缩略图
                msg.headURL = self.profile.portraitUrl;
                msg.objId = self.profile.publicServiceId;
                msg.type= @"public"; // 分享类型
                //发送
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
                
                RCDSendSelectedViewController *sendSelectedVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSendSelectedViewController"];
                sendSelectedVC.OSMessage = msg;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendSelectedVC];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 2:{
                UIViewController *complaintsVC = [[CTMediator sharedInstance] TRZXComplaint_TRZXComplaintViewController:@{@"type":@"2",                                                                                                     @"targetId":self.profile.publicServiceId,                                                                                                   @"userTitle":self.profile.name}];
                [self.navigationController pushViewController:complaintsVC animated:YES];
            }
                break;
            case 3:{
                NSArray *array = @[[RCDChooseModel modelWithStr:@"将删除该应用的所有历史消息" textColor:[UIColor trzx_TitleColor] type:ChooseModelTypeLabel],
                                   [RCDChooseModel modelWithStr:@"清空内容" textColor:[UIColor trzx_RedColor]]];
                [RCDChooseView ChooseViewWithArray:array didClickBlock:^(NSUInteger index) {
                    BOOL isClear = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PUBLICSERVICE targetId:self.profile.publicServiceId];
                    if (isClear) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 融云提示
//                            [LCProgressHUD showSuccess:@"清除成功"];
                            if(self.clearHistoryMessage){
                                self.clearHistoryMessage();
                            }
                        });
                    }
                }];
            }
                break;
            case 4:{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSArray *array = @[[RCDChooseModel modelWithStr:[NSString stringWithFormat:@"取消订阅%@后将不再收到其下发的消息",self.profile.name] textColor:[UIColor trzx_TitleColor] type:ChooseModelTypeLabel],
                                       [RCDChooseModel modelWithStr:@"不再订阅" textColor:[UIColor trzx_RedColor]]];
                    [RCDChooseView ChooseViewWithArray:array didClickBlock:^(NSUInteger index) {
                        [[RCIMClient sharedRCIMClient] unsubscribePublicService:self.profile.publicServiceType publicServiceId:self.profile.publicServiceId success:^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIViewController *targetViewController;
                                for (UIViewController *viewController in self.navigationController.childViewControllers) {
                                    if([viewController isKindOfClass:[RCDSubscriptionViewController class]]||
                                       [viewController isKindOfClass:[RCDChatViewController class]]){
                                        targetViewController = viewController;
                                    }
                                }
                                if (targetViewController) {
                                    [self.navigationController popToViewController:targetViewController animated:YES];
                                }else{
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                                //                       [LCProgressHUD showSuccess:@"取消成功"]; //融云提示
                            });
                        } error:^(RCErrorCode status) {
                        }];
                    }];
                });
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - Properites
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor trzx_BackGroundColor];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        [_tableView kipo_makeDataSource:^(KPTableViewDataSourceMaker *make) {
            make.headerView(^(){
                RCDPublicPodfileHeaderCell *headView = [[RCDPublicPodfileHeaderCell alloc] initWithFrame:CGRectMake(0, 0, RC_SCREEN_WIDTH, 130)];
                headView.profile = self.profile;
                return headView;
            });
            
            make.footerView(^(){
                return self.footerView;
            });
            
            [make makeSection:^(KPTableViewSectionMaker *section) {
               section.cell([RCDPublicProfileContentCell class])
                .data(@[self.profile])
                .adapter(^(RCDPublicProfileContentCell *cell ,RCPublicServiceProfile *profile, NSUInteger index){
                    cell.type = ProfileContentCellTypeIntroduction;
                    cell.profile = profile;
                }).autoHeight();
            }];
            [make makeSection:^(KPTableViewSectionMaker *section) {
                section.cell([RCDPublicProfileContentCell class])
                .data(@[self.profile])
                .adapter(^(RCDPublicProfileContentCell *cell ,RCPublicServiceProfile *profile, NSUInteger index){
                    cell.type = ProfileContentCellTypeBody;
                    cell.profile = profile;
                }).autoHeight();
            }];
        }];
    }
    return _tableView;
}

-(RCPublicServiceProfile *)profile{
    if (!_profile) {
        _profile = [[RCPublicServiceProfile alloc] init];
    }
    return _profile;
}

-(void)followedDidClick{
    if (oneceBool) {
        return;
    }
    oneceBool = YES;
    [[RCIMClient sharedRCIMClient] subscribePublicService:self.profile.publicServiceType?self.profile.publicServiceType:RC_PUBLIC_SERVICE publicServiceId:self.profile.publicServiceId success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 融云提示
//            [LCProgressHUD showSuccess:@"订阅成功"];
            oneceBool = NO;
            self.profile.followed = YES;
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"ic_action_overflow_dark" Target:self action:@selector(rightBarButtomItemPressed:)];
            [self.footerView.footerButton setTitle:@"进入订阅刊" forState:UIControlStateNormal];
            //进入订阅刊
            RCDPublicServiceChatViewController *serviceChatVC = [[RCDPublicServiceChatViewController alloc] init];
            serviceChatVC.targetId = self.profile.publicServiceId;
            serviceChatVC.title = self.profile.name;
            serviceChatVC.conversationType = ConversationType_PUBLICSERVICE;
            [self.navigationController pushViewController:serviceChatVC animated:YES];
        });
        
    } error:^(RCErrorCode status) {
        oneceBool = NO;
    }];
}

-(RCDPublicProfileFooterView *)footerView{
    if (!_footerView) {
        __weak __typeof(self) sfself = self;
        _footerView = [[RCDPublicProfileFooterView alloc] initWithFrame:CGRectMake(0, 0, RC_SCREEN_WIDTH, 100)];
        if(self.profile.followed){
            [_footerView.footerButton setTitle:@"进入订阅刊" forState:UIControlStateNormal];
        }else{
            [_footerView.footerButton setTitle:@"订阅" forState:UIControlStateNormal];
        }
        [_footerView setFooterButtonBlock:^{
            if (!sfself.profile.followed) {
                [sfself followedDidClick];
            }else{
                for (UIViewController *viewController in sfself.navigationController.childViewControllers) {
                    if([viewController isKindOfClass:[RCDPublicServiceChatViewController class]]){
                        [sfself.navigationController popToViewController:viewController animated:YES];
                        return ;
                    }
                }
                
                //进入订阅刊
                RCDPublicServiceChatViewController *serviceChatVC = [[RCDPublicServiceChatViewController alloc] init];
                serviceChatVC.targetId = sfself.profile.publicServiceId;
                serviceChatVC.title = sfself.profile.name;
                serviceChatVC.conversationType = ConversationType_PUBLICSERVICE;
                [sfself.navigationController pushViewController:serviceChatVC animated:YES];
                
            }
        }];
    }
    return _footerView;
}

@end
