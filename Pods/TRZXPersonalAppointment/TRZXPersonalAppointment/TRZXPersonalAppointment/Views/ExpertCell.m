//
//  ExpertCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ExpertCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
@implementation ExpertCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(MyExpertModel *)model{

    if (_model!=model) {
        _model = model;

        [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.teacherPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
        _name.text = model.teacherName;
        if ([model.isUpdated isEqual:@"0"]) {
            _zuixinImage.hidden = YES;
        }else{
            _zuixinImage.hidden = NO;
        }
        if ([_vipStr isEqualToString:@"1"]) {
            _money.text = [NSString stringWithFormat:@"  %@元/次  ",model.vipPrice] ;
        }else{
            _money.text = [NSString stringWithFormat:@"  %@元/次  ",model.muchOnce] ;
        }
        _time.text = [NSString stringWithFormat:@"约%@",model.timeOnce];
        _text.text = model.topicTitle;
        if (model.meetStatus == 1 || model.meetStatus == 3 || model.meetStatus == 4) {
            _seeTime.text = @"未确定";
        } else {
//            _seeTime.text = model.meetDate;
            if (model.meetDate.length < 10) {
                
            } else {
            NSMutableString *mStr = [[NSMutableString alloc] initWithString:model.meetDate];
            [mStr deleteCharactersInRange:NSMakeRange(6, 4)];
            _seeTime.text = mStr;
            }
        }
        _meetState.text =  [self getMeetStatus:model.meetStatus];


    }

}



-(NSString*)getMeetStatus:(NSInteger)meetStatus{
    
    switch (meetStatus) {
        case 1:
            return @"待专家确认";
            break;
        case 2:
            return @"已取消";
            break;
        case 12:
            return @"约见未通过";
            break;
        case 10:
            return @"已取消";
            break;

        case 3:
            if ([self.typeSelf isEqualToString:@"studens"]) {
               return @"待学员付款";
            } else if ([self.typeSelf isEqualToString:@"expert"]) {
                return @"待付款";
            }
            break;

        case 4:
            if ([self.typeSelf isEqualToString:@"studens"]) {
                return @"待学员选择约见时间";
            } else if ([self.typeSelf isEqualToString:@"expert"]) {
                return @"已付款";
            }
            
            break;

        case 5:
            if ([self.typeSelf isEqualToString:@"studens"]) {
                return @"已取消,待退款";
            } else if ([self.typeSelf isEqualToString:@"expert"]) {
                return @"已取消,待退款";
            }
            break;

        case 6:
            return @"已取消,已退款";
            break;
        case 7:
            if ([self.typeSelf isEqualToString:@"studens"]) {
                return @"约见成功,待评价";
            } else if ([self.typeSelf isEqualToString:@"expert"]) {
                return @"待评价";
            }
            break;

        case 8:
            return @"学员确认见过";
            break;
        case 9:
            return @"已评价";
            break;
        case 11:
            return @"系统自动评价";
            break;
        case 13:
            return @"待双方见面";
            break;

        default:
            break;
    }



    return @"";
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
