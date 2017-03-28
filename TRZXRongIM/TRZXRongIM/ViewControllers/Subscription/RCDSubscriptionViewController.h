//
//  RCDSubscriptionViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDSubscriptionViewController : UITableViewController

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *allFriends;
@property (nonatomic,strong) NSArray *allKeys;

@property (nonatomic,strong) NSArray *seletedUsers;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
/**
 *  factory method
 *
 *  @return return a instance
 */
+(instancetype) searchFriendViewController;

@end
