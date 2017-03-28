//
//  MiMaPopView.m
//  tourongzhuanjia
//
//  Created by 投融在线 on 16/2/24.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "VerifyPasswordPopView.h"
#import "PasswordEnterView.h"
#import "TRZXWalletMacro.h"


#define Verify_SCREEN_HEIGHT  [[UIScreen mainScreen]bounds].size.height
#define Verify_SCREEN_WIDTH  [[UIScreen mainScreen]bounds].size.width

#import <objc/runtime.h>

static CGFloat Gap = 20;
static CGFloat radiu = 8;
static CGFloat Height = 200;
@interface VerifyPasswordPopView ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *whiteBgView;

@property (nonatomic,strong)UILabel *tiShiLable;

@property (nonatomic,strong)UILabel *pasErrorLabel;
@property (nonatomic,strong)PasswordEnterView *enterView;


@property (nonatomic,strong)NSMutableArray *lableArray;

@property (strong, nonatomic)PasswordTextField *textFieldOne;

@property (copy, nonatomic)NSString *passwordStr;


@end
@implementation VerifyPasswordPopView

//背景
- (UIView *)whiteBgView
{
    if (_whiteBgView == nil) {
        _whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(Gap, 0, Verify_SCREEN_WIDTH- 2*Gap, (Height*Verify_SCREEN_HEIGHT)/667)];
        _whiteBgView.center = CGPointMake(Verify_SCREEN_WIDTH/2, (Verify_SCREEN_HEIGHT-(Height*Verify_SCREEN_HEIGHT)/667)/2);
        _whiteBgView.backgroundColor =[UIColor whiteColor];
        _whiteBgView.layer.cornerRadius = radiu;
        _whiteBgView.layer.masksToBounds = YES;
    }
    return _whiteBgView;
}

- (UILabel *)tiShiLable
{
   
    if (_tiShiLable == nil) {
        _tiShiLable = [[UILabel alloc]initWithFrame:CGRectMake(0, Gap, CGRectGetWidth(self.whiteBgView.frame), 30)];
        _tiShiLable.textAlignment = NSTextAlignmentCenter;
        _tiShiLable.font = [UIFont systemFontOfSize:17];
        _tiShiLable.text = @"请输入支付密码";
    }
    return _tiShiLable;
}

- (NSMutableArray *)lableArray
{
    if (_lableArray == nil) {
        _lableArray = [[NSMutableArray alloc]init];
    }
    return _lableArray;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame requestType:(BOOL)is
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addUI];
    }
    return self;
    
}
- (void)addUI
{
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.tiShiLable];
    [self addSubviewS];


    


}
- (void)addSubviewS
{
    CGFloat lableLeftGap = (30*Verify_SCREEN_WIDTH/375);
    CGFloat lableHeight = (50*Verify_SCREEN_HEIGHT/667);

    
    _enterView = [[PasswordEnterView alloc]initWithFrame:CGRectMake(lableLeftGap, (CGRectGetHeight(self.whiteBgView.frame)-lableHeight)/2-1+10, Verify_SCREEN_WIDTH - 2*lableLeftGap-2*Gap, lableHeight) count:6 isCiphertext:YES textField:^(PasswordTextField *textField) {
        [textField becomeFirstResponder];
        _textFieldOne = textField;

    }];
    
    __weak __typeof(self)weakSelf = self;
    _enterView.textDetail = ^(NSString *textDetail){
        if (textDetail.length == 6) {
            _passwordStr =textDetail;

            [weakSelf request_api];

        }
    };
    [self.whiteBgView addSubview:_enterView];


    _pasErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_enterView.frame.origin.x, _enterView.frame.origin.y+_enterView.frame.size.height+5, self.frame.size.width, 20)];
    _pasErrorLabel.text = @"支付密码错误,请重新输入";
    _pasErrorLabel.hidden = YES;
    _pasErrorLabel.font = [UIFont systemFontOfSize:12];
    _pasErrorLabel.textColor = TRZXWalletMainColor;
    [self.whiteBgView addSubview:_pasErrorLabel];



}
- (void)request_api
{

//    [LCProgressHUD showLoading:@"正在加载"];   // 显示等待
    NSString *pwd = [NSString wallet_getMd5_32Bit_String:_passwordStr isUppercase:NO];
    [EOMyWalletViewModel checkCardPassword:pwd success:^(id json) {
            if (json) {

                //支付成功
                if (self.paySuccess) {
                    self.paySuccess();
                }

                self.textFieldOne.text = @"";
                [self.textFieldOne resignFirstResponder];
                [UIView animateWithDuration:0.5f animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self.superview sendSubviewToBack:self];
                    [self removeFromSuperview];
                }];
            }else{
                _pasErrorLabel.hidden = NO;
                [_enterView clearPassword];
            }
    } failure:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.textFieldOne.text = @"";
    [self.textFieldOne resignFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview sendSubviewToBack:self];
        [self removeFromSuperview];
    }];
    
}



#pragma mark - Show & hide

- (void)show:(BOOL)animated {
    
}

- (void)hide:(BOOL)animated {
    
}
@end
