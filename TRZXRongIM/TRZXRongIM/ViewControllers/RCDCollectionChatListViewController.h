//
//  RCDCollectionChatListViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/16.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

/**
 聚合会话
 */
@interface RCDCollectionChatListViewController : UITableViewController
//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
