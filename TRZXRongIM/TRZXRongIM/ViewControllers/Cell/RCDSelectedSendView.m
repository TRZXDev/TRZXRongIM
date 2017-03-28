//
//  RCDSelectedSendView.m
//  TRZX
//
//  Created by 移动微 on 16/11/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSelectedSendView.h"
#import "RCDUserInfo.h"
#import "RCDGroupInfo.h"
#import "RCDBusinessCardMessage.h"
#import "RCDCollectionMessage.h"
#import "RCDPublicMessage.h"
#import "RCDDscussionHeadManager.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"

@interface RCDSelectedSendView ()

@property(nonatomic, strong) UIView *bottomBlackView;

@property(nonatomic, strong) UIView *backView;
/**
 发送给
 */
@property(nonatomic, strong) UILabel *sendItWhoLabel;

@property(nonatomic, strong) UIImageView *headImage;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UIView *separatorView;
/**
 签名
 */
@property(nonatomic, strong) UILabel *signLabel;

@property(nonatomic, strong) UITextField *wordsTextField;

@property(nonatomic, strong) UIButton *cancelButton;

@property(nonatomic, strong) UIButton *sendButton;

@property(nonatomic, strong) RCDDscussionHeadManager *dscussionHeadManager;

@end

@implementation RCDSelectedSendView

+(void)selectedSendView:(RCDUserInfo *)userInfo messageContent:(RCMessageContent *)message sendButtonBlock:(void (^)(RCDUserInfo *userInfo , NSString  *leaveString))sendButtonBlock{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    RCDSelectedSendView *sendView = [[RCDSelectedSendView alloc] initWithFrame:window.bounds];
    sendView.userInfo = userInfo;
    sendView.sendButtonDidBlock = sendButtonBlock;
    
    if ([message isKindOfClass:[RCDBusinessCardMessage class]]) {
        RCDBusinessCardMessage *businessMessage = (RCDBusinessCardMessage *)message;
        sendView.signLabel.text = [NSString stringWithFormat:@"[个人名片]%@",businessMessage.businessName];
    }else if([message isKindOfClass:[RCDCollectionMessage class]]){
        RCDCollectionMessage *collectionMessage = (RCDCollectionMessage *)message;
        sendView.signLabel.text = [NSString stringWithFormat:@"[链接]%@",collectionMessage.collectionTitle];
    }else if ([message isKindOfClass:[RCDPublicMessage class]]){
        RCDPublicMessage *collectionMessage = (RCDPublicMessage *)message;
        sendView.signLabel.text = [NSString stringWithFormat:@"[订阅刊名片]%@",collectionMessage.publicName];
    }
    
    [window addSubview:sendView];
}

+(void)selectedSendViewToGroupInfo:(RCDGroupInfo *)groupInfo messageContent:(RCMessageContent *)message sendButtonBlock:(void (^)(RCDUserInfo *userInfo , NSString  *leaveString))sendButtonBlock{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    RCDSelectedSendView *sendView = [[RCDSelectedSendView alloc] initWithFrame:window.bounds];
    sendView.groupInfo = groupInfo;
    sendView.sendButtonDidBlock = sendButtonBlock;
    if([message isKindOfClass:[RCDCollectionMessage class]]){
        RCDCollectionMessage *collectionMessage = (RCDCollectionMessage *)message;
        sendView.signLabel.text = [NSString stringWithFormat:@"[链接]%@",collectionMessage.collectionTitle];
    }else if ([message isKindOfClass:[RCDPublicMessage class]]){
        RCDPublicMessage *collectionMessage = (RCDPublicMessage *)message;
        sendView.signLabel.text = [NSString stringWithFormat:@"[订阅刊名片]%@",collectionMessage.publicName];
    }else     if ([message isKindOfClass:[RCDBusinessCardMessage class]]) {
        RCDBusinessCardMessage *businessMessage = (RCDBusinessCardMessage *)message;
        sendView.signLabel.text = [NSString stringWithFormat:@"[个人名片]%@",businessMessage.businessName];
    }
    [window addSubview:sendView];
    
}

#pragma mark - Setter
-(void)setUserInfo:(RCDUserInfo *)userInfo{
    _userInfo = userInfo;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]];
    self.nameLabel.text = userInfo.name;
}

-(void)setGroupInfo:(RCDGroupInfo *)groupInfo{
    _groupInfo = groupInfo;
    if (groupInfo.groupHeadData) {
        self.headImage.image = [[UIImage alloc] initWithData:groupInfo.groupHeadData];
    }else{
        [self.dscussionHeadManager kipo_setGroupListHeader:self.headImage groupInfo:groupInfo isSave:NO];
    }
    self.nameLabel.text = groupInfo.groupName;
    
//    self.signLabel.text = [NSString stringWithFormat:@"[链接]%@",groupInfo.introduce?groupInfo.introduce:groupInfo.name];
}

#pragma mark - Action
-(void)sendButtonDidClick:(UIButton *)button{
    //发送
    [self cancelButtonDidClick:nil];
    if (self.sendButtonDidBlock) {
        self.sendButtonDidBlock(self.userInfo,self.wordsTextField.text);
    }
    //发送按钮点击
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDUmengNotification object:nil
     ];
}

- (void)tapPressed:(UITapGestureRecognizer *)tap{
    [self.wordsTextField resignFirstResponder];
}

-(void)cancelButtonDidClick:(UIButton *)button{
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bottomBlackView];
        [self sendButton];
        [self cancelButton];
        //监听键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - Keyboard
-(void)showKeyboard:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    CGRect target = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        _backView.bottom = target.origin.y - 10;
//        self.backView.transform = CGAffineTransformTranslate(self.backView.transform, 0,-(target.origin.y - target.size.height));
    }];
}

-(void)hideKeyboard:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
//        self.backView.transform = CGAffineTransformIdentity;
        _backView.center = self.center;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma properties
-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton RC_buttonWithTitle:@"发送" color:[UIColor trzx_YellowColor] imageName:nil target:self action:@selector(sendButtonDidClick:)];
        _sendButton.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _sendButton.RC_borderWidth = 0.5;
        _sendButton.RC_borderColor = [UIColor trzx_BackGroundColor];
        [self.backView addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wordsTextField.mas_bottom).offset(15);
            make.right.equalTo(self.backView);
            make.left.equalTo(self.backView.mas_centerX);
            make.bottom.equalTo(self.backView);
        }];
    }
    return _sendButton;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton RC_buttonWithTitle:@"取消" color:[UIColor trzx_TitleColor] imageName:nil target:self action:@selector(cancelButtonDidClick:)];
        _cancelButton.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        _cancelButton.RC_borderWidth = 0.5;
        _cancelButton.RC_borderColor = [UIColor trzx_BackGroundColor];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        
        //边线
        UIView *borderView = [UIView RC_viewWithColor:[UIColor trzx_LineColor]];
        [_cancelButton addSubview:borderView];
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_cancelButton);
            make.top.equalTo(_cancelButton).offset(5);
            make.bottom.equalTo(_cancelButton).offset(-5);
            make.width.offset(1);
        }];
        
        [self.backView addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wordsTextField.mas_bottom).offset(15);
            make.left.equalTo(self.backView);
            make.right.equalTo(self.backView.mas_centerX);
            make.bottom.equalTo(self.backView);
        }];
    }
    return _cancelButton;
}
-(UITextField *)wordsTextField{
    if (!_wordsTextField) {
        _wordsTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _wordsTextField.RC_cornerRadius = 6;
        _wordsTextField.backgroundColor = [UIColor whiteColor];
        _wordsTextField.inputView.backgroundColor = [UIColor whiteColor];
        _wordsTextField.RC_borderColor = [UIColor trzx_BackGroundColor];
        _wordsTextField.RC_borderWidth = 1;
        _wordsTextField.placeholder = @"  给朋友留言";
        [self.backView addSubview:_wordsTextField];
        [_wordsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signLabel.mas_bottom).offset(15);
            make.left.equalTo(self.backView).offset(20);
            make.right.equalTo(self.backView).offset(-20);
            make.height.offset(35);
        }];
    }
    return _wordsTextField;
}
-(UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [UILabel RC_labelWithTitle:@"[个人名片]" color:[UIColor trzx_TextColor] fontSize:15 aligment:NSTextAlignmentLeft];
        [self.backView addSubview:_signLabel];
        [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separatorView.mas_bottom).offset(15);
            make.left.equalTo(self.backView).offset(20);
            make.right.equalTo(self.backView).offset(-20);
            make.height.offset(20);
        }];
    }
    return _signLabel;
}
-(UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
        [self.backView addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImage.mas_bottom).mas_equalTo(15);
            make.left.equalTo(self.backView).offset(20);
            make.right.equalTo(self.backView).offset(-20);
            make.height.offset(1);
        }];
    }
    return _separatorView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor blackColor] fontSize:17 aligment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 1;
        [self.backView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImage.mas_centerY);
            make.left.equalTo(self.headImage.mas_right).offset(10);
            make.right.equalTo(self.backView).offset(-10);
        }];
    }
    return _nameLabel;
}

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImage.image = [UIImage RC_BundleImgName:@"展位图"];
        _headImage.RC_cornerRadius = 6;
        [self.backView addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sendItWhoLabel.mas_bottom).offset(20);
            make.left.equalTo(self.backView).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _headImage;
}
-(UILabel *)sendItWhoLabel{
    if (!_sendItWhoLabel) {
        _sendItWhoLabel = [UILabel RC_labelWithTitle:@"发送给:" color:[UIColor blackColor] fontSize:18 aligment:NSTextAlignmentLeft];
        _sendItWhoLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.backView addSubview:_sendItWhoLabel];
        [_sendItWhoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(25);
            make.left.equalTo(self.backView).offset(20);
            make.height.offset(21);
            make.width.offset(80);
        }];
    }
    return _sendItWhoLabel;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [UIView RC_viewWithColor:[UIColor whiteColor]];
        _backView.RC_cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
        [self addSubview:_backView];
        _backView.frame = CGRectMake(0, 0, RC_SCREEN_WIDTH * 0.85, 285);
        _backView.center = self.center;
//        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(RC_SCREEN_WIDTH * 0.85, 285));
//        }];
    }
    return _backView;
}

-(UIView *)bottomBlackView{
    if (!_bottomBlackView) {
        _bottomBlackView = [UIView RC_viewWithColor:[UIColor trzx_TextColor]];
        _bottomBlackView.alpha = 0.5;
        [self addSubview:_bottomBlackView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
        [self addGestureRecognizer:tap];
        [_bottomBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _bottomBlackView;
}

-(RCDDscussionHeadManager *)dscussionHeadManager{
    if (!_dscussionHeadManager) {
        _dscussionHeadManager = [[RCDDscussionHeadManager alloc]init];
    }
    return _dscussionHeadManager;
}
@end
