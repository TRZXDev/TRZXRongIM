//
//  WoWenTableViewCell.h
//  TRZX
//
//  Created by 张江威 on 16/7/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoWenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icmImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLabel;
@property (weak, nonatomic) IBOutlet UILabel *xianLabel;
//@property (weak, nonatomic) IBOutlet UIButton *huidaBtn;
@property (weak, nonatomic) IBOutlet UILabel *wentiBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
