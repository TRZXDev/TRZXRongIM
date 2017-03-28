//

//  ZhuTiMoBanViewController.m

//  tourongzhuanjia

//

//  Created by 移动微世界 on 16/4/27.

//  Copyright © 2016年 JWZhang. All rights reserved.

//



#import "ZhuTiMoBanViewController.h"

#import "TiHuanYuanWenView.h"

#import "HBVLinkedTextView.h"

#import "MyThemeEditAlertView.h"

#import "TRZXMyThemePch.h"

#define moban1 @"zhuti1"

#define moban2 @"zhuti2"

#define link1 @"link1"

#define link2 @"link2"

#define mobanIndex @"zhutiIndex"
#import "UIView+SDAutoLayout.h"


@interface ZhuTiMoBanViewController ()<UIScrollViewDelegate>

@property (weak,   nonatomic) UIButton *selectedBtn;
@property (strong, nonatomic) TiHuanYuanWenView * TiHuanYuanWenView;
@property (strong, nonatomic) NSString * fanhuiStr;//替换之后的文本信息
@property (strong, nonatomic) UIScrollView *scrollViewControll;//滚动视图
@property (strong, nonatomic) MyThemeEditAlertView *alertView;//弹出编辑框
@property (strong, nonatomic) UIScrollView *src;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) HBVLinkedTextView *mobanFirst;//模板1
@property (strong, nonatomic) HBVLinkedTextView *mobanSecond;//模板2
@property (strong, nonatomic) NSMutableArray *linkStringFirst;//模板1的文本(能够点击的文本)
@property (strong, nonatomic) NSMutableArray *linkStringSecond;//2
@property (assign, nonatomic) NSInteger index;//模板下标
@property (assign, nonatomic) NSInteger changeIndex;//改变的文本的下标
@property (copy,   nonatomic) NSString *oldStr;
@property (strong,nonatomic)NSUserDefaults *standUser;


@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ZhuTiMoBanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.standUser = [NSUserDefaults standardUserDefaults];
    [self createUI];
    [self customNav];

}
- (void)customNav

{
    self.title = @"主题";
    self.view.backgroundColor = backColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];

}
-(UIButton *)rightButton{
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [_rightButton setTitle:@"替换原文" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _rightButton;
}

- (void)createUI
{
    _TiHuanYuanWenView = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"TiHuanYuanWenView" owner:self options:nil] objectAtIndex:0];
    _TiHuanYuanWenView.backgroundColor = backColor;
    _TiHuanYuanWenView.frame = CGRectMake(0, 64, self.view.frame.size.width, 50);
    [_TiHuanYuanWenView.oneBtn addTarget:self action:@selector(mobanClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TiHuanYuanWenView.twoBtn addTarget:self action:@selector(mobanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self mobanClick:_TiHuanYuanWenView.oneBtn];
    [self.view addSubview:_TiHuanYuanWenView];
    [self.view addSubview:self.scrollViewControll];
    //模板1
    
    NSString *theTextFirst = nil;
    if ([self.standUser objectForKey:moban1]) {
        theTextFirst = [self.standUser objectForKey:moban1];
    }else
    {
        theTextFirst = @"如果你是【主题⾯向的行业/领域】中的【主题适合的学员】,或许在这些方面会感到困扰:【学员容易遭遇的困扰、⾏业中容易陷入的误区】 我在【该主题领域拥有的资历或成就】。相信在这些方面，能为你提供帮助。愿意与你交流的内容包括：【将话题交谈内容概括为3-5个要点】。\nPS.在选择与我见面前，请把你的问题更具体化。毕竟，一小时的谈话只能解决一个小问题。请把你的问题提前发给我，方便我做更精细的准备，提升见面效率。期待与你的见面！";
        
        [self.standUser setObject:theTextFirst forKey:moban1];
        
    }
    
    NSArray *arrayOfString = nil;
    
    if ([self.standUser objectForKey:link1]) {
        
        arrayOfString = [self.standUser objectForKey:link1];
        
    }else
    {
        
        arrayOfString = @[@"【主题⾯向的行业/领域】",@"【主题适合的学员】",@"【学员容易遭遇的困扰、⾏业中容易陷入的误区】",@"【该主题领域拥有的资历或成就】",@"【将话题交谈内容概括为3-5个要点】"];
        
        [self.standUser setObject:arrayOfString forKey:link1];
        
    }
    
    self.mobanFirst.text = theTextFirst;
    
    [self.linkStringFirst addObjectsFromArray:arrayOfString];
    
    [self.mobanFirst linkStrings:self.linkStringFirst
     
               defaultAttributes:[self exampleAttributes]
     
           highlightedAttributes:[self exampleAttributes]
     
                      tapHandler:[self exampleHandlerWithTitle:@"Link an array of strings"]];
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    scroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50);
    
    [self.scrollViewControll addSubview:scroll];
    
    [scroll addSubview:self.mobanFirst];
    
    self.scroll = scroll;
    
    [self.scrollViewControll addSubview:scroll];
    
    
    
    //模板2
    
   NSString *theText = nil;
    if ([self.standUser objectForKey:moban2]) {
        theText = [self.standUser objectForKey:moban2];
    }else
    {
        theText = @"【与主题相关的行业现状/趋势】在这样的情况下,【主题⾯向哪些学员】容易遭遇【个⼈困扰、 ⾏业中容易陷⼊的误区】。我在【该主题领域拥有的资历或成就】。愿意与你分享的内容包括: 【将主题交谈内容概括为3-5个要点】。\nPS.在选择与我见面前，请把你的问题更具体化。毕竟，一小时的谈话只能解决一个小问题。请把你的问题提前发给我，方便我做更精细的准备，提升见面效率。期待与你的见面";
        
        [self.standUser setObject:theText forKey:moban2];
        
    }
    
    NSArray *arrayOfStrings = nil;
    
    if ([self.standUser objectForKey:link2]) {
        
        arrayOfStrings = [self.standUser objectForKey:link2];
        
    }else
    {
        
        arrayOfStrings = @[@"【与主题相关的行业现状/趋势】",@"【主题⾯向哪些学员】",@"【个⼈困扰、 ⾏业中容易陷⼊的误区】",@"【该主题领域拥有的资历或成就】",@"【将主题交谈内容概括为3-5个要点】"];
        
        [self.standUser setObject:arrayOfString forKey:link2];
        
    }
    
    self.mobanSecond.text = theText;

    [self.linkStringSecond addObjectsFromArray:arrayOfStrings];
    
    [self.mobanSecond linkStrings:self.linkStringSecond
     
                defaultAttributes:[self exampleAttributes]
     
            highlightedAttributes:[self exampleAttributes]
     
                       tapHandler:[self exampleHandlerWithTitle:@"Link an array of strings"]];
    
    
    
    UIScrollView *scr = [[UIScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    scr.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50);
    
    scr.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [scr addSubview:self.mobanSecond];
    
    self.src = scr;
    
    [self.scrollViewControll addSubview:scr];
    
    [self.view addSubview:self.alertView];
    
    [self.alertView dismiss];
    
}
//设置连接的文本颜色

- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
              NSForegroundColorAttributeName:TRZXMainColor}mutableCopy];
}

#pragma mark - eventHandle
//点击连接文本事件

- (LinkedStringTapHandler)exampleHandlerWithTitle:(NSString *)title

{
    
    LinkedStringTapHandler exampleHandler = ^(NSString *linkedString,NSInteger index) {
        
        self.oldStr = linkedString;

        
        if (self.index == 0) {
            
            self.changeIndex = [self.linkStringFirst indexOfObject:linkedString];
            
            self.alertView.indexFirst = self.changeIndex;
            
            self.alertView.titleFirst = linkedString;
            
        }else
            
        {
            
            self.changeIndex = [self.linkStringSecond indexOfObject:linkedString];
            
            self.alertView.indexSecond = self.changeIndex;
            
            self.alertView.titleSecond = linkedString;
            
        }
        
        [self.alertView show];
        
    };
    
    return exampleHandler;
    
}

#pragma mark- 替换按钮点击 返回上个控制器

//替换事件

- (void)saveBtnClick:(UIButton *)sender{
    if (self.index == 0) {
        [self.delegate pushZhuTiBack:self.mobanFirst.text];
    }else
    {
        [self.delegate pushZhuTiBack:self.mobanSecond.text];
    }
    [[self navigationController] popViewControllerAnimated:YES];
    
}
#pragma mark - 模板点击事件

- (void)mobanClick:(UIButton *)sender{
    
    NSInteger index = sender.tag - 344;
    self.selectedBtn.selected = NO;
    self.selectedBtn.backgroundColor = backColor;
    
    sender.selected = YES;
    
    sender.backgroundColor = TRZXMainColor;
    
    sender.tintColor = [UIColor whiteColor];
    
    self.selectedBtn = sender;
    
    if (index == 0) {
        
        self.index = 0;
        
        [self.scrollViewControll setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else {
        
        self.index = 1;
        
        [self.scrollViewControll setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        
    }
    
}

//返回

- (void)goBackView:(UIButton *)sender{
//    [self.delegate pushZhuTiBack:_fanhuiStr];
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}
#pragma makr - 弹框点击事件
- (void)savebuttonClick
{

    NSString *str = self.alertView.textView.text;

    if (str.length >0 && self.changeIndex != NSNotFound) {
        if (self.index == 0) {
            
            [self.linkStringFirst replaceObjectAtIndex:self.changeIndex withObject:str];
            
            NSMutableString *string =  [[NSMutableString alloc]initWithString:self.mobanFirst.text];
            

            NSRange range = [self.mobanFirst.text rangeOfString:self.oldStr];
            

            [string replaceCharactersInRange:range withString:str];
            
            
            
            [self.mobanFirst removeFromSuperview];
            
            self.mobanFirst = nil;
            
            
            
            self.mobanFirst.text = string;
            

            
            
            [self.mobanFirst linkStrings:self.linkStringFirst
             
                       defaultAttributes:[self exampleAttributes]
             
                   highlightedAttributes:[self exampleAttributes]
             
                              tapHandler:[self exampleHandlerWithTitle:@"Link an array of strings"]];
            
            [self.scroll addSubview:self.mobanFirst];
            
            
            
            CGSize size =   [self contentSizeWithString:self.mobanFirst.text];
            
            
            
            if (size.height >SCREEN_HEIGHT - 50 - 64) {
                
                self.mobanFirst.frame = CGRectMake(self.mobanFirst.origin.x, self.mobanFirst.origin.y, self.mobanFirst.size.width, size.height);
                
                self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, size.height + 80);
                
            }
            
            
            
        }else
            
        {
            
            [self.linkStringSecond replaceObjectAtIndex:self.changeIndex withObject:str];
            
            NSMutableString *string =  [[NSMutableString alloc]initWithString:self.mobanSecond.text];
            
            NSRange range = [self.mobanSecond.text rangeOfString:self.oldStr];
            
            [string replaceCharactersInRange:range withString:str];
            
            
            
            [self.mobanSecond removeFromSuperview];
            
            self.mobanSecond = nil;
            
            self.mobanSecond.text = string;
            
            [self.mobanSecond linkStrings:self.linkStringSecond
             
                        defaultAttributes:[self exampleAttributes]
             
                    highlightedAttributes:[self exampleAttributes]
             
                               tapHandler:[self exampleHandlerWithTitle:@"Link an array of strings"]];
            
            [self.src addSubview:self.mobanSecond];
            
            CGSize size =   [self contentSizeWithString:self.mobanSecond.text];
            
            
            
            if (size.height >SCREEN_HEIGHT - 50 - 64) {
                
                self.mobanSecond.frame = CGRectMake(self.mobanSecond.origin.x, self.mobanSecond.origin.y, self.mobanSecond.width, size.height);
                
                self.src.contentSize = CGSizeMake(SCREEN_WIDTH, size.height + 40);
                
            }
            
        }
        
        
        
    }
    
    [self.alertView dismiss];
    
    self.alertView.textView.text =@"";
    
    
    
    //保存信息
    
    //选中的是第几个模板
    
    [self.standUser setObject:[NSString stringWithFormat:@"%ld",(long)self.index] forKey:mobanIndex];
    
    
    
    [self.standUser setObject:self.mobanFirst.text forKey:moban1];
    
    
    
    [self.standUser setObject:self.mobanSecond.text forKey:moban2];
    
    
    
    [self.standUser setObject:self.linkStringFirst forKey:link1];
    
    
    
    [self.standUser setObject:self.linkStringSecond forKey:link2];
    
    
    
}

//取消

- (void)canclebuttonClick

{

    
    [self.alertView dismiss];
    
    self.alertView.textView.text =@"";
    
}



#pragma mark - 计算高度

- (CGSize)contentSizeWithString:(NSString *)string
{
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};
    CGSize contentSize = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH- 2*20, MAXFLOAT)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil].size;
    return contentSize;
}

#pragma mark - setter/getter
//滚动视图 承载两个view
- (UIScrollView *)scrollViewControll
{
    if (!_scrollViewControll) {
        _scrollViewControll = [[UIScrollView alloc]init];
        _scrollViewControll.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _scrollViewControll.frame = CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT - 64-50);
        _scrollViewControll.showsHorizontalScrollIndicator = NO;
        _scrollViewControll.showsVerticalScrollIndicator = NO;
        _scrollViewControll.delegate = self;
        _scrollViewControll.scrollEnabled = NO;
        _scrollViewControll.contentSize = CGSizeMake(SCREEN_WIDTH *2, _scrollViewControll.frame.size.height*2);
    }
    return _scrollViewControll;
}
- (HBVLinkedTextView *)mobanFirst
{
    if (!_mobanFirst) {
     _mobanFirst = [[HBVLinkedTextView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-2*20, CGRectGetHeight(self.scrollViewControll.frame)*2)];
        _mobanFirst.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _mobanFirst;
    
}



- (HBVLinkedTextView *)mobanSecond

{
    
    if (!_mobanSecond) {
        
        _mobanSecond = [[HBVLinkedTextView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-2*20, CGRectGetHeight(self.scrollViewControll.frame)*2)];
        
        _mobanSecond.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }
    
    return _mobanSecond;
    
}

- (MyThemeEditAlertView *)alertView

{
    
    if (!_alertView) {
        
        _alertView = [[MyThemeEditAlertView alloc]initWithFrame:self.view.bounds];
        
        [_alertView.canclebutton addTarget:self action:@selector(canclebuttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_alertView.saveButton addTarget:self action:@selector(savebuttonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _alertView;
    
}
- (NSMutableArray *)linkStringFirst
{
    if (!_linkStringFirst) {
        _linkStringFirst = [[NSMutableArray alloc]init];
    }
    return _linkStringFirst;
}
- (NSMutableArray *)linkStringSecond
{
    if (!_linkStringSecond) {
        _linkStringSecond = [[NSMutableArray alloc]init];
    }
    return _linkStringSecond;
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated
}

@end

