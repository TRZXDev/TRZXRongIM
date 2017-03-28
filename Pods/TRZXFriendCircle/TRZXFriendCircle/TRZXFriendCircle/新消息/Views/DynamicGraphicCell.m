//
//  DynamicGraphicCell.m
//  TRZX
//
//  Created by 张江威 on 2016/10/27.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "DynamicGraphicCell.h"

#import "UIView+SDAutoLayout.h"

#import "DynamicHomeModel.h"
#import "UIImageView+WebCache.h"
#define xiandeColor [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define HEIGTH(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width


@implementation DynamicGraphicCell
{
    UILabel *_titleLabel;
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}


- (void)setup
{
    
    _iconView = [UIImageView new];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 4.0;
    //    _iconView.layer.borderWidth = 2;
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    
    _likeImage = [UIImageView new];
    _likeImage.image = [UIImage imageNamed:@"TRZXLike"];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    //    _imageView.layer.borderColor = [UIColor grayColor].CGColor;
    //    _imageView.layer.borderWidth = 1;
    
    _shareLable = [UILabel new];
    _shareLable.textColor = heizideColor;
    _shareLable.font = [UIFont systemFontOfSize:13];
    _shareLable.numberOfLines = 4;

    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    _lineLab = [UILabel new];
    _lineLab.backgroundColor = backColor;
    
    NSArray *views = @[_iconView, _nameLable,_titleLabel, _imageView,_timeLabel,_lineLab,_shareLable,_likeImage];
    
    [self.contentView sd_addSubviews:views];
    
    CGFloat margin = 10;
    UIView *contentView = self.contentView;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(50)
    .heightIs(50);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(contentView, margin)
    .heightIs(18)
//    [_timeLabel setSingleLineAutoResizeWithMaxWidth:WIDTH(self.contentView)-(170)];
    .widthIs(150);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_nameLable, 5)
    .rightSpaceToView(contentView, 100)
    .autoHeightRatio(0);
    
    _likeImage.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_nameLable, 5)
    .widthIs(25)
    .heightIs(20);
    
    _imageView.sd_layout
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .widthIs(60)
    .heightIs(60);
    
    _shareLable.sd_layout
    .topSpaceToView(contentView, 5)
    .rightSpaceToView(contentView, margin)
    .widthIs(60)
    .heightIs(70);
    
    _timeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 7)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:WIDTH(self.contentView)-(160)];
    
    _lineLab.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .heightIs(1);
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
//    [self setupAutoHeightWithBottomViewsArray:@[_iconView, _nameLable,_titleLabel, _imageView,_titleLabel,_timeLabel] bottomMargin:margin];
    
//    UIView *bottomView;
//    bottomView = _timeLabel;
//    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
    
}

- (void)setModel:(DynamicHomeModel *)model
{
    _model = model;
    
    if ([model.picOrText isEqualToString:@"text"]) {
        _shareLable.text = model.content;
        _imageView.hidden = YES;
        _shareLable.hidden = NO;
    }else if ([model.picOrText isEqualToString:@"pic"]) {
        _imageView.hidden = NO;
        _shareLable.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.content] placeholderImage:[UIImage imageNamed:@"展位图.png"]];
    }
    if ([model.delFlag isEqualToString:@"1"]&&[model.type isEqualToString:@"text"]) {//判断是不是已经删除
        _titleLabel.hidden = NO;
        _likeImage.hidden = YES;
        _titleLabel.backgroundColor = backColor;
        _titleLabel.text = @"该评论已经删除";
    }else if ([model.type isEqualToString:@"good"]) {
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = @"赞";
        _titleLabel.hidden = YES;
        _likeImage.hidden = NO;
        
    }else if ([model.type isEqualToString:@"text"]) {
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = model.commText;
        _titleLabel.hidden = NO;
        _likeImage.hidden = YES;
    }

    _nameLable.text = model.commUserName;
    
    _timeLabel.text = model.data;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"展位图.png"]];
    UIView *bottomView;
    bottomView = _timeLabel;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
    
}

@end
