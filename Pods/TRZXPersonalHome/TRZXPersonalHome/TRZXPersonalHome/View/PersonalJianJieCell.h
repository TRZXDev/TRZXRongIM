//
//  PersonalJianJieCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/11.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRZXPersonalNModel.h"
#import "PersonalCollectionView.h"
#import "PersonalZBCollectionView.h"
#import "LatestLiveModel.h"


@protocol gengduoDelegate <NSObject>

-(void)pushPersonalController:(UIViewController *)Controller;
-(void)pushVideoPersonalController:(UIViewController *)Controller;

@end


@interface PersonalJianJieCell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labLin;
@property (weak, nonatomic) IBOutlet UILabel *linLab;
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIButton *gengduoBtn;
@property (weak, nonatomic) IBOutlet UILabel *chengguoLabel;
@property (weak, nonatomic) IBOutlet UILabel *chengguo2Lab;

@property (strong, nonatomic) NSString * oneLabStr;
@property (strong, nonatomic) NSString * twoLabStr;
@property (strong, nonatomic) NSArray * zhiboViewArr;

@property (strong, nonatomic) NSString * zhiboStr;


@property (strong, nonatomic) NSString * ViedoStr;


@property (strong, nonatomic) NSString * chengguoStr;
@property (strong, nonatomic) PersonalCollectionView * PersonalCollectionView;

@property (strong, nonatomic) TRZXPersonalNModel * personalMode;

@property (strong, nonatomic) PersonalZBCollectionView * PersonalZBCollectionView;

@property(nonatomic,weak)id<gengduoDelegate>moreDelegate;

-(void)jiazaichegguoView;
-(void)jiazaizhiboView;
@end
