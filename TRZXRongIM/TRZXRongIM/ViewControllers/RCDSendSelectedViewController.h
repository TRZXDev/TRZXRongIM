//
//  RCDSendSelectedViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class OSMessage;
/**
 选择发送给 :
 */
@interface RCDSendSelectedViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) OSMessage *OSMessage;

@end
