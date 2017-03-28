//
//  MAListStockTableViewCell.m
//  TRZX
//
//  Created by Rhino on 2016/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXMapListCell.h"
#import "TRZXKit.h"
#import "UIImageView+AFNetworking.h"

@implementation TRZXMapListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.layer.cornerRadius = self.headImage.width/2;
    self.headImage.clipsToBounds = YES;
}
-(void)setModel:(TRZXMapAnnotation *)model{


    if (_model!=model) {
        _model = model;
        [self.headImage setImageWithURL:[NSURL URLWithString:model.photo]];
        self.nameLabel.text = model.name;
        self.distanceLabel.text = [NSString stringWithFormat:@"%@ 距离：%@",[model.isOnline isEqualToString:@"Online"]?@"在线":@"离线",model.distanceStr];
        self.positionLabel.text = [NSString stringWithFormat:@"%@  %@",model.company,model.position];
        self.sexImage.image = [model.sex isEqualToString:@"男"]?[UIImage imageNamed:@"map_sex_man"]:[UIImage imageNamed:@"map_sex_woman"];

    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
