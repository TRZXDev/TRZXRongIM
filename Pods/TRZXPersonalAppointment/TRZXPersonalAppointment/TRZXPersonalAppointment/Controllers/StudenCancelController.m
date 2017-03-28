//
//  StudenCancelController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/18.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "StudenCancelController.h"
#import "TRZXPJiDuView.h"

#import "TRZXPersonalAppointmentPch.h"


@interface StudenCancelController ()
@property (strong, nonatomic) UILabel *numberLable;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) UIImageView *icimage;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *moneyLable;
@property (strong, nonatomic)UILabel *timeLable;
@property (strong, nonatomic) UILabel *textLable;
@property (strong, nonatomic) UILabel *quxiaoLable;
@property (strong, nonatomic) UILabel *yuanyingLable;
@property (strong, nonatomic) TRZXPJiDuView *jinduView;
@end

@implementation StudenCancelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已取消";
    self.view.backgroundColor = backColor;
    [self topView];
    [self cellView];
}

- (void)request_Api {

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBackView:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(66);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(WIDTH(self.view)));
        make.height.equalTo(@(15));
    }];
    
    UILabel *numberTitle = [[UILabel alloc] init];
    numberTitle.text = @"编号:";
    numberTitle.textColor = TRZXMainColor;
    numberTitle.font = [UIFont systemFontOfSize:10];
    [topView addSubview:numberTitle];
    [numberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.left.equalTo(topView.mas_left).offset(5);
        make.height.equalTo(@(13));
        make.width.equalTo(@(30));
    }];
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.font = [UIFont systemFontOfSize:10];
    _numberLable.text = @"123321748264678412";
    [topView addSubview:_numberLable];
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.left.equalTo(topView.mas_left).offset(35);
        make.height.equalTo(@(13));
        make.width.equalTo(@(150));
    }];
    
    _dateLable = [[UILabel alloc] init];
    _dateLable.text = @"2012.12.12";
    _dateLable.font = [UIFont systemFontOfSize:10];
    [topView  addSubview:_dateLable];
    
    [_dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.right.equalTo(topView.mas_right).offset(-5);
        make.width.equalTo(@(60));
        make.height.equalTo(@(13));
    }];
    
    
    UILabel *dateTitle = [[UILabel alloc] init];
    dateTitle.text = @"发起时间:";
    dateTitle.textColor = TRZXMainColor;
    dateTitle.font = [UIFont systemFontOfSize:10];
    [topView addSubview:dateTitle];
    
    [dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.right.equalTo(_dateLable.mas_left);
        make.width.equalTo(@(50));
        make.height.equalTo(@(13));
    }];
    
    
        _jinduView = [[TRZXPJiDuView alloc] initWithFrame:CGRectMake(0, 82, WIDTH(self.view), 12)];
        [_jinduView JiDuNow:0 with:5];
        [self.view addSubview:_jinduView];
        NSArray *dataArr = @[@"学员预约",@"专家确认",@"学员付款",@"确认见过",@"学员评价"];
        for (int i = 0; i<5; i++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(WIDTH(self.view)/6)-25, 95, 50, 20)];
            lable.text = dataArr[i];
            lable.font = [UIFont systemFontOfSize:10];
//            if (i == 1) {
//                lable.textColor = TRZXMainColor;
//            } else {
                lable.textColor = heizideColor;
//            }
            
            [self.view addSubview:lable];
        }
    
}

- (void)cellView {
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = moneyColor;
    cellView.layer.cornerRadius = 10;
    cellView.layer.masksToBounds = YES;
    [self.view addSubview:cellView];
    [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(140);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(100));
    }];
    
    _icimage = [[UIImageView alloc] init];
    _icimage.layer.cornerRadius = 6;
    [cellView addSubview:_icimage];
    [_icimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(10);
        make.left.equalTo(cellView.mas_left).offset(10);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.textColor = [UIColor whiteColor];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.text = @"";
    _nameLable.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:_nameLable];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(64);
        make.left.equalTo(cellView.mas_left);
        make.width.equalTo(@(70));
        make.height.equalTo(@(20));
    }];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.textColor = [UIColor whiteColor];
    _timeLable.text = @"约1.5个小时";
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.font = [UIFont systemFontOfSize:13];
    [cellView addSubview:_timeLable];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(20);
        make.right.equalTo(cellView.mas_right).offset(-30);
        make.height.equalTo(@(15));
        make.width.equalTo(@(80));
    }];
    
    _moneyLable = [[UILabel alloc] init];
    _moneyLable.textColor = [UIColor whiteColor];
    _moneyLable.text = @"300元/次";
    _moneyLable.textAlignment = NSTextAlignmentRight;
    _moneyLable.font = [UIFont systemFontOfSize:13];
    [cellView addSubview:_moneyLable];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(20);
        make.right.equalTo(_timeLable.mas_left);
        make.height.equalTo(@(15));
        make.width.equalTo(@(80));
    }];
    
    _textLable = [[UILabel alloc] init];
    _textLable.text = @"我我我我我我我哦我我我哦喔喔喔喔喔我";
    _textLable.textColor = [UIColor whiteColor];
    _textLable.numberOfLines = 0;
    _textLable.font = [UIFont systemFontOfSize:15];
    [cellView addSubview:_textLable];
    
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(40);
        make.left.equalTo(cellView.mas_left).offset(75);
        make.right.equalTo(cellView.mas_right).offset(-30);
        make.height.equalTo(@(50));
    }];
    
    _quxiaoLable = [[UILabel alloc] init];
    _quxiaoLable.text = @"取消原因:";
    _quxiaoLable.textColor = heizideColor;
    _quxiaoLable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_quxiaoLable];
    [_quxiaoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(250);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(@(300));
        make.height.equalTo(@(20));
    }];
    
    _yuanyingLable = [[UILabel alloc] init];
    _yuanyingLable.text = @"简单爱简单爱简单爱简单爱基地";
    _yuanyingLable.textColor = zideColor;
    _yuanyingLable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_yuanyingLable];
    [_yuanyingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(271);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(@(WIDTH(self.view)-10));
        make.height.equalTo(@(20));
    }];


    
}

- (void)createButton {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
