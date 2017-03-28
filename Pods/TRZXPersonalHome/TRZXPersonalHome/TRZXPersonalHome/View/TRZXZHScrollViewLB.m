//
//  ZHScrollViewLB.m
//  ScrollView——test
//
//  Created by 牛方路 on 15/5/6.
//  Copyright (c) 2015年 蓝鸥. All rights reserved.
//

#import "TRZXZHScrollViewLB.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]


@interface TRZXZHScrollViewLB ()<UIScrollViewDelegate>

@property (nonatomic, strong)UILabel *nextImageV;
@property (nonatomic, strong)UILabel *firstImageV;
@property (nonatomic, strong)UILabel *currentImageV;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL isScroll;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)UIPageControl *pageC;



@end

@implementation TRZXZHScrollViewLB

- (instancetype)initWithFrame:(CGRect)frame WithImageName:(NSArray *)imageNames WithTime:(NSInteger)time
{
    if (self = [super initWithFrame:frame]) {
        self.imageArray = imageNames;
        self.time = time;
        if (self.imageArray.count) {
            [self setTheProfile];
        }
        
    }
    return self;
}


- (void)setTheProfile
{
    self.contentOffset = CGPointMake(0, self.bounds.size.height);
    self.delegate = self;
    self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height * 3);
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    
    if (!self.index) {
        self.currentImageV.text = self.imageArray[self.index] ;
    }
    
//    self.currentImageV.image = [UIImage imageNamed:self.imageArray[0]];
    self.firstImageV.text = [self.imageArray lastObject];
    self.nextImageV.text = [self.imageArray objectAtIndex:self.index+1];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(updateTheScrollView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.pageC.currentPage = 0;
    self.pageC.numberOfPages = self.imageArray.count;
    [self.pageC.layer setCornerRadius:8];
//    [self.pageC addTarget:self action:@selector(changeThePage) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)updateTheScrollView:(NSTimer *)timer
{
    if (self.isScroll) {
        return;
    }
    CGPoint offSet = self.contentOffset;
    offSet.y += offSet.y;
    [self setContentOffset:offSet animated:YES];
    
    if (offSet.y >= self.bounds.size.height * 2) {
        offSet.y = self.bounds.size.height;
    }
    
   
    
}

- (void)changeThePage
{
    
}


- (UILabel *)currentImageV
{
    if (_currentImageV == nil) {
        _currentImageV = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.bounds.size.width, self.bounds.size.height)];
        _currentImageV.font = [UIFont systemFontOfSize:15];
        _currentImageV.textColor = heizideColor;
        [self addSubview:_currentImageV];
    }
    return _currentImageV;
}

- (UILabel *)nextImageV
{
    if (_nextImageV == nil) {
        _nextImageV = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * 2, self.bounds.size.width, self.bounds.size.height)];
        _nextImageV.font = [UIFont systemFontOfSize:15];
        _nextImageV.textColor = heizideColor;
        [self addSubview:_nextImageV];
    }
    return _nextImageV;
}

- (UILabel *)firstImageV
{
    if (_firstImageV == nil) {
        _firstImageV = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, self.bounds.size.width, self.bounds.size.height)];
        _firstImageV.font = [UIFont systemFontOfSize:15];
        _firstImageV.textColor = heizideColor;
        [self addSubview:_firstImageV];
        
    }
    return _firstImageV;
}

- (UIPageControl *)pageC
{
    if (_pageC == nil) {
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width, self.frame.size.height - 30, self.frame.size.width, 30)];
        [self addSubview:_pageC];
        
    }
    return _pageC;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.contentOffset.y < self.bounds.size.height) {
        if (self.index == 0) {
            self.index = self.imageArray.count-1;
        } else {
            self.index--;
        }
    }
    if (self.contentOffset.y > self.bounds.size.height) {
        if (self.index == self.imageArray.count - 1) {
            self.index = 0;
        } else {
            self.index++;
        }
    }
    
    
    self.contentOffset = CGPointMake(0, self.bounds.size.height);
//    self.currentImageV.image = [UIImage imageNamed:self.imageArray[self.index]];
    self.currentImageV.text = self.imageArray[self.index];
    if (self.index == 0) {
        self.firstImageV.text = self.imageArray[self.imageArray.count-1];
    }else {
        self.firstImageV.text = self.imageArray[self.index-1];
    }
    if (self.index == self.imageArray.count - 1) {
        self.nextImageV.text = self.imageArray[0];
    } else {
        self.nextImageV.text = self.imageArray[self.index+1];
    }
    
    self.pageC.currentPage = self.index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.contentOffset.y < self.bounds.size.height) {
        if (self.index == 0) {
            self.index = self.imageArray.count-1;
        } else {
            self.index--;
        }
    }
    if (self.contentOffset.y > self.bounds.size.height) {
        if (self.index == self.imageArray.count - 1) {
            self.index = 0;
        } else {
            self.index++;
        }
    }
    
    _isScroll = NO;
    self.contentOffset = CGPointMake(0, self.bounds.size.height);
    self.currentImageV.text = self.imageArray[self.index];
    if (self.index == 0) {
        self.firstImageV.text = self.imageArray[self.imageArray.count - 1];
    }else {
        self.firstImageV.text = self.imageArray[self.index - 1];
    }
    if (self.index == self.imageArray.count - 1) {
        self.nextImageV.text = self.imageArray[0];
    } else {
        self.nextImageV.text = self.imageArray[self.index + 1];
    }
    self.pageC.currentPage = self.index;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _isScroll = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
