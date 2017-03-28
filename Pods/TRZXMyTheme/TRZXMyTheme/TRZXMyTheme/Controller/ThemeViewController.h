//
//  ThemeViewController.h
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OneToOneDetailModel.h"

/**
 *  主题详情
 */
@protocol zhutixqDelegate <NSObject>
- (void)pushZhuTiXiangQing;
@end

@interface ThemeViewController : UIViewController

@property (nonatomic, weak) id<zhutixqDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailedTextView;

@property(nonatomic,strong)OneToOneInfoData1 *data;
@property (strong, nonatomic)  OneToOneInfoOstList *ostlistModel;

@property (strong, nonatomic) NSString * titleStr;

@property (copy, nonatomic)NSString *themeID;
@property (copy, nonatomic)NSString *epId;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *abstracts;
@property (nonatomic, copy) NSString *pricea;
@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *yuancehng;
@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, copy) NSString *oneAreaId;
@property (nonatomic, copy) NSString *twoAreaId;
@property (nonatomic,copy) NSString  *yuanYinStr;
@property (nonatomic, copy) NSString *themeType;

@property (nonatomic, copy) NSString * fenleiStr;

@end
