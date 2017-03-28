//
//  OneToOneListCell.h
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRZXPOneToOneListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *zsImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *yuanchengImg;
@property (weak, nonatomic) IBOutlet UILabel *yuanchengLab;
@property (weak, nonatomic) IBOutlet UIImageView *lookImg;

@end
