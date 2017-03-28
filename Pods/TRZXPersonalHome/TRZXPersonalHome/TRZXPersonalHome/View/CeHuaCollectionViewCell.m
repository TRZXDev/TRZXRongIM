//
//  CeHuaCollectionViewCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/20.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "CeHuaCollectionViewCell.h"


/** 主题颜色 */
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]

@implementation CeHuaCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hongdian.layer.cornerRadius = 4;
    self.hongdian.layer.masksToBounds = YES;
    self.hongdian.backgroundColor = TRZXMainColor;
    self.hongdian.hidden = YES;
}
-(void)setModel:(TRZPersonalModell *)model{
    
    if (_model!=model) {
        _model = model;
        
            self.titleLabel.text = model.name;
            self.midLab.text = model.mid;
        if([model.userType isEqualToString:@"trzxhelp"]&&[model.mid isEqualToString:@"y131"]){
            self.titleLabel.text = @"";
            self.midLab.text = @"";
        }
            if ([self.midLab.text isEqualToString:@"y126"]){ //我的约见
                self.icmImage.image = [UIImage imageNamed:@"我的专家"];
            }else if ([self.midLab.text isEqualToString:@"y101"]){ // 录制路演
                self.icmImage.image = [UIImage imageNamed:@"录制路演"];
            }else if ([self.midLab.text isEqualToString:@"y100"]){ //发布项目
                self.icmImage.image = [UIImage imageNamed:@"发布项目"];
            }else if ([self.midLab.text isEqualToString:@"y118"]){// 商业计划书
                self.icmImage.image = [UIImage imageNamed:@"预览商业计划书"];
            }else if ([self.midLab.text isEqualToString:@"y128"]){// 我的问答
                self.icmImage.image = [UIImage imageNamed:@"我的发布"];
            }else if([self.midLab.text isEqualToString:@"y110"]){ // 我要讲课
                self.icmImage.image = [UIImage imageNamed:@"我要讲课"];
            }else if ([self.midLab.text isEqualToString:@"y109"]){ // 我的主题
                self.icmImage.image = [UIImage imageNamed:@"我的主题"];
            }else if ([self.midLab.text isEqualToString:@"y118"]){// 付费课程
                self.icmImage.image = [UIImage imageNamed:@"付费课程"];
            }else if ([self.midLab.text isEqualToString:@"y129"]){// 我的客户
                self.icmImage.image = [UIImage imageNamed:@"我的客户"];
            }else if ([self.midLab.text isEqualToString:@"y130"]){// 我的团队
                self.icmImage.image = [UIImage imageNamed:@"我的团队"];
            }else if ([self.midLab.text isEqualToString:@"y131"]){// 我的业绩
                self.icmImage.image = [UIImage imageNamed:@"我的业绩"];
            }else if ([self.midLab.text isEqualToString:@"y132"]){// 成为运营商
                self.icmImage.image = [UIImage imageNamed:@"成为运营商"];
            }else if ([self.midLab.text isEqualToString:@"y200"]){//我的购买
                self.icmImage.image = [UIImage imageNamed:@"我的购买"];
            }else if ([self.midLab.text isEqualToString:@"y201"]){//我的发布
                self.icmImage.image = [UIImage imageNamed:@"我的问答"];
            }
        }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
