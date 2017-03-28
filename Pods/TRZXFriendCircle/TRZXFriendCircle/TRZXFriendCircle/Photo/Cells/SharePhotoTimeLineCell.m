//
//  SharePhotoTimeLineCell.m
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "SharePhotoTimeLineCell.h"
#import "UIImageView+WebCache.h"


#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]

@implementation SharePhotoTimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor  = zideColor;
    self.topLineView.backgroundColor = zideColor;
}
-(void)setModel:(TRZXPhotoTextModel *)model{

    if (_model!=model) {

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


        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.shareImg] placeholderImage:[UIImage imageNamed:@"展位图.png"]];

        self.titleLabel.text = model.describe;

        self.abstractzLabel.text = model.shareTitle;
        self.photoImageView.clipsToBounds  = YES;

     



    }
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
