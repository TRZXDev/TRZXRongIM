//
//  RCDSendSelectedAddressViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/19.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class RCDDscussionHeadManager,OSMessage,RCDUserInfo;
@interface RCDSendSelectedAddressViewController : UITableViewController


@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *allFriends;
@property (nonatomic,strong) NSArray *allKeys;

@property (nonatomic,strong) NSArray *seletedUsers;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) OSMessage *OSMessage;

@property (nonatomic,strong) void (^callBackUserInfo)(NSArray *users);

@property (nonatomic,assign) RCConversationType conversationType;
//
@property (nonatomic,copy)  NSString  *conversationTargetId;

@end
