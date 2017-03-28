//
//  PersonalJianJieCell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/11.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalJianJieCell.h"
#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>


//先注释了
//#import "LiveListPlayViewController.h"
//#import "ConsultingDetailsViewController.h"
//#import "LuYanProjectInfoViewController.h"
//#import "CourseDetailsViewController.h"


#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define kBlackColor         [UIColor blackColor]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]


@implementation PersonalJianJieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}
-(void)jiazaichegguoView{
    if (!(_personalMode.data.achievements.count ==0)) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 140)];
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.delegate = self;
        _topScrollView.contentSize = CGSizeMake(130 *_personalMode.data.achievements.count + 10*(_personalMode.data.achievements.count + 1), 140);
        self.topScrollView.directionalLockEnabled = YES;
        //滚动条
        self.topScrollView.showsVerticalScrollIndicator = NO;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_topScrollView];
        for (int i = 0; i < _personalMode.data.achievements.count; i ++) {
            _PersonalCollectionView = [[[NSBundle mainBundle]loadNibNamed:@"PersonalCollectionView" owner:self options:nil] objectAtIndex:0];
            _PersonalCollectionView.logoImage.layer.cornerRadius = 6;
            _PersonalCollectionView.logoImage.layer.masksToBounds = YES;
            Achievements *mode = [_personalMode.data.achievements objectAtIndex:i];

            [self.gengduoBtn setTitle:@"更多成果" forState:UIControlStateNormal];
            
            if (_personalMode.data.achievements.count == 0) {
                self.labLin.hidden = YES;
                self.topScrollView.hidden = YES;
                //先注释了
//                [self.topScrollView removeAllSubviews];
            }
            
            if ([mode.dataModelType isEqualToString:@"videoz"]) {
                _PersonalCollectionView.bofangImage.image = [UIImage imageNamed:@"播放1.png"];
                _oneLabStr = @"[在线视频]";
                
                _twoLabStr = mode.topicTitle;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.expertPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"FinanceCoursez"]){
                _PersonalCollectionView.bofangImage.image = [UIImage imageNamed:@"播放1.png"];
                _oneLabStr = @"[在线课程]";//
                _ViedoStr = @"1";
                _twoLabStr = mode.name;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.userPic] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"OtoSchoolTopic"]){
                _oneLabStr = @"[一对一咨询]";//
                _twoLabStr = mode.picTitle;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.expertPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"OnLineSchool"]){
                _PersonalCollectionView.bofangImage.image = [UIImage imageNamed:@"播放1.png"];
                _oneLabStr = @"[在线学院]";
                _twoLabStr = mode.name;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.expertPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"RoadShow"]){
                _oneLabStr = @"[路演]";
                _twoLabStr = mode.name;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.carouselImg] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"AttractRoadShow"]){
                _oneLabStr = @"[招商路演]";
                _twoLabStr = mode.name;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.expertPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"Projectz"]){
                _oneLabStr = @"[项目]";
                _twoLabStr = mode.name;
                _PersonalCollectionView.topImage.image = [UIImage imageNamed:@"展位loge"];
                [_PersonalCollectionView.logoImage sd_setImageWithURL:[NSURL URLWithString:mode.logo] placeholderImage:[UIImage imageNamed:@"展位图"]];
                
            }else if ([mode.dataModelType isEqualToString:@"TradingCenter"]){
                _PersonalCollectionView.bofangImage.image = [UIImage imageNamed:@"播放1.png"];
                _oneLabStr = @"[在线学院]";
                _twoLabStr = mode.name;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.videoImg] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }else if ([mode.dataModelType isEqualToString:@"GovRoadShow"]||[mode.dataModelType isEqualToString:@"TradingCenter"]){
                //               @"[地方政府说]";
                _PersonalCollectionView.bofangImage.image = [UIImage imageNamed:@"播放1.png"];
                _oneLabStr = @"[在线学院]";
                _twoLabStr = mode.name;
                [_PersonalCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:mode.videoImg] placeholderImage:[UIImage imageNamed:@"展位图"]];
            }
            
            
            _PersonalCollectionView.frame = CGRectMake(i*130 + 10 *(i + 1), 0, 130, 140);
            _PersonalCollectionView.tag = 1000+i;
            NSString * str = [NSString stringWithFormat:@"%@ %@",_oneLabStr,_twoLabStr];
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
            //获取要调整颜色的文字位置,调整颜色
            NSRange range1=[[hintString string]rangeOfString:_oneLabStr==nil?@"":_oneLabStr];
            [hintString addAttribute:NSForegroundColorAttributeName value:moneyColor range:range1];
            
            NSRange range2=[[hintString string]rangeOfString: _twoLabStr==nil?@"":_twoLabStr];
            [hintString addAttribute:NSForegroundColorAttributeName value:heizideColor range:range2];
            
            _PersonalCollectionView.nameLable.attributedText=hintString;
            UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoxhClick:)];
            [_PersonalCollectionView addGestureRecognizer:singleTap];
            [self.topScrollView addSubview:_PersonalCollectionView];
            self.topScrollView.tag = 1001010;
            //        CALayer *layer=[_PersonalCollectionView.bjView layer];
            //        [layer setMasksToBounds:YES];
            //        [layer setCornerRadius:0.0];
            //        [layer setBorderWidth:1];
            //        [layer setBorderColor:[[UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1] CGColor]];
            
        }
}
}
-(void)jiazaizhiboView{
    if (!(_zhiboViewArr.count ==0)) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 135)];
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.delegate = self;
        self.topScrollView.contentSize = CGSizeMake(98 *_zhiboViewArr.count + 10*(_zhiboViewArr.count + 1), 135);
        self.topScrollView.directionalLockEnabled = YES;
        //滚动条
        self.topScrollView.showsVerticalScrollIndicator = NO;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_topScrollView];
        for (int i = 0; i < _zhiboViewArr.count; i ++) {
            _PersonalZBCollectionView = [[[NSBundle mainBundle]loadNibNamed:@"PersonalZBCollectionView" owner:self options:nil] objectAtIndex:0];
            LatestLiveModel *model = _zhiboViewArr[i];
            
            if (_zhiboViewArr.count == 0) {
                self.labLin.hidden = YES;
                self.topScrollView.hidden = YES;
                //先注释了
//                [self.topScrollView removeAllSubviews];
            }
            [self.gengduoBtn setTitle:@"更多直播" forState:UIControlStateNormal];
            
            _PersonalZBCollectionView.topImage.clipsToBounds = YES;
            [_PersonalZBCollectionView.topImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"展位图3"]];
            _PersonalZBCollectionView.nameLable.text = model.name;
            _PersonalZBCollectionView.frame = CGRectMake(i*98 + 10 *(i + 1), 0, 98, 135);
            
            _PersonalZBCollectionView.tag = 2000+i;
            
            UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoZBClick:)];
            [_PersonalZBCollectionView addGestureRecognizer:singleTap];
            [self.topScrollView addSubview:_PersonalZBCollectionView];
            self.topScrollView.tag = 2001010;
        }
    }
}

//点击直播
- (void)videoZBClick:(UITapGestureRecognizer *)tap
{
    
    //先注释了
    
    
}
//个人成果
- (void)videoxhClick:(UITapGestureRecognizer *)sender
{
    
    
    //先注释了
    
    
//    _ViedoStr = @"0";
//    [MobClick event:MYFruitEvent];
//    
//    UIImageView *iv = (UIImageView *)sender.view;
//    long i = iv.tag-1000;
//    PersonalModell *mode = _chengjiuArr[i];
//    if ([mode.dataModelType isEqualToString:@"GovRoadShow"]||[mode.dataModelType isEqualToString:@"TradingCenter"]){
//        // @"[在线课程]"   //= @"[地方政府说]";
//        
//        CourseDetailsViewController *customVC = [[CourseDetailsViewController alloc] init];
//        customVC.videoUrl = mode.uri  ;
//        customVC.type = 2;// 视频传2  课件传1
//        customVC.mid = mode.mid;
//        customVC.isRoleType = YES;
//        [self personalDelegateMethod:customVC];
//        
//    }else if ([mode.dataModelType isEqualToString:@"FinanceCoursez"]){
//        // @"[在线课程]"
//        
//        CourseDetailsViewController *customVC = [[CourseDetailsViewController alloc] init];
//        customVC.videoUrl = mode.uri  ;
//        customVC.type = 1;// 视频传2  课件传1
//        customVC.mid = mode.mid;
//        [self personalDelegateMethod:customVC];
//    }else if ([mode.dataModelType isEqualToString:@"OtoSchoolTopic"]){
//        // @"[一对一话题]";
//        ConsultingDetailsViewController *oneToOne2List = [[ConsultingDetailsViewController alloc]init];
//        oneToOne2List.hidesBottomBarWhenPushed = YES;
//        oneToOne2List.mid = mode.epId;
//        [self personalDelegateMethod:oneToOne2List];
//    }else if ([mode.dataModelType isEqualToString:@"Projectz"]||[mode.dataModelType isEqualToString:@"RoadShow"]){
//        LuYanProjectInfoViewController *LuYanInfo = [[LuYanProjectInfoViewController alloc]init];
//        if ([mode.projectLevel isEqualToString:@"incubationproject"]) {//孵化项目
//            LuYanInfo.LuYanInfo = DetailedTypeInvestorsSeeInfo2;
//        }else{
//            LuYanInfo.LuYanInfo = DetailedTypeInvestorsSeeInfo;
//        }
//        LuYanInfo.projectId = mode.mid;
//        [self personalDelegateMethod:LuYanInfo];
//    }
}
#pragma mark - 代理方法
// 代理方法
-(void)personalDelegateMethod:(UIViewController *)controller{
    if ([_ViedoStr isEqualToString:@"1"]) {
        if ([self.moreDelegate respondsToSelector:@selector(pushVideoPersonalController:)]) {
            [self.moreDelegate pushVideoPersonalController:controller];
        }
    }else{
        if ([self.moreDelegate respondsToSelector:@selector(pushPersonalController:)]) {
            [self.moreDelegate pushPersonalController:controller];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
