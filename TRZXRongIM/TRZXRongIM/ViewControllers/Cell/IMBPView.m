//
//  BPView.m
//  tourongzhuanjia
//
//  Created by 移动微 on 16/3/31.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "IMBPView.h"
#import "RCDCommonDefine.h"
#import "RCDBPInfo.h"

@interface IMBPView()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *DeliverButton;
@property (weak, nonatomic) IBOutlet UILabel *DeliverLabel;

@end

@implementation IMBPView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headImageView.RC_cornerRadius = 6;
    self.DeliverButton.tag = DeliverButtonTag1;
}

-(void)setBPInfo:(RCDBPInfo *)BPInfo{
    _BPInfo = BPInfo;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:BPInfo.targetPhoto] placeholderImage:[UIImage imageNamed:@"首页头像"]];
    
    switch (BPInfo.type) {
        case 0:{// 0=投资人申请BP，1=股东投递BP
            [_DeliverLabel setText:@"申请"];
            //            self.DeliverButton.titleLabel.text = @"申请";
            self.DeliverButton.tag = DeliverButtonTag2;
            self.titleLabel.text = @"是否向对方申请项目BP？";
        }
            break;
        case 1:{// 0=投资人申请BP，1=股东投递BP
            [_DeliverLabel setText:@"投递"];
            //            self.DeliverButton.titleLabel.text = @"投递";
            self.DeliverButton.tag = DeliverButtonTag3;
            self.titleLabel.text = @"是否向对方投递项目BP？";
        }
            break;
            
        default:
            break;
    }
}

-(void)SharedBP:(UIImage *)photo{
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage RC_BundleImgName:@"首页头像"]];
    self.headImageView.image = photo;
    
    [_DeliverLabel setText:@"投递"];
    //            self.DeliverButton.titleLabel.text = @"投递";
    self.DeliverButton.tag = DeliverButtonTag3;
    self.titleLabel.text = @"是否向对方投递项目BP？";
}

-(void)applyBp:(NSString *)photoUrl{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
    [_DeliverLabel setText:@"申请"];
    //            self.DeliverButton.titleLabel.text = @"申请";
    self.DeliverButton.tag = DeliverButtonTag2;
    self.titleLabel.text = @"是否向对方申请项目BP？";
}

- (IBAction)deliverClick:(id)sender {
    [self removeAnimation:nil];
    if (self.DeliverButtonBlock) {
        self.DeliverButtonBlock(sender);
    }
}

- (IBAction)cancelClick:(id)sender {
    
    
    [self removeAnimation:sender];
}

//移除动画
-(void)removeAnimation:(UIButton *)button{

//    [UIView animateWithDuration:0.2 animations:^{
//        self.y = -94;
//    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    
//    }];
    
    if (self.cancelButtonBlock) {
        self.cancelButtonBlock(button);
    }
}


@end
