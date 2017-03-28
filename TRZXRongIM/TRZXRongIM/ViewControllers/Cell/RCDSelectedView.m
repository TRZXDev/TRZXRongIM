//
//  RCDSelectedView.m
//  TRZX
//
//  Created by 移动微 on 16/9/5.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSelectedView.h"
#import "RCDCommonDefine.h"

@implementation RCDSelectedView{
    UIButton *_button;
    
    UIImageView *_iconImage;
    
    UILabel *_textLabel;
    
    UIView *_separatorView;
    
    UILabel *_bubbleTipView;
}

#pragma mark - Action 
///  按钮点击事件
-(void)buttonDidClick:(UIButton *)button{
    if (self.buttonDidClickBlock) {
        self.buttonDidClickBlock(self.type);
    }
}

- (void)setBubbleTipNumber:(int)msgCount{
    if (msgCount > 0) {
        self.badgeNumberLabel.hidden = NO;
        self.badgeNumberLabel.text = [NSString stringWithFormat:@"%d",msgCount];
    }else{
        self.badgeNumberLabel.hidden = YES;
    }
}

-(void)redViewHidden:(BOOL)Bool{
    _redView.hidden = Bool;
}

#pragma mark - 初始化构造方法
+(instancetype)initWithType:(RCDSelectedViewType)type{
    RCDSelectedView *selectedView = [[RCDSelectedView alloc]initWithFrame:CGRectZero];
    selectedView.type = type;
    [selectedView setupUI];
    return selectedView;
}

#pragma mark - 设置界面
-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    //0.创建控件
    _button = [UIButton RC_buttonWithTitle:@"" color:[UIColor whiteColor] imageName:nil target:self action:@selector(buttonDidClick:)];
    _iconImage = [UIImageView RC_imageViewWithImageName:@"展位图"];
    _textLabel = [UILabel RC_labelWithTitle:@"通讯录" color:[UIColor trzx_TitleColor] fontSize:17 aligment:NSTextAlignmentLeft];
    _separatorView = [UIView RC_viewWithColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
    
    //1.添加控件
    [self addSubview:_button];
    [_button addSubview:_iconImage];
    [_button addSubview:_textLabel];
    [self addSubview:_separatorView];
    
    switch (self.type) {
        case RCDSelectedViewTypeAddressBook:{
            [self addConstraint];
            _iconImage.image = [UIImage RC_BundleImgName:@"RCDSelected_AddressBook"];
            _textLabel.text = @"通讯录";
            _button.tag = 0;
        }
            break;
        case RCDSelectedViewTypeFinancingLoop:{
            [self addConstraint];
            _iconImage.image = [UIImage RC_BundleImgName:@"RCDSelected_FinancingLoop"];
            _textLabel.text = @"投融圈";
            self.redView.hidden = YES;
            _button.tag = 1;
        }
            break;
        case RCDSelectedViewTypeSubscribe:{
            [self addConstraint];
            _iconImage.image = [UIImage RC_BundleImgName:@"RCDSelected_Subscription"];
            _textLabel.text = @"订阅刊";
            _button.tag = 2;
            [_separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
            }];
        }
            break;
        case RCDSelectedViewTypeAnnouncement:{
//            [self addConstraintAnnouncement];
            [self addConstraint];
            _iconImage.image = [UIImage RC_BundleImgName:@"TRAnnouncement_icon"];
            _textLabel.text = @"消息";
            self.redView.hidden = YES;
//            _textLabel.textColor = [UIColor trzx_RedColor];
            [_separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
            }];
        }
            break;
        default:
            break;
    }
}

//-(void)addConstraintAnnouncement{
//    _contentLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] fontSize:14 aligment:NSTextAlignmentLeft];
//    _contentLabel.numberOfLines = 1;
//    _timeLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] fontSize:14];
//    
//    [self addSubview:_contentLabel];
//    [self addSubview:_timeLabel];
//    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo([RCIM sharedRCIM].globalConversationPortraitSize);
//        make.centerY.equalTo(self);
//        make.left.mas_equalTo(10);
//    }];
//    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_iconImage).offset(3);
//        make.left.equalTo(_iconImage.mas_right).offset(12);
//        make.right.equalTo(self).offset(-10);
//    }];
//    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_textLabel.mas_bottom).offset(5);
//        make.left.equalTo(_textLabel);
//        make.right.equalTo(_textLabel);
//    }];
//    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self);
//        make.right.equalTo(self);
//        make.bottom.equalTo(self);
//    }];
//    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//        make.left.equalTo(self).offset(10);
//        make.height.mas_equalTo(1);
//        make.trailing.equalTo(self);
//    }];
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.top.equalTo(_iconImage);
//       make.right.equalTo(self).offset(-10);
//    }];
//}

-(void)addConstraint{
    //2.添加约束
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self);
        make.left.mas_equalTo(10);
    }];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImage.mas_right).offset(12);
        make.right.equalTo(self).offset(-10);
    }];
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(1);
        make.trailing.equalTo(self);
    }];
}

-(UILabel *)badgeNumberLabel{
    if (!_badgeNumberLabel) {
        _badgeNumberLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor whiteColor] fontSize:10];
        [self addSubview:_badgeNumberLabel];
        _badgeNumberLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        _badgeNumberLabel.RC_cornerRadius = 8;
        [_badgeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(_iconImage);
            make.centerY.equalTo(_iconImage.mas_top);
            make.centerX.equalTo(_iconImage.mas_right);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return _badgeNumberLabel;
}

-(UIView *)redView{
    if (!_redView) {
        _redView = [UIView RC_viewWithColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
        [self addSubview:_redView];
        _redView.RC_cornerRadius = 5;
        [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.center.equalTo(_iconImage);
            make.centerY.equalTo(_iconImage.mas_top);
            make.centerX.equalTo(_iconImage.mas_right);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _badgeNumberLabel;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _imageView;
}

@end
