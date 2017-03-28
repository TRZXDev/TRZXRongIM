//
//  BPHeadView.m
//  tourongzhuanjia
//
//  Created by 移动微 on 16/4/20.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "BPHeadView.h"
#import "RCDCommonDefine.h"
#import "RCDBPInfo.h"

static const CGFloat BPButtonWidth = 48;
static const CGFloat BPButtonMargin = 10;

@interface BPHeadView()

@end

@implementation BPHeadView{
    BOOL removeFlag;
    BOOL isUp;
}

#pragma mark - 懒加载



#pragma mark - dealloc
-(void)dealloc{

}

#pragma mark - 初始化方法
//+(instancetype)BPHeadViewInitAnimation:(RCDBPInfo *)BPInfo{
//    return [[self alloc]initWithBPInfo:BPInfo];
//}

//-(instancetype)initWithBPInfo:(RCDBPInfo *)BPInfo{
//
//    self = [[[NSBundle mainBundle]loadNibNamed:@"BPHeadView" owner:nil options:nil]lastObject];
//    
//    self.BPInfo = BPInfo;
//    
//    self.actionButton.tag = BPButtonTypeAction;
//
//    [self.actionButton addTarget:self action:@selector(BPButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    self.headImageView.tag = BPButtonTypeHead;
//    
//    self.headImageView.layer.cornerRadius = 6;
//    self.headImageView.layer.masksToBounds = YES;
//    
//    UIButton *coverButton = [[UIButton alloc]initWithFrame:self.headImageView.bounds];
//
//    [coverButton addTarget:self action:@selector(BPButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    coverButton.tag = BPButtonTypeHead;
//
//    [self.headImageView addSubview:coverButton];
//
//    self.headImageView.userInteractionEnabled = YES;
//    
//    return self;
//}

#pragma mark - 按钮动画方法
-(void)viewAnimation:(UIView *)targetView index:(NSInteger )index offsetX:(CGFloat)offsetX{
    
    CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.x"];
    
    spring.initialVelocity = 0;
    
    spring.delegate = self;
    
    spring.toValue = [NSValue valueWithCGPoint:CGPointMake(offsetX + 24, 0)];
    
    spring.fillMode = kCAFillModeForwards;
    
    spring.duration = spring.settlingDuration;
    
    spring.damping = 7;
    
    spring.mass = 0.5;
    
    spring.stiffness = 40;
    
    spring.beginTime = CACurrentMediaTime() + index * 0.05;
    
    
    if (isUp) {
        
        CGFloat offsetX = index * (BPButtonWidth + BPButtonMargin);
        
        spring.fromValue = [NSValue valueWithCGPoint:CGPointMake(offsetX + targetView.width * 0.5, 0)];
    }else{
        spring.fromValue = [NSValue valueWithCGPoint:CGPointMake(RC_SCREEN_WIDTH, 0)];
    }
    
    [targetView.layer addAnimation:spring forKey:spring.keyPath];
}
#pragma mark - 动画暂停调用
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    
    removeFlag = YES;
    [self.headImageView.layer removeAnimationForKey:@"position.x"];
    [self.actionButton.layer removeAnimationForKey:@"position.x"];

}

#pragma mark - ButtonClick 点击事件
-(void)BPButtonClick:(UIButton *)button{

    if (self.BPButtonClickBlock) {
        self.BPButtonClickBlock(button.tag,self);
    }
}

#pragma mark－ setting 方法
-(void)setBPInfo:(RCDBPInfo *)BPInfo{
    
    _BPInfo = BPInfo;

    self.userInteractionEnabled = YES;
    
    if (BPInfo.type == 0) {
     // 0=投资人申请BP，1=股东投递BP
        
        // 投资人视角
        if ([BPInfo.createById isEqualToString:[Login curLoginUser].userId]) {



            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BPInfo.targetPhoto]] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
            self.titleLabel.text = BPInfo.targetRealName;
//            self.direction = YES;
            self.detailLabel.text = [NSString stringWithFormat:@"%@,%@",BPInfo.targetCompany,BPInfo.targetPosition];
            self.TouBPView.hidden = NO;
            self.direction = HeadViewDirectionInvestor;
            switch (BPInfo.status.intValue) {
                case 0:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"同意查看"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"同意"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
        }else{
    
            // 投资人视角
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BPInfo.logo]] placeholderImage:[UIImage imageNamed:@"展位图"]];
            self.titleLabel.text = BPInfo.projectzName;
            self.detailLabel.text = BPInfo.briefIntroduction;
//            [NSString stringWithFormat:@"%@,%@",BPInfo.targetCompany,BPInfo.targetPosition]
            self.direction = HeadViewDirectionProject;
            switch (BPInfo.status.intValue) {
                case -1:
                    //                        self.BPLabel.text = @"申请";
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"申请"] forState:UIControlStateNormal];
                    break;
                case 0:
                    //                        self.BPLabel.text = @"申请中";
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"申请中"] forState:UIControlStateNormal];
                    break;
                case 1:
                    //                        self.BPLabel.text = @"查看";
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"查看"] forState:UIControlStateNormal];
                    break;
                case 2:
                    //                        self.BPLabel.text = @"申请中";
                    break;
                default:
                    break;
            }
        }
    }
    
    
    if (BPInfo.type == 1) {
        
        //股东 视角
        if ([BPInfo.createById isEqualToString:[Login curLoginUser].userId]) {
            
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BPInfo.targetPhoto]] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
            self.titleLabel.text = BPInfo.targetRealName;
            self.detailLabel.text = [NSString stringWithFormat:@"%@,%@",BPInfo.targetCompany,BPInfo.targetPosition];
            self.TouBPView.hidden = NO;
            self.direction = HeadViewDirectionInvestor;
            switch (BPInfo.status.intValue) {
                case -1:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"投递"] forState:UIControlStateNormal];
                    break;
                case 0:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"已投递"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"已投递"] forState:UIControlStateNormal];
                    break;
                case 2:
                    break;
                default:
                    break;
            }
            
        }else{
        
        
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BPInfo.logo]] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
            self.titleLabel.text = BPInfo.projectzName;
            self.detailLabel.text = [NSString stringWithFormat:@"%@,%@",BPInfo.targetCompany,BPInfo.targetPosition];
            self.direction = HeadViewDirectionProject;
            switch (BPInfo.status.intValue) {
                case -1:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"投递"] forState:UIControlStateNormal];
                    break;
                case 0:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"已投递"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [self.actionButton setImage:[UIImage RC_BundleImgName:@"查看"] forState:UIControlStateNormal];
                    break;
                case 2:
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)PreformAnimation:(BOOL)flag{
    
    __block int offsetNumber;
    switch (self.HeadViewType) {
        case BPHeadViewTypeProject1:{
            offsetNumber = 64;
        }
            break;
        case BPHeadViewTypeProject2:{
            offsetNumber = 128;
        }
            break;
        default:
            break;
    }
    
        if (flag) {
            //出来
            isUp = NO;
//            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//                [UIView animateWithDuration:0.2 animations:^{
//                    obj.y = offsetX;
                    self.frame = CGRectMake(0, offsetNumber, RC_SCREEN_WIDTH, 64);
//                }];
            
//            }];
        }else{
            //消失
            isUp = YES;
//            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//                CGFloat offsetX = self.width +  BPButxtonMargin;
                
                
//                [UIView animateWithDuration:0.2 animations:^{

                    self.frame = CGRectMake(0, 0, RC_SCREEN_WIDTH, 64);
//                }];
//            }];
        }
}

@end
