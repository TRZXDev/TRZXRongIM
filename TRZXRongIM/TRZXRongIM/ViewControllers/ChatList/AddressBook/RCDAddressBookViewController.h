//
//  RCDAddressBookViewController.h
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongCallKit/RongCallKit.h>

@class RCDDscussionHeadManager,OSMessage;
@interface RCDAddressBookViewController : UITableViewController


@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *allFriends;
@property (nonatomic,strong) NSArray *allKeys;

@property (nonatomic,strong) NSArray *seletedUsers;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *friends;
/**
 *  临时 做搜索的 Bool
 */
@property (nonatomic,assign) BOOL hideSectionHeader;


@property (nonatomic,strong) OSMessage *OSMessage;


/**
 选择发送
 */
@property (nonatomic,assign) BOOL selectedPresent;
@property (nonatomic,assign) RCConversationType conversationType;

@property (nonatomic,copy)  NSString  *conversationTargetId;

/**
 *  factory method
 *
 *  @return return a instance
 */
//+(instancetype) searchFriendViewController;

@end
