//
//  PhotoTimeLineCell.m
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PhotoTimeLineCell.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]

@implementation PhotoTimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor  = zideColor;
    self.topLineView.backgroundColor = zideColor;
}
-(void)setModel:(TRZXPhotoTextModel *)model{

    if (_model!=model) {



        if(model.pics.count>1){
            self.numberLabel.text = [NSString stringWithFormat:@"共%ld张",(unsigned long)model.pics.count];
        }else{
            self.numberLabel.text = @"";
        }


        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];

        NSDate *curDate = [NSDate date];//获取当前日期
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

        NSDateComponents *dateComponent = [gregorian components:unitFlags fromDate:curDate];

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterRoundHalfDown;



        NSDate  *date2 = [formater dateFromString :model.date];

        NSDateComponents *component = [gregorian components:unitFlags fromDate:date2];
        NSInteger month = [component month];
        NSInteger day = [component day];

        self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];

        NSString *string = [formatter stringFromNumber:[NSNumber numberWithInteger:month]];

        self.monthLabel.text = [NSString stringWithFormat:@"%@月",string];

        self.abstractzLabel.text = model.describe;
        self.photoImageView.clipsToBounds  = YES;

     



    }
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
