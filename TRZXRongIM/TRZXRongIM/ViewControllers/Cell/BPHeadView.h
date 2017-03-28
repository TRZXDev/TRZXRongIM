//
//  BPHeadView.h
//  tourongzhuanjia
//
//  Created by 移动微 on 16/4/20.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDBPInfo;
typedef NS_ENUM(NSUInteger,BPHeadViewType){
    BPHeadViewTypeProject1 = 33333,
    BPHeadViewTypeProject2 = 44444,
};

typedef NS_ENUM(NSUInteger,BPButtonType){
    BPButtonTypeHead = 11111,
    BPButtonTypeAction = 22222,
};

typedef NS_ENUM(NSUInteger,HeadViewDirection){
    HeadViewDirectionInvestor = 55555,
    HeadViewDirectionProject = 66666,
};

@interface BPHeadView : UIView

//@property(nonatomic,strong)UIButton *actionButton;
//
//@property(nonatomic,strong)UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak)UICollectionView *superCollection;
@property(nonatomic,strong)RCDBPInfo *BPInfo;
@property (weak, nonatomic) IBOutlet UIImageView *TouBPView;

//执行动画
+(instancetype)BPHeadViewInitAnimation:(RCDBPInfo *)BPInfo;

@property(nonatomic,copy)void(^BPButtonClickBlock)(BPButtonType , BPHeadView *headView);

-(void)BPButtonClick:(UIButton *)button;

@property (nonatomic,assign)BPHeadViewType HeadViewType;

@property(nonatomic,assign)HeadViewDirection direction;

/**
 *  执行动画
 *
 *  @param flag 判断位
 */
-(void)PreformAnimation:(BOOL)flag;



@end
