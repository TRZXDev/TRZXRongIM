//
//  MJChiBaoZiFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/12.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "TRZXGifFooter.h"

@interface TRZXGifFooter()
@end

@implementation TRZXGifFooter
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];






    // 隐藏时间
    self.refreshingTitleHidden = YES;
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [self setTitle:@"赶紧上拉吖" forState:state];

            break;
        case MJRefreshStatePulling:
            [self setTitle:@"赶紧放开我吧" forState:state];

            break;
        case MJRefreshStateRefreshing:
            [self setTitle:@"" forState:state];

            break;
        case MJRefreshStateNoMoreData:
            [self setTitle:@"木有数据了" forState:state];

        default:
            break;
    }

}


@end
