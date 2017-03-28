//
//  TRZXProjectScreeningView.m
//  TRZX
//
//  Created by 移动微 on 16/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXProjectScreeningView.h"
#import "TRZXKit.h"
#define FilterbtnH   44
/**
 匿名分类
 */
@interface TRZXProjectScreeningViewButton : UIButton

@property(nonatomic, copy)NSString *mid;
@property (readwrite, nonatomic, strong) NSDictionary *tradeDic; //领域列表
@property (readwrite, nonatomic, strong) NSDictionary *stageDic; // 阶段列表

@end

@implementation TRZXProjectScreeningViewButton


-(void)setTradeDic:(NSDictionary *)tradeDic{
    _tradeDic = tradeDic;
    self.mid = tradeDic[@"mid"];

    [self setTitle:_tradeDic[@"trade"] forState:UIControlStateNormal];

}


-(void)setStageDic:(NSDictionary *)stageDic{
    _stageDic = stageDic;
    self.mid = stageDic[@"mid"];

    [self setTitle:_stageDic[@"name"] forState:UIControlStateNormal];

}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 1;
        [self setTitleColor:[UIColor colorWithRed:135/255.0 green:136/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

@end

@interface TRZXProjectScreeningView ()

@property(nonatomic, strong)UILabel *promptLabel;

@property(nonatomic, strong)NSMutableArray *selectedButtons;

@end

@implementation TRZXProjectScreeningView

+(instancetype)initWithType:(TRZXProjectScreeningViewType)type Frame:(CGRect)frame{
    TRZXProjectScreeningView *screeningView = [[TRZXProjectScreeningView alloc] initWithFrame:frame];
    switch (type) {
        case TRZXProjectScreeningViewTypeInvestorDomain:{
            screeningView.promptLabel.text = @"按投资阶段筛选";
        }
            break;
        case TRZXProjectScreeningViewTypeInvestorStage:{
            screeningView.promptLabel.text = @"按投资领域筛选";
        }
            break;
        case TRZXProjectScreeningViewTypeProjectDomain:{
            screeningView.promptLabel.text = @"按融资阶段筛选";
        }
            break;
        case TRZXProjectScreeningViewTypeProjectStage:{
            screeningView.promptLabel.text = @"按所属领域筛选";
        }
            break;
        default:
            break;
    }
    screeningView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    screeningView.type = type;
    return screeningView;
}

#pragma mark - Action
-(void)buttonDidClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [button.layer setBorderColor:[UIColor redColor].CGColor];
        if (![self.selectedButtons containsObject:button]) {
            [self.selectedButtons addObject:button];
        }
    }else{
        if ([self.selectedButtons containsObject:button]) {
            [self.selectedButtons removeObject:button];
        }
        [button.layer setBorderColor:[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor];
    }
}

/**
 重置
 */
-(void)reset{
    while (self.selectedButtons.count) {
        TRZXProjectScreeningViewButton *button = self.selectedButtons.lastObject;
        button.selected = NO;
        button.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
        [self.selectedButtons removeLastObject];
    }
}

/**
 获取Mid
 
 @return mid数组
 */
-(NSString *)getMid{
    NSString *string;
    for (TRZXProjectScreeningViewButton *button in self.selectedButtons) {
        string = [NSString stringWithFormat:@"%@,%@",string?string:@"",button.mid];
    }
    string = [string hasPrefix:@","]?[string substringFromIndex:1]:@"";
    return string;
}

// 阶段
-(void)setStages:(NSArray *)stages{

    _stages = stages;

    CGFloat originY = self.promptLabel.bottom;
    CGFloat margin = 10;
    CGFloat middleMargin = 20;
    NSUInteger rowNumber = 3;
    NSUInteger dataCount = _stages.count;

    NSInteger FilterbtnW = ((self.width - 60) / 3);

    for (int i = 0; i < dataCount; i++) {
        NSUInteger column = i % rowNumber;
        NSUInteger row = i / rowNumber;
        CGFloat x = column * FilterbtnW + column * middleMargin + margin;
        CGFloat y = row * FilterbtnH + row * margin + margin + originY;
        TRZXProjectScreeningViewButton *button = [[TRZXProjectScreeningViewButton alloc] initWithFrame:CGRectMake(x, y, FilterbtnW, FilterbtnH)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.stageDic = _stages[i];
        [self addSubview:button];
    }

    NSUInteger rowHeightNumber = dataCount / rowNumber + (dataCount % rowNumber? 1 : 0);
    self.height = rowHeightNumber * FilterbtnH + rowHeightNumber * margin + margin + originY;

}

// 领域
-(void)setTrades:(NSArray *)trades{
    _trades = trades;

    // 是否阶段

    CGFloat originY = self.promptLabel.bottom;
    CGFloat margin = 10;
    CGFloat middleMargin = 20;
    NSUInteger rowNumber = 3;
    NSUInteger dataCount = trades.count;
    NSInteger FilterbtnW = ((self.width - 60) / 3);

    for (int i = 0; i < dataCount; i++) {
        NSUInteger column = i % rowNumber;
        NSUInteger row = i / rowNumber;
        CGFloat x = column * FilterbtnW + column * middleMargin + margin;
        CGFloat y = row * FilterbtnH + row * margin + margin + originY;
        TRZXProjectScreeningViewButton *button = [[TRZXProjectScreeningViewButton alloc] initWithFrame:CGRectMake(x, y, FilterbtnW, FilterbtnH)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tradeDic = trades [i];
        [self addSubview:button];
    }

    NSUInteger rowHeightNumber = dataCount / rowNumber + (dataCount % rowNumber? 1 : 0);
    self.height = rowHeightNumber * FilterbtnH + rowHeightNumber * margin + margin + originY;


}



#pragma mark - Properties
-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.text = @"按所属领域筛选" ;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:13];
        _promptLabel.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1];
        _promptLabel.numberOfLines = 0;
        [_promptLabel sizeToFit];
        [self addSubview:_promptLabel];
        _promptLabel.frame = CGRectMake(10, 35, 0, 0);
        [_promptLabel sizeToFit];
    }
    return _promptLabel;
}

-(NSMutableArray *)selectedButtons{
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

@end
