//
//  PersonalJiaoYiTabCell.m
//  TRZX
//
//  Created by 张江威 on 16/8/30.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "PersonalJiaoYiTabCell.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@implementation PersonalJiaoYiTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self.contentView addSubview:self.switcher];
    
    
    
        
    [_switcher forceSelectedIndex:0 animated:YES];
    
//    if ([_HDGGStr isEqualToString:@"1"]) {
//        [_switcher forceSelectedIndex:0 animated:YES];
//        
//    }
}

#pragma mark - properties

-(DVSwitch *)switcher{
    
    if (!_switcher) {
        NSArray *itemArr = @[@"活动",@"公告"];
        _switcher = [[DVSwitch alloc] initWithStringsArray:itemArr];
        _switcher.frame = CGRectMake(SCREEN_WIDTH*0.3/2, 55, SCREEN_WIDTH*0.7, 30);
        
        _switcher.layer.cornerRadius = 15;
        _switcher.layer.masksToBounds = YES;
        
        // 栅格化 - 提高性能
        // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
        _switcher.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _switcher.layer.shouldRasterize = YES;
        _switcher.sliderOffset = 1.0;
        _switcher.font = [UIFont systemFontOfSize:14];
        _switcher.backgroundColor = [UIColor whiteColor];
        _switcher.sliderColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1];
        _switcher.labelTextColorInsideSlider = [UIColor whiteColor];
        _switcher.labelTextColorOutsideSlider = [UIColor lightGrayColor];
        
    }
    return _switcher;
}

-(void)setKipo_cornerRadius:(CGFloat)kipo_cornerRadius{
    self.layer.cornerRadius = kipo_cornerRadius;
    self.layer.masksToBounds = YES;
    
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}
@end
