//
//  PersonalTopView.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/2/25.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalTopView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "TRZXPersonalTopButtonController.h"

//跳转暂时注销
//#import "StudentGuanZhuVC.h"

@implementation PersonalTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius = 6;
    self.iconImage.layer.borderWidth = 0;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.beijiagImage.clipsToBounds = YES;
//    self.iconImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:UserInfoImagePath]];
    
//    self.nameLabel.text = [NSString stringWithContentsOfFile:[KPOUserDefaults name] encoding:NSUTF8StringEncoding error:nil];
//    self.nameLabel.text = [KPOUserDefaults name];
    
}
-(void)setModel:(personalData *)model{
    
    if (_model!=model) {
        _model = model;
        
        _btnView = [[UIView alloc]init];
        [self addSubview:_btnView];
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.equalTo(@(35));
        }];
        self.proxyImage.hidden = YES;
        if ([model.sex isEqualToString:@"男"]) {
            self.xingbieImage.image = [UIImage imageNamed:@"男"];
        }
        if ([model.sex isEqualToString:@"女"]) {
            self.xingbieImage.image = [UIImage imageNamed:@"女"];
        }
        if ([_vipStr isEqualToString:@"1"]) {//0不是，1是
            self.fuhuaImage.image = [UIImage imageNamed:@"huanguan"];
            self.fuhuaImage.hidden = NO;
        }else{
            self.fuhuaImage.hidden = YES;
        }
        if ([_vipStr isEqualToString:@"1"]&&([model.userType isEqualToString:@"ShareProxy"]||[model.userType isEqualToString:@"ExpertProxy"]||[model.userType isEqualToString:@"OrgInvestorProxy"]||[model.userType isEqualToString:@"BrokerageProxy"]||[model.userType isEqualToString:@"Proxy"])) {//0不是，1是
            self.proxyImage.hidden = NO;
            self.fuhuaImage.hidden = NO;
            self.proxyImage.image = [UIImage imageNamed:@"代表"];
            self.fuhuaImage.image = [UIImage imageNamed:@"huanguan"];
        }
        if ([_vipStr isEqualToString:@"0"]&&([model.userType isEqualToString:@"ShareProxy"]||[model.userType isEqualToString:@"ExpertProxy"]||[model.userType isEqualToString:@"OrgInvestorProxy"]||[model.userType isEqualToString:@"BrokerageProxy"]||[model.userType isEqualToString:@"Proxy"])) {//0不是，1是
            self.proxyImage.hidden = YES;
            self.fuhuaImage.hidden = NO;
            self.fuhuaImage.image = [UIImage imageNamed:@"代表"];
        }
        //判断小秘
        if ([model.userType isEqualToString:@"trzxhelp"]) {
            self.proxyImage.hidden = YES;
            self.fuhuaImage.hidden = NO;
            self.fuhuaImage.image = [UIImage imageNamed:@"huanguan"];
            self.xingbieImage.image = [UIImage imageNamed:@"官"];
        }
        
        
        if([model.userType isEqualToString:@"TradingCenter"]||[model.userType isEqualToString:@"Tourist"]||[model.userType isEqualToString:@"User"]||[model.userType isEqualToString:@"Proxy"]){//交易中心、普通、业务代表
            _NewbtnArr = @[@""];
            _NewLabArr = @[@""];
            self.yyImage.hidden = YES;
        }else if ([model.userType isEqualToString:@"Share"]||[_vipStr isEqualToString:@"1"]||[model.userType isEqualToString:@"ShareInvestor"]||[model.userType isEqualToString:@"ShareProxy"]){//股东、会员股东、股东投资人
            _NewbtnArr = @[@"粉丝",@"路演观众"];
            _NewLabArr = @[[NSString stringWithFormat:@"%ld",(long)model.fansCount],[NSString stringWithFormat:@"%ld",(long)model.roadCount]];
            
        }else if ([model.userType isEqualToString:@"Brokerage"]||[model.userType isEqualToString:@"OrgInvestor"]||[model.userType isEqualToString:@"Investor"]||[model.userType isEqualToString:@"Expert"]||[model.userType isEqualToString:@"ExpertProxy"]||[model.userType isEqualToString:@"OrgInvestorProxy"]||[model.userType isEqualToString:@"BrokerageProxy"]){//券商、专家、投资人
            _NewbtnArr = @[@"粉丝",@"课程观众",@"学员咨询"];
            _NewLabArr = @[[NSString stringWithFormat:@"%ld",(long)model.fansCount],[NSString stringWithFormat:@"%ld",(long)model.seeCount],[NSString stringWithFormat:@"%ld",(long)model.meetCount]];
        }
        CGSize sizee;
        sizee.width = (self.frame.size.width-(_NewbtnArr.count-1))/_NewbtnArr.count;
        for (int i = 0; i < _NewbtnArr.count; i ++) {
            _lable = [[UILabel alloc]init];
            //        lab.backgroundColor = [UIColor redColor];
            _lable.textAlignment = NSTextAlignmentCenter;
            _lable.text = _NewLabArr[i];
            _lable.textColor = [UIColor whiteColor];
            _lable.font = [UIFont systemFontOfSize:10];
            _lable.frame = CGRectMake(sizee.width*i+ i*(i-1), 0, sizee.width, 20);
            [self.btnView addSubview:_lable];
            _zsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_zsBtn setTitle:_NewbtnArr[i] forState:UIControlStateNormal];
            
            _zsBtn.titleEdgeInsets = UIEdgeInsetsMake(15,0,0,0);
            _zsBtn.frame = CGRectMake(sizee.width*i+ i*(i-1), 0, sizee.width, 35);
            [_zsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _zsBtn.adjustsImageWhenHighlighted = NO;
            _zsBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            [_zsBtn addTarget:self action:@selector(pushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if([model.userType isEqualToString:@"TradingCenter"]||[model.userType isEqualToString:@"Tourist"]||[model.userType isEqualToString:@"User"]||[model.userType isEqualToString:@"Proxy"]){//交易中心、普通
                _zsBtn.hidden = YES;
            }
            [self.btnView addSubview:_zsBtn];
        }
        for (int i = 0; i < _NewbtnArr.count-1; i ++) {
            UILabel * lable = [[UILabel alloc]init];
            lable.backgroundColor = [UIColor whiteColor];
            lable.frame = CGRectMake(sizee.width*(i+1), 10, 1, 15);
            [self.btnView addSubview:lable];
            
        }
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"展位图1"]];
        self.positionLabel.text = model.company;
        self.zhiweiLabel.text = model.position;
        self.positionLabel.hidden = NO;
        self.zhiweiLabel.hidden = NO;
        if([model.userType isEqualToString:@"TradingCenter"]||[model.userType isEqualToString:@"Tourist"]||[model.userType isEqualToString:@"User"]||[model.userType isEqualToString:@"Proxy"]){//交易中心、普通
            self.positionLabel.hidden = YES;
            self.zhiweiLabel.hidden = YES;
        }
//        self.positionLabel.text = [NSString stringWithFormat:@"%@,%@",model.company,model.position];//公司
        self.addressLabel.text = model.city;//地址
    }
    
}
#pragma mark - 代理方法
// 代理方法
-(void)personalDelegateMethod:(UIViewController *)controller{
    if ([self.delegatee respondsToSelector:@selector(pushPersonalController:)]) {
        [self.delegatee pushPersonalController:controller];
    }
}
//按钮跳转
-(void)pushBtnClick:(UIButton *)sender{
    //跳转暂时注销
    TRZXPersonalTopButtonController * guanzhu = [[TRZXPersonalTopButtonController alloc] init];
    guanzhu.midStrr = _midStrr;
    guanzhu.titleStrr = sender.titleLabel.text;
    [self personalDelegateMethod:guanzhu];
}


@end
