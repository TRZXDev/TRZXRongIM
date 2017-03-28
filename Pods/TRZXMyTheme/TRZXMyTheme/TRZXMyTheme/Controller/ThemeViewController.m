//
//  ThemeViewController.m
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ThemeViewController.h"
#import "ChuangJianZhuTiVC.h"
#import "MyThemeViewController.h"
#import "TRZXMyThemePch.h"

@interface ThemeViewController ()<UITextViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic)ChuangJianZhuTiVC *xiugaiZT;
@property (strong, nonatomic) NSString * biaotiStr;
@property (strong, nonatomic) NSString * gongsiStr;
@property (strong, nonatomic) NSString * zhiweiStr;
@property (strong, nonatomic) NSString * nameStr;
@property (strong, nonatomic) NSString * neirongStr;

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ThemeViewController


-(void)loadView{
    self.view = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"ThemeViewController" owner:self options:nil] objectAtIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    　　[self.view addGestureRecognizer:longPressGesture];
//    　　[longPressGesture setMinimumPressDuration:0.3];

    self.title = _titleStr;
    if ([_titleStr isEqualToString:@"主题详情"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];

    }
    self.view.backgroundColor = [UIColor whiteColor];

    if ([_titleStr isEqualToString:@"标准样例"]) {
        _biaotiStr = @"如何进行b轮及以后的融资";
        _gongsiStr = @"投融在线";
        _zhiweiStr = @"总经理";
        _nameStr = @"XXX";
        _neirongStr = @"资本寒冬来临，最受冲击的是b轮开始的成长期融资。因此许多企业面临低价融资的窘境，被迫调整发展步伐，或是从事与格局不符的短期盈利业务。\n但是从另一个角度出发，我们也能够看到资本寒冬往往是建立结构性优势的契机。那么企业应该如何进行调整以应对当前的挑战？在这方面，相信我能够给你一些帮助。\n我专注b/c/d 轮投资并经历了两轮熊市，将从成长期投资者角度给予创业公司建议。\n欢迎约见。";
    }else if ([_titleStr isEqualToString:@"个性样例"]){
        _biaotiStr = @"如何在适合的时间找到适合投资人";
        _gongsiStr = @"投融在线";
        _zhiweiStr = @"总经理";
        _nameStr = @"XXX";
        _neirongStr = @"目前创投行业过热，市场上热钱很多，是创业的黄金时代。风险投资是创投行业的重要环节，但是很多创业者（甚至很多拿过一次投资的创业者）都并不了解投资行业，对投融资节奏没有一个很好的把握和预期，在融资过程中抓不住要领，导致事倍功半，甚至影响企业发展。\n我能够根据我多年的投资经验：\n帮助创业者分析当前是否适合进行融资；\n建议如何找到合适的投资人和调整合理的融资预期；\n规划未来2年融资节奏；\n分析投资人选择和关键条款；\n经典案例分享。\nP.S. 希望带着问题来，这样效率更高一些。";
    }else if ([_titleStr isEqualToString:@"文艺样例"]){
        _biaotiStr = @"创业公司的经营、管理和融资";
        _gongsiStr = @"投融在线";
        _zhiweiStr = @"总经理";
        _nameStr = @"XXX";
        _neirongStr = @"之前做律师六年，后来负责企业法律事务两年，一边观察，一边参与，有颇多感触。最近几年在以下方面积累了一些经验，可以聊一聊：\n企业融资——投资人的挑选，谈判的取舍，融资节奏的把握；\n员工股权激励计划——创业之初建立合理有效的股权分配，可以增强团队的稳定性，激励军心，设置激励方案需要严谨对待，尽量规避风险；\n企业经营、管理及相关法律问题。";
    }else{
        _biaotiStr = _ostlistModel.topicTitle;
        _gongsiStr = _data.company;
        _zhiweiStr = _data.position;
        _nameStr = _data.realName;
        _neirongStr = _ostlistModel.topicContent;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_biaotiStr];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _biaotiStr.length)];

    self.titleLabel.attributedText = attributedString;
    self.positionLabel.text = [NSString stringWithFormat:@"%@,%@",_gongsiStr,_zhiweiStr];
    self.detailedTextView.text = _neirongStr;
    [self.detailedTextView setEditable:YES];
    [self.detailedTextView setDelegate:self];
    self.nameLabel.text = _nameStr;


    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_neirongStr];

    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_neirongStr length])];

    [self.detailedTextView scrollsToTop];
    //    [self.detailedTextView setFont:[UIFont boldSystemFontOfSize:16]];
    [self.detailedTextView setAttributedText:attributedString1];

    self.detailedTextView.font = [UIFont boldSystemFontOfSize:16];
    self.detailedTextView.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];

    //    self.detailedTextView.editable = NO;

    // Do any additional setup after loading the view from its nib.
}


-(UIButton *)rightButton{
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 83, 43)];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:40];
    [_rightButton setTitle:@"..." forState:UIControlStateNormal];
    [_rightButton setTitleColor:zideColor  forState:UIControlStateNormal];
    _rightButton.titleEdgeInsets = UIEdgeInsetsMake(-10,30,11,-15);
    [_rightButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _rightButton;
}


- (void)saveBtnClick:(UIButton *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", @"编辑", nil];
    [actionSheet showInView:self.view];
}

- (void)alertViewStr:(NSString *)str1 with:(NSString *)str2 {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 500;
    [alert show];
}

- (void)alertViewStr {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认发布该主题" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 600;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 500) {
        if (buttonIndex == 0) {
            NSDictionary *params = @{
                                    @"requestType":@"OtoSchoolTopic_Api",
                                    @"apiType":@"deleteTopic",
                                    @"id":_themeID?_themeID:@""};
            
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
                
                if ([object[@"status_code"] isEqualToString:@"200"]) {
                    
                    
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if([vc isKindOfClass:[MyThemeViewController class]]){
                            
                            MyThemeViewController * MyThemeVC = (MyThemeViewController*)vc;
                            [self.delegate pushZhuTiXiangQing];
                            [self.navigationController popToViewController:MyThemeVC animated:YES];
                            return;
                        }
                    }
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:object[@"status_dec"] message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
//                [LCProgressHUD showSuccess:@"删除失败"];
                
            }];
        }
    }
}
//设置sheetButtonAction
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self alertViewStr:@"确认删除" with:@""];
        
    } else if(buttonIndex==1){
        _xiugaiZT = [[ChuangJianZhuTiVC alloc] init];
        _xiugaiZT.wumobanStr = @"1";
        _xiugaiZT.topic = self.topic;
        _xiugaiZT.price = self.pricea;
        _xiugaiZT.duration = self.duration;
        _xiugaiZT.abstracts = self.abstracts;
        _xiugaiZT.yuancheng = self.yuancehng;
        _xiugaiZT.themeID = self.themeID;
        _xiugaiZT.epId = self.epId;
        _xiugaiZT.one = _oneAreaId;
        _xiugaiZT.two = _twoAreaId;
        _xiugaiZT.themeCategory.text = _fenleiStr;
        _xiugaiZT.xiugaiStr = @"修改";
        
        [self.navigationController pushViewController:_xiugaiZT animated:YES];
    }
}
//- (void)handleLongPress:(UILongPressGestureRecognizer *)press{
//
//}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

-(void)setOstlistModel:(OneToOneInfoOstList *)ostlistModel{
    _ostlistModel = ostlistModel;


}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
