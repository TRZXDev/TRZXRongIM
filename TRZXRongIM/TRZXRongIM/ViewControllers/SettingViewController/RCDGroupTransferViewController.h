//
//  RCDGroupTransferViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/12.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDGroupInfo;
/**
 群主转让
 */
@interface RCDGroupTransferViewController : UITableViewController


//@property (nonatomic, strong) NSArray *keys;
//@property (nonatomic, strong) NSMutableDictionary *allFriends;
//@property (nonatomic,strong) NSArray *allKeys;
//
//@property (nonatomic,strong) NSArray *seletedUsers;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
 *  临时 做搜索的 Bool
 */
//@property (nonatomic,assign) BOOL hideSectionHeader;

//@property (nonatomic,strong) NSArray *firends;

@property (nonatomic,strong) RCDGroupInfo *groupInfo;

@property (nonatomic, copy) void (^refresh)();

/**
 *  factory method
 *
 *  @return return a instance
 */
+(instancetype) searchFriendViewController;

@end
