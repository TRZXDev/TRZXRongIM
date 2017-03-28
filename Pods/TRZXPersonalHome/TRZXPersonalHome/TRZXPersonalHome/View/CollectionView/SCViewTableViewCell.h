//
//  SCViewTableViewCell.h
//  TRZX
//
//  Created by 张江威 on 16/7/8.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIImageView *txImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *zwLabel;
@end
