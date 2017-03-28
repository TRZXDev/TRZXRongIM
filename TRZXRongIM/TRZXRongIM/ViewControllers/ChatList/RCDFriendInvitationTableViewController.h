//
//  RCDFriendInvitationTableViewController.h
//  RCloudMessage
//
//  Created by litao on 15/7/30.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

/**
 __deprecated_msg("已废弃，请勿使用。");
 */
@interface RCDFriendInvitationTableViewController : UITableViewController /**
 *  targetId
 */
@property(nonatomic, strong) NSString *targetId;
/**
 *  targetName
 */
@property(nonatomic, strong) NSString *userName;
/**
 *  conversationType
 */
@property(nonatomic) RCConversationType conversationType;
/**
 * model
 */
@property (strong,nonatomic) RCConversationModel *conversation;
@end
