//
//  CeHuaTableViewCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/20.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CeHuaTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UICollectionView *cehuaCollection;

@property (weak, nonatomic) IBOutlet UIButton *gonglueBtn;
@property (nonatomic, strong) UIImageView *hongdianImage;

@end
