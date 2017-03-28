//
//  CeHuaCollectionViewCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/20.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZPersonalModell.h"

@interface CeHuaCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic)TRZPersonalModell *model;


@property (weak, nonatomic) IBOutlet UILabel *midLab;
@property (weak, nonatomic) IBOutlet UIImageView *icmImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hongdian;

@end
