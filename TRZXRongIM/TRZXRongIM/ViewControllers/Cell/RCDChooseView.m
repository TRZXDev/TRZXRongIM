//
//  RCDChooseView.m
//  TRZX
//
//  Created by 移动微 on 16/12/2.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDChooseView.h"
#import "RCDCommonDefine.h"

@interface RCDChooseView()

@property(nonatomic, copy) void(^didClickBlock)(NSUInteger index);

@property(nonatomic, strong)NSArray *chooseViews;

@property(nonatomic, strong)UIButton *cancelButton;

/**
 背景图
 */
@property(nonatomic, strong) UIView *backView;

/**
 底部视图
 */
@property(nonatomic, strong) UIView *bottomView;

@end

@implementation RCDChooseView

+(void)ChooseViewWithArray:(NSArray *)array didClickBlock:(void(^)(NSUInteger index))didClickBlock{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    RCDChooseView *chooseView = [[RCDChooseView alloc] initWithFrame:window.bounds];
    if(array.count){
        chooseView.chooseViews = array;
    }
    chooseView.didClickBlock = didClickBlock;
    
    [UIView animateWithDuration:0.25 animations:^{
        chooseView.backView.alpha = 0.5;
        CGFloat height = array.count * 51 + 5 + 50;
        chooseView.bottomView.transform = CGAffineTransformTranslate(chooseView.bottomView.transform, 0, -height);
    }];
    
    [window addSubview:chooseView];
}

#pragma mark Setting
-(void)setChooseViews:(NSArray *)chooseViews{
    _chooseViews = chooseViews;
    
    for (int i = 0; i < chooseViews.count; i++) {
        RCDChooseModel *model = chooseViews[i];
//        NSString *buttonTitle = chooseViews[i];
        UIView *view;
        if (model.type == ChooseModelTypeButton) {
            view = [UIButton RC_buttonWithTitle:model.text color:model.textColor imageName:nil target:self action:@selector(buttonDidClick:)];
        }else if(model.type == ChooseModelTypeLabel){
            view = [UILabel RC_labelWithTitle:model.text color:model.textColor fontSize:14];
        }
        view.tag = i + 1;
        view.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView).offset(i * 51);
            make.left.equalTo(self.bottomView);
            make.right.equalTo(self.bottomView);
            make.height.offset(50);
        }];
    }
    
    [self cancelButton];
}



#pragma mark - Action
-(void)buttonDidClick:(UIButton *)button{
    if(self.didClickBlock){
        self.didClickBlock(button.tag);
    }
    [self cancelButtonDidClick:nil];
}

-(void)cancelButtonDidClick:(UIButton *)button{
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0;
        self.bottomView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonDidClick:)];
        [self addGestureRecognizer:tap];
        [self backView];
        
    }
    return self;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.chooseViews.count * 51 + 5 + 50);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(self.chooseViews.count * 51 + 5 + 50);
        }];
    }
    return _bottomView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton RC_buttonWithTitle:@"取消" color:[UIColor trzx_TextColor] imageName:nil target:self action:@selector(cancelButtonDidClick:)];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView);
            make.left.equalTo(self.bottomView);
            make.right.equalTo(self.bottomView);
            make.height.offset(50);
        }];
    }
    return _cancelButton;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [UIView RC_viewWithColor:[UIColor blackColor]];
        _backView.alpha = 0.5;
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _backView;
}

@end
