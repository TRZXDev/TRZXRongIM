//
//  EOWalletRecentlyCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

static  NSString *recentlyIdentifier = @"EOWalletRecentlyCell";

@interface EOWalletRecentlyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, copy) NSString *updateDate;


@end
