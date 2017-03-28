//
//  CollctionCell.m
//  CustomWaterFlow
//
//  Created by DYS on 15/12/12.
//  Copyright © 2015年 DYS. All rights reserved.
//

#import "TRPLiveListCollectionCell.h"
#import "UIImageView+WebCache.h"


@interface TRPLiveListCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *onlinePeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchPeopleLabel;

@end

@implementation TRPLiveListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 1;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor clearColor].CGColor;


    self.createDateLabel.shadowColor = [UIColor blackColor];
    self.createDateLabel.shadowOffset = CGSizeMake(0, 1.0);

}

- (void)setModel:(LatestLiveModel *)model{

    NSString *liveCover;
    if(model.liveCover.length>0){
        liveCover = model.liveCover;
    }else if (model.videoImg.length>0){
        liveCover = model.videoImg;
    }else if (model.liveImg.length>0){
        liveCover = model.liveImg;
    }else if (model.img.length>0){
        liveCover = model.img;
    }else{
        liveCover = model.headImg;

    }




    NSString *liveTitle;

    if(model.liveTitle.length>0){
        liveTitle = model.liveTitle;
    }else if (model.abstractz.length>0){
        liveTitle = model.abstractz;
    }else if (model.abstractz.length>0){
        liveTitle = model.abstractz;
    }else if (model.title.length>0){
        liveTitle = model.title;
    }else if (model.name.length>0){
        liveTitle = model.name;
    }
    self.contentLabel.text = liveTitle;
    self.createDateLabel.text = model.updateDate.length>0?model.updateDate:@"";



    if([model.liveOrVideo isEqualToString:@"live"]){
        self.liveIconImageView.image = [UIImage imageNamed:@"直播"];
        self.playImageView.image = [UIImage imageNamed:@"C直播"];

        self.onlinePeopleLabel.hidden = NO;
        self.peopleImageView.hidden = YES;
        self.onlinePeopleLabel.text = [NSString stringWithFormat:@"在线人数：%@人",model.rate];
        self.watchPeopleLabel.hidden = YES;

    }else{

        self.liveIconImageView.image = [UIImage imageNamed:@"回看"];
        self.playImageView.image = [UIImage imageNamed:@"C回看"];
        self.watchPeopleLabel.hidden = NO;


        self.onlinePeopleLabel.hidden = YES;
        self.peopleImageView.hidden = NO;

        self.watchPeopleLabel.text = [NSString stringWithFormat:@"%@",model.rate];


    }

    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:liveCover] placeholderImage:[UIImage imageNamed:@"展位图"]];



}
@end
