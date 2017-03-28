//
//  RCDGroupChatViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/5.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCDDscussionHeadManager,OSMessage;
/**
 群聊
 */
@interface RCDGroupChatViewController : UITableViewController


//@property (nonatomic, strong) NSArray *keys;
//@property (nonatomic, strong) NSMutableDictionary *allFriends;
//@property (nonatomic,strong) NSArray *allKeys;
//
//@property (nonatomic,strong) NSArray *seletedUsers;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;

@property (nonatomic, strong) OSMessage *OSMessage;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
