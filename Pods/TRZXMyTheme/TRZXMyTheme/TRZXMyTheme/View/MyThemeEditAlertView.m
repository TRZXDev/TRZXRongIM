//
//  MyThemeEditAlertView.m
//  HBVLinkedTextViewExample
//
//  Created by 投融在线 on 16/5/3.
//  Copyright © 2016年 herbivore. All rights reserved.
//

#import "MyThemeEditAlertView.h"

static CGFloat gap = 15;
static CGFloat topGap = 100;


@interface MyThemeEditAlertView ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *lable;

@property (nonatomic,strong)UIView *whiteBgView;



@end
@implementation MyThemeEditAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.lable];
    [self.whiteBgView addSubview:self.textView];
    [self.whiteBgView addSubview:self.canclebutton];
    [self.whiteBgView addSubview:self.saveButton];
}

- (void)show
{
    [self.superview bringSubviewToFront:self];
    [self.textView becomeFirstResponder];
}
- (void)dismiss
{
    [self.superview sendSubviewToBack:self];
    [self endEditing:YES];
}

#pragma mark - setter/getter
- (UIView *)whiteBgView
{
    if (_whiteBgView == nil) {
        _whiteBgView = [[UIView alloc]init];
        _whiteBgView.frame = CGRectMake(gap, topGap, [[UIScreen mainScreen] bounds].size.width-2*gap, ([[UIScreen mainScreen] bounds].size.height-topGap)/2);
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.layer.cornerRadius = 10;
        _whiteBgView.layer.masksToBounds = YES;
        _whiteBgView.userInteractionEnabled = YES;
    }
    return _whiteBgView;
}
- (UILabel *)lable
{
    if (_lable == nil) {
        _lable = [[UILabel alloc]init];
        _lable.frame = CGRectMake(gap,gap, CGRectGetWidth(self.whiteBgView.frame)-2*gap, 30);
        _lable.backgroundColor = [UIColor whiteColor];
        _lable.text = @"话题面向的行业/领域";
        _lable.font = [UIFont systemFontOfSize:15];
        _lable.textColor = [UIColor lightGrayColor];
    }
    return _lable;
}
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(gap,CGRectGetMaxY(self.lable.frame), CGRectGetWidth(self.whiteBgView.frame)-2*gap, CGRectGetHeight(self.whiteBgView.frame)-100);
        _textView.backgroundColor = [UIColor whiteColor];
//        _textView.text = @"话题面向的行业/领域";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor blackColor];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)canclebutton
{
    if (_canclebutton == nil) {
        _canclebutton = [[UIButton alloc]init];
        _canclebutton.frame = CGRectMake(gap,CGRectGetMaxY(self.textView.frame)+gap, (CGRectGetWidth(self.whiteBgView.frame)-2*gap*2)/2, 30);
        _canclebutton.backgroundColor = [UIColor whiteColor];
        [_canclebutton setTitle:@"取消" forState:UIControlStateNormal];
        [_canclebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _canclebutton.layer.cornerRadius = _canclebutton.frame.size.height/2;
        _canclebutton.layer.borderColor = [UIColor grayColor].CGColor;
        _canclebutton.layer.borderWidth = 1;
        _canclebutton.layer.masksToBounds = YES;
    }
    return _canclebutton;
}
- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc]init];
        _saveButton.frame = CGRectMake(CGRectGetMaxX(self.canclebutton.frame)+2*gap,CGRectGetMaxY(self.textView.frame)+gap, (CGRectGetWidth(self.whiteBgView.frame)-2*gap*2)/2, 30);
        _saveButton.backgroundColor = [UIColor redColor];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = _saveButton.frame.size.height/2;
        _saveButton.layer.borderColor = [UIColor grayColor].CGColor;
        _saveButton.layer.borderWidth = 1;
        _saveButton.layer.masksToBounds = YES;
    }
    return _saveButton;
}

- (void)setIndexFirst:(NSInteger)indexFirst
{
    _indexFirst = indexFirst;
    NSArray *arrayOfString = @[@"【主题⾯向的行业/领域】",@"【主题适合的学员】",@"【学员容易遭遇的困扰、⾏业中容易陷入的误区,3~5个要点】",@"【该主题领域拥有的资历或成就】"];

    self.lable.text = arrayOfString[indexFirst];
   
//    self.textView.text = title;
}
- (void)setIndexSecond:(NSInteger)indexSecond
{
    _indexSecond= indexSecond;
    NSArray *arrayOfStrings = @[@"【与主题相关的行业现状/趋势】",@"【主题⾯向哪些学员】",@"【个⼈困扰、 ⾏业中容易陷⼊的误区】",@"【该主题领域拥有的资历或成就】",@"【将主题交谈内容概括为3-5个要点】"];
    self.lable.text = arrayOfStrings[indexSecond];
    
}

- (void)setTitleFirst:(NSString *)titleFirst
{
    _titleFirst = titleFirst;
    NSArray *arrayOfString = @[@"【主题⾯向的行业/领域】",@"【主题适合的学员】",@"【学员容易遭遇的困扰、⾏业中容易陷入的误区,3~5个要点】",@"【该主题领域拥有的资历或成就】"];
    if (![arrayOfString containsObject:titleFirst]) {
        self.textView.text = titleFirst;
    }
    
}

- (void)setTitleSecond:(NSString *)titleSecond
{
    _titleSecond = titleSecond;
   NSArray *arrayOfStrings = @[@"【与主题相关的行业现状/趋势】",@"【主题⾯向哪些学员】",@"【个⼈困扰、 ⾏业中容易陷⼊的误区】",@"【该主题领域拥有的资历或成就】",@"【将主题交谈内容概括为3-5个要点】"];
    if (![arrayOfStrings containsObject:titleSecond]) {
        self.textView.text = titleSecond;
    }
    
}

@end
