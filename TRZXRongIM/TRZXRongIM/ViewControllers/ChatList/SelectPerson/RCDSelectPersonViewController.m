//
//  RCDSelectPersonViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/27.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDSelectPersonViewController.h"
#import "RCDSelectPersonTableViewCell.h"
#import "RCDUserInfo.h"
#import "UIBarButtonItem+RCExtension.h"
#import "RCDRCIMDataSource.h"
#import "RCDChatViewController.h"
#import "RCDCommonDefine.h"
#import "UIimageView+WebCache.h"
#import <Masonry/Masonry.h>
#import "UIView+RCExtension.h"
#import "UILabel+RCExtension.h"
#import "UIImageView+RCExtension.h"
#import <TRZXKit/UIColor+APP.h>

@interface RCDSelectPersonViewController()

/**
 *  记录当前选择的人
 */
@property(nonatomic,strong)NSMutableArray *selectedPresons;

@property(nonatomic, strong)UIImageView *notFriendView;

@end

@implementation RCDSelectPersonViewController

-(NSMutableArray *)selectedPresons{
    if (!_selectedPresons) {
        _selectedPresons = [NSMutableArray array];
    }
    return _selectedPresons;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"选择联系人";
    
    //控制多选
    self.tableView.allowsMultipleSelection = YES;
    
//    __weak typeof(&*self) __weakself = self;
    //rightBarButtonItem click event
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickedDone:)];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor grayColor]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    self.tableView.sectionIndexColor = [UIColor trzx_TitleColor];
    
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    if (self.friends.count) {
        self.notFriendView.hidden = YES;
        [self.tableView reloadData];
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor trzx_BackGroundColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexColor = [UIColor clearColor];
        self.notFriendView.hidden = NO;
        self.allKeys = nil;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.tableView reloadSectionIndexTitles];
        [self.tableView reloadData];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setForwardMessage:(RCMessageModel *)forwardMessage{
    _forwardMessage = forwardMessage;
    
    self.navigationItem.title = @"转发至";
}

//clicked done
-(void) clickedDone:(id) sender{
    
    if(!self.friends.count){
        return;
    }
    
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (!indexPaths||indexPaths.count == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择联系人!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIBarButtonItem *rightItem = sender;
    if (!rightItem.enabled) {
        return;
    }
    rightItem.enabled = NO;
    
    if (self.forwardMessage != nil) {
        //转发
        NSMutableArray *seletedUsers = [NSMutableArray new];
        for (NSIndexPath *indexPath in indexPaths) {
            NSString *key = [self.allKeys objectAtIndex:indexPath.section];
            NSArray *arrayForKey = [self.allFriends objectForKey:key];
            RCDUserInfo *user = arrayForKey[indexPath.row];
            //转成RCDUserInfo
            RCDUserInfo *userInfo = [RCDUserInfo new];
            userInfo.userId = user.userId;
            userInfo.name = user.name;
            userInfo.portraitUri = user.portraitUri;
            [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userInfo.userId];
            [seletedUsers addObject:userInfo];
        }
        
        if ([self.forwardMessage.content isKindOfClass:[RCImageMessage class]]) {
            
            [seletedUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //便利转发
                RCDUserInfo *userInfo = obj;
                
                RCImageMessage *imageMessage = (RCImageMessage *)self.forwardMessage.content;
                imageMessage.full = YES;
                [[RCIM sharedRCIM] sendMediaMessage:ConversationType_PRIVATE targetId:userInfo.userId content:imageMessage.originalImage?[RCImageMessage messageWithImage:imageMessage.originalImage]:[RCImageMessage messageWithImage:[UIImage imageWithContentsOfFile:imageMessage.imageUrl]] pushContent:@"您有新的消息" pushData:nil progress:^(int progress, long messageId) {
                } success:^(long messageId) {
                } error:^(RCErrorCode errorCode, long messageId) {
                } cancel:^(long messageId) {
                }];
            }];
        }
        
        if ([self.forwardMessage.content isKindOfClass:[RCTextMessage class]]) {
            [seletedUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //便利转发
                RCDUserInfo *userInfo = obj;
                //                RCMessageContent =
                [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:userInfo.userId content:self.forwardMessage.content pushContent:@"" pushData:nil success:^(long messageId) {
                    
                } error:^(RCErrorCode nErrorCode, long messageId) {
                    
                }];
            }];
        }
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
//        融云提示
//        [LCProgressHUD showSuccess:@"转发成功"];
        
    }else{
        
        //get seleted users
        NSMutableArray *seletedUsers = [NSMutableArray new];
        for (NSIndexPath *indexPath in indexPaths) {
            if (!self.allKeys.count) {
                continue;
            }
            NSString *key = [self.allKeys objectAtIndex:indexPath.section];
            NSArray *arrayForKey = [self.allFriends objectForKey:key];
            RCDUserInfo *user = arrayForKey[indexPath.row];
            //转成RCDUserInfo
            RCDUserInfo *userInfo = [RCDUserInfo new];
            userInfo.userId = user.userId;
            userInfo.name = user.name;
            userInfo.portraitUri = user.portraitUri;
            [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userInfo.userId];
            [seletedUsers addObject:userInfo];
        }
        
        //excute the clickDoneCompletion
        if (self.clickDoneCompletion) {
            self.clickDoneCompletion(self,seletedUsers);
        }
    }
}

//override delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.f;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.allKeys count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *key = [self.allKeys objectAtIndex:section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    if (!arrayForKey.count) {
        return 0;
    }
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.allKeys.count == 0 || self.allFriends.count == 0 ) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc]init];
    NSString *key = [self.allKeys objectAtIndex:section];
    if (self.allKeys.count)label.text = [NSString stringWithFormat:@"  %@",key];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    if (!arrayForKey.count) {
        return 0;
    }
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = [self.allKeys objectAtIndex:section];
    
    NSArray *arr = [self.allFriends objectForKey:key];
    
    return [arr count];
}

//override datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellReuseIdentifier = @"RCDAddressBookSelectedCell";
    RCDSelectPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    [cell setUserInteractionEnabled:YES];
    
    if(!self.allKeys.count){
        return cell;
    }
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    
    RCDUserInfo *user = arrayForKey[indexPath.row];
    if(user){
        cell.lblName.text = user.name;
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
    
    //设置选中状态
    for (RCDUserInfo *userInfo in self.seletedUsers) {
        if ([user.userId isEqualToString:userInfo.userId]) {
//            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [cell setUserInteractionEnabled:NO];
        }
    }
    
    cell.contentView.backgroundColor = [UIColor trzx_BackGroundColor];
    
    return cell;
}


//override delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RCDSelectPersonTableViewCell *cell = (RCDSelectPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    
    [self.selectedPresons addObject:cell];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor trzx_YellowColor]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    RCDSelectPersonTableViewCell *cell = (RCDSelectPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    [self.selectedPresons removeObject:cell];
    if (self.selectedPresons.count == 0) {
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor grayColor]];
    }
}

-(UIImageView *)notFriendView{
    if (!_notFriendView) {
        _notFriendView = [UIImageView RC_imageViewWithImageName:@"RCDAddress_NotFriend"];
        [self.view addSubview:_notFriendView];
        [_notFriendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView);
            make.centerY.equalTo(self.tableView).offset(-120);
            make.size.mas_equalTo(CGSizeMake(RC_SCREEN_WIDTH * 0.6, RC_SCREEN_WIDTH * 0.6 * 0.67));
        }];
        UILabel *titleLabel = [UILabel RC_labelWithTitle:@"您还没有好友" color:[UIColor trzx_LineColor] fontSize:12];
        UILabel *contentLabel = [UILabel RC_labelWithTitle:@"快去 添加好友 中查找吧" color:[UIColor trzx_TextColor] fontSize:12];
        [_notFriendView addSubview:titleLabel];
        [_notFriendView addSubview:contentLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_notFriendView);
            make.top.equalTo(_notFriendView.mas_bottom).offset(20);
        }];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
        }];
    }
    return _notFriendView;
}

@end
