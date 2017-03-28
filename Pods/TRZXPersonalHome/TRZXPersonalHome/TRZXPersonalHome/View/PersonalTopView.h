//
//  PersonalTopView.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/2/25.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXPersonalNModel.h"


@protocol PersonalDelegate <NSObject>

-(void)pushPersonalController:(UIViewController *)Controller;

@end

@interface PersonalTopView : UIView

@property (strong, nonatomic) UILabel *lable;
@property (strong, nonatomic) UIButton *zsBtn;
//@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (strong, nonatomic)personalData *model;

@property(nonatomic,weak)id<PersonalDelegate>delegatee;
@property (weak, nonatomic) IBOutlet UIImageView *proxyImage;

@property (weak, nonatomic) IBOutlet UIImageView *beijiagImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xingbieImage;

@property (weak, nonatomic) IBOutlet UIButton *icmBtn;
@property (weak, nonatomic) IBOutlet UIView *tiaozhaunView;
@property (weak, nonatomic) IBOutlet UIImageView *fuhuaImage;
@property (strong, nonatomic) UIView *btnView;
@property (strong, nonatomic) NSString *vipStr;
@property (strong, nonatomic) NSString *midStrr;
@property (weak, nonatomic) IBOutlet UIImageView *yyImage;


@property (strong, nonatomic) NSArray *NewbtnArr;
@property (strong, nonatomic) NSArray *NewLabArr;
@property (strong, nonatomic) NSString *seeCountStr;
@property (strong, nonatomic) NSString *meetCountStr;
@property (strong, nonatomic) NSString *roadCountStr;
@property (strong, nonatomic) NSString *putongStr;
@property (strong, nonatomic) NSString *gudongStr;
@property (strong, nonatomic) NSString *qitaStr;

/**
 *  用于放大的图片
 */
@property(nonatomic,strong)UIImageView *AmplifyImageView;


//-(void)bottomBtnView;

@end
