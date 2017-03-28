//
//  RCDSearchResultTableViewCell.h
//  RCloudMessage
//
//  Created by Liv on 15/4/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDUserInfo;
@interface RCDSearchResultTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *ivAva;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UIImageView *officialImage;

@property (nonatomic,strong) RCDUserInfo *user;


@end
