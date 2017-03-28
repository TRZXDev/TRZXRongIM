//
//  YuYueViewController.h
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRZAExpertsDetailModel.h"




/**
 一对一咨询预约
 */
@interface YuYueViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *attentionBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ciLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSString  *problem;//请教问题
@property (strong, nonatomic) NSString  *myIntroduce;//自我介绍
@property (strong, nonatomic) NSString  *teacherId;//专家id
@property (strong, nonatomic) NSString  *topicId;//话题id
@property (strong, nonatomic) NSString  *mentId;//约见id

@property (strong, nonatomic) NSString  *YuYueType;//预约类型
@property (strong, nonatomic) Ostlist  *ostlistModel;//
@property (strong, nonatomic) NSString  *superType;//
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;


@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end
