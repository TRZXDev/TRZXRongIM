//
//  PersonalBottomView.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/12.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalBottomView.h"
#import <FDStackView/FDStackView.h>
#import "Masonry.h"
#import "UIButton+Extension.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface PersonalBottomView ()

@property(nonatomic,strong)UIView *separatorView;

@property(nonatomic,strong)FDStackView *stackView;

@end

@implementation PersonalBottomView

//私聊的事件
#pragma mark - Action
-(void)chat{
    
}


-(void)addFriend{
    NSLog(@"验证发送成功,请求通过");
    [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
    [self.sixinBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
}

//RCDDeleteFriendNotification
-(void)isValidateFriend:(NSNotification *)noti{
    id value = noti.object;
    if ([value isKindOfClass:[NSString class]]) {
        if ([self.model.mid isEqualToString:value]) {
            [self.sixinBtn setTitle:@"加为好友" forState:UIControlStateNormal];
        }
    }
}

#pragma Public Method 
// 关注点击
-(void)guanzhuBtnStatusChange{
    [self.stackView removeArrangedSubview:self.guanzhuBtn];
    [self.guanzhuBtn removeFromSuperview];
    NSString *userId = self.model.userId.length?self.model.userId:self.model.mid;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"footerViewCollectionNotification" object:userId userInfo:nil];
}

#pragma mark - setter
-(void)setModel:(personalData *)model{
    _model = model;
    
    self.hidden = NO;
    //是否关注
    if ((model.followFlag == 1)||
        [model.userType isEqualToString:@"Proxy"]) {
        [self.stackView removeArrangedSubview:self.guanzhuBtn];
        [self.guanzhuBtn removeFromSuperview];
    }
    //判断聊天身份
    //    未成为好友能聊天 : 专家,股东   投资人，股东
    if(([model.currentUser isEqualToString:@"Share"]||[model.currentUser isEqualToString:@"ShareProxy"]) && ([model.userType isEqualToString:@"Expert"]||[model.userType isEqualToString:@"ExpertProxy"])){//股东和专家
        [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
        [self.sixinBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    }else if(([model.currentUser isEqualToString:@"Expert"]||[model.currentUser isEqualToString:@"ExpertProxy"]) && ([model.userType isEqualToString:@"Share"]||[model.userType isEqualToString:@"ShareProxy"])){//专家和股东
        [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
        [self.sixinBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    }else if(([model.currentUser isEqualToString:@"OrgInvestor"]||[model.currentUser isEqualToString:@"OrgInvestorProxy"]) && ([model.userType isEqualToString:@"Share"]||[model.userType isEqualToString:@"ShareProxy"])){//投资人和股东
        [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
        [self.sixinBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    }else if(([model.currentUser isEqualToString:@"Share"]||[model.currentUser isEqualToString:@"ShareProxy"]) && ([model.userType isEqualToString:@"OrgInvestor"]||[model.userType isEqualToString:@"OrgInvestorProxy"])){//投资人和股东
        [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
        [self.sixinBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    }else if([model.currentUser isEqualToString:@"Proxy"] && ([model.userType isEqualToString:@"Proxy"])){//运营商和运营商
        //判断是否是好友
         if ([model.isAlso isEqualToString:@"Complete"]) {
             [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
         }else{
             [self.sixinBtn setTitle:@"加为好友" forState:UIControlStateNormal];
         }
    }else{
        //判断是否是好友
        if ([model.isAlso isEqualToString:@"Complete"]) {
            [self.sixinBtn setTitle:@"私聊" forState:UIControlStateNormal];
        }else{
            [self.sixinBtn setTitle:@"加为好友" forState:UIControlStateNormal];
        }
    }
    
    //是否显示BP
    if (([model.userType isEqualToString:@"ShareProxy"] ||
         [model.userType isEqualToString:@"Share"] ) &&
        ([model.currentUser isEqualToString:@"OrgInvestor"]||[model.currentUser isEqualToString:@"OrgInvestorProxy"]) &&
        model.bpFlag.integerValue == 1) {
        
        switch (model.d4aFlag.intValue) {
            case 1:
                switch (model.bpApply.intValue) {
                    case 0://申请中
                        [self.BPButton setTitle:@"申请中" forState:UIControlStateNormal];
                        break;
                    case 1://同意
                        [self.BPButton setTitle:@"查看" forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                [self removeBPButton];
                break;
            default:
                
                [self.BPButton setTitle:@"申请" forState:UIControlStateNormal];
                break;
        }
        
    }else if (([model.userType isEqualToString:@"OrgInvestor"] || [model.userType isEqualToString:@"OrgInvestorProxy"] ) &&
        ([model.currentUser isEqualToString:@"Share"]||[model.currentUser isEqualToString:@"ShareProxy"]) &&
              model.bpFlag.integerValue == 1) {
        
        switch (model.d4aFlag.intValue) {
            case 1:
                if (model.bpApply.intValue > 0) {
                    [self.BPButton setTitle:@"查看" forState:UIControlStateNormal];
                }
                break;
            case 2:
                [self removeBPButton];
                break;
            default:
                [self.BPButton setTitle:@"投递" forState:UIControlStateNormal];
                break;
        }
        
    }else{
        [self removeBPButton];
    }
    
    [self layoutIfNeeded];
}

-(void)removeBPButton{
    [self.stackView removeArrangedSubview:self.BPButton];
    [self.BPButton removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.sixinBtn = [UIButton kipo_addButton:@"私信2" buttonHighlightedStr:@"私信2" andTitleString:@"私聊" taget:nil action:nil ButtonTag:0];
        self.BPButton = [UIButton kipo_addButton:@"investor_BP" buttonHighlightedStr:@"investor_BP" andTitleString:@"申请" taget:nil action:nil ButtonTag:0];
        self.guanzhuBtn = [UIButton kipo_addButton:@"加好友1" buttonHighlightedStr:@"加好友1" andTitleString:@"关注" taget:nil action:nil ButtonTag:0];
        [self addSubview:self.stackView];
        [self addSubview:self.separatorView];
        self.sixinBtn.adjustsImageWhenHighlighted = NO;
        self.BPButton.adjustsImageWhenHighlighted = NO;
        self.guanzhuBtn.adjustsImageWhenHighlighted = NO;
        [self.stackView addArrangedSubview:self.sixinBtn];
        [self.stackView addArrangedSubview:self.BPButton];
        [self.stackView addArrangedSubview:self.guanzhuBtn];
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separatorView.mas_bottom);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
        }];
        [self.sixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.stackView?self.stackView:@(50));
        }];
        [self.guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.stackView?self.stackView:@(50));
        }];
        [self.BPButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.stackView?self.stackView:@(50));
        }];
    }
    return self;
}




#pragma mark - properties
-(FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc]init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = NSTextAlignmentCenter;
        _stackView.spacing = 0;
    }
    return _stackView;
}

-(UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = backColor;
    }
    return _separatorView;
}

@end
