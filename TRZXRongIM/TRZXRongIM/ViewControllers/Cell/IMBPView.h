//
//  BPView.h
//  tourongzhuanjia
//
//  Created by 移动微 on 16/3/31.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCDBPInfo;
#define DeliverButtonTag1 1001 //同意
#define DeliverButtonTag2 1002 //申请
#define DeliverButtonTag3 1003 //投递
@interface IMBPView : UIView

@property(nonatomic,copy)void(^DeliverButtonBlock)(UIButton *button);

@property(nonatomic,copy)void(^cancelButtonBlock)(UIButton *button);

@property(nonatomic,strong)RCDBPInfo *BPInfo;

@property(nonatomic,weak)UIView *coverView;

-(void)SharedBP:(UIImage *)photo;

-(void)applyBp:(NSString *)photoUrl;


@end
