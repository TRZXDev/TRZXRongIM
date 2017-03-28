//
//  RCDAddressBookTableViewCell.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDUserInfo;
@interface RCDAddressBookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgvAva;
@property (copy, nonatomic)NSString *mid;
@property (nonatomic, strong)RCDUserInfo *user;

@property(nonatomic,strong)UILabel *badgeNumberLabel;
@end
