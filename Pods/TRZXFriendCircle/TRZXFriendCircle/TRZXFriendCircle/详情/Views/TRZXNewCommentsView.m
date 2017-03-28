//
//  TRZXNewCommentsView.m
//  TRZX
//
//  Created by 张江威 on 2016/11/9.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXNewCommentsView.h"

#import "UIView+SDAutoLayout.h"
#import "TRZXFriendLineCellModel.h"
#import "MLLinkLabel.h"

#import "TRZXFriendLineCellCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "MLLinkLabel.h"
#import "UIImageView+WebCache.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]

#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]



@interface TRZXNewCommentsView () <MLLinkLabelDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) NSString *copStr;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *likeImage;

@property (nonatomic, strong) UIImageView * image;
@property (nonatomic, strong) UIImageView * image2;

@property (nonatomic, strong) UIView * vview;

@property (nonatomic, strong) MLLinkLabel *commentLabel;

@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@property (nonatomic, strong) MLLink *activeLink;

@end

@implementation TRZXNewCommentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}
- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    _bgImageView.image = bgImage;
    [self addSubview:_bgImageView];
    
    _likeLableBottomLine = [UIView new];
    _likeLableBottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:_likeLableBottomLine];
    
    _image2 = [UIImageView new];
    _image2.image = [UIImage imageNamed:@"TRZXComment1"];
//    _image2.frame = CGRectMake(1, 5, 25, 20);
    [self addSubview:_image2];
    _image2.hidden = YES;
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        label.textColor = heizideColor;
        UIColor *highLightColor = TimeLineCellHighlightedColor;
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        
        
        
        TRZXFriendLineCellCommentItemModel *model = commentItemsArray[i];
        _commentLabel = self.commentLabelsArray[i];
        _commentLabel.tag = i;
        _commentLabel.delegate = self;
        //判断需要变色的文本
//        _commentLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
//        _commentLabel.userInteractionEnabled = YES;
//        UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [_commentLabel addGestureRecognizer:touch];
        
        _commentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelTapped:)];
        [_commentLabel addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPressGR.minimumPressDuration = 1;
        [_commentLabel addGestureRecognizer:longPressGR];
        _commentLabel.attributedText = [self generateAttributedStringWithCommentItemModel:model];
    }
}
//加载传值点赞的UI
- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    _vview = [UIView new];
    [self addSubview:_vview];
    
    _image = [UIImageView new];
    _image.image = [UIImage imageNamed:@"TRZXLike"];
    _image.frame = CGRectMake(1, 5, 25, 20);
    [_vview addSubview:_image];
    
    //点赞的头像
    for (int i = 0; i < likeItemsArray.count; i ++) {
        TRZXFriendLineCellLikeItemModel * model = [likeItemsArray objectAtIndex:i];
        _likeImage = [UIImageView new];
        _likeImage.tag = 20161109 + i;
//        _likeImage.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeImageTapped:)];
//        [_likeImage addGestureRecognizer:tap];
        _likeImage.frame = CGRectMake(30 +(i%6)*45, i/6 *40 + (i/6+1)*5, 40, 40);
        [_likeImage sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"首页头像"]];
//        _likeImage.image = [UIImage imageNamed:model.headImage];
        
        [_vview addSubview:_likeImage];
    }
}



- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
    CGFloat margin = 5;
    
    UIView *lastTopView = nil;
    
    NSInteger teger;
    if (likeItemsArray.count%6 != 0) {
        teger = 7+(likeItemsArray.count/6+1)*45;
    }else{
        teger = 7+likeItemsArray.count/6*40;
    }
    if (likeItemsArray.count) {
        _vview.sd_resetLayout
        .leftSpaceToView(self, margin)
        .rightSpaceToView(self, margin)
        .topSpaceToView(lastTopView, 10)
        .heightIs(teger);
        _image.hidden = NO;
        lastTopView = _vview;
        
    } else {
        _image.hidden = YES;
        _vview.sd_resetLayout
        .heightIs(0);
    }
    if (self.commentItemsArray.count) {
        _image2.hidden = NO;
        _image2.sd_resetLayout
        .leftSpaceToView(self, margin+margin)
        .topSpaceToView(lastTopView, 3*margin)
        .widthIs(15)
        .heightIs(13);
        
        
    } else {
        _image2.hidden = YES;
        _image2.sd_resetLayout
        .heightIs(0);
    }
    
    if (self.commentItemsArray.count && self.likeItemsArray.count) {
        _likeLableBottomLine.sd_resetLayout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(1)
        .topSpaceToView(lastTopView, 4);
        
        lastTopView = _likeLableBottomLine;
    } else {
        _likeLableBottomLine.sd_resetLayout.heightIs(0);
    }
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        CGFloat topMargin;
//        if(i ==0){
//            topMargin = 10;
//        }else{
//            topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 5;
//        }
        if (likeItemsArray.count == 0 && i == 0) {
            topMargin = 10;
        }else if (likeItemsArray.count != 0 && i == 0) {
            topMargin = 0;
        }else{
            topMargin = 10;
        }
        TRZXFriendLineCellCommentItemModel *model = commentItemsArray[i];
        
        _iconView = [UIImageView new];
        _iconView.layer.masksToBounds = YES;
//        _iconView.image = [UIImage imageNamed:@"icon0.jpg"];
        [_iconView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"首页头像"]];
        _iconView.tag = 20161112+i;
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentIconImageTapped:)];
        [_iconView addGestureRecognizer:tap];
       
        _iconView.layer.cornerRadius = 4.0;
        //    _iconView.layer.borderWidth = 2;
        [self addSubview:_iconView];
        _nameLable = [UILabel new];
        _nameLable.text = model.firstUserName;
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textColor = TimeLineCellHighlightedColor;
        [self addSubview:_nameLable];
        _nameLable.tag = 20161112+i;
        _nameLable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentIconImageTapped:)];
        [_nameLable addGestureRecognizer:tap1];
        UILabel * dataLab = [UILabel new];
        dataLab.text = model.date;
        dataLab.font = [UIFont systemFontOfSize:13];
        dataLab.textAlignment = NSTextAlignmentRight;
        dataLab.textColor = zideColor;
        [self addSubview:dataLab];
        
        UILabel * linlab = [UILabel new];
        linlab.backgroundColor = zideColor;
        [self addSubview:linlab];
        
        _iconView.sd_layout
        .leftSpaceToView(self, 35)
        .topSpaceToView(lastTopView, topMargin+10)
        .widthIs(40)
        .heightIs(40);
        
        
        _nameLable.sd_layout
        .leftSpaceToView(_iconView,margin+5)
        .topSpaceToView(lastTopView, topMargin+10)
        .widthIs(130)
        .heightIs(18);
//        [_nameLable setSingleLineAutoResizeWithMaxWidth:WIDTH(self)-(220)];
        
        dataLab.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(lastTopView, topMargin+10)
        .heightIs(18);
        [dataLab setSingleLineAutoResizeWithMaxWidth:120];
        
        label.sd_layout
        .leftSpaceToView(self, 85)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, 35+topMargin)
        .autoHeightRatio(0);
        
        linlab.sd_layout
        .leftSpaceToView(self, 35)
        .rightSpaceToView(self, 10)
        .topSpaceToView(label, 9)
        .heightIs(0.5);
        
        if (i >= self.commentItemsArray.count-1) {
            linlab.hidden = YES;
        }else{
            linlab.hidden = NO;
        }
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:10];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(TRZXFriendLineCellCommentItemModel *)model
{
    NSString *text = @"";
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@：", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.commentString]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : @""} range:[text rangeOfString:@""]];
    if (model.secondUserName) {
        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(TRZXFriendLineCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

#pragma mark - private actions
//蓝色字体的点击事件
- (void)commentLabelTapped:(UITapGestureRecognizer *)tap
{
    if (self.commentLabel) {
        if (!self.activeLink) {
            if (self.didClick1CommentLabelBlock) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                CGRect rect = [tap.view.superview convertRect:tap.view.frame toView:window];
                TRZXFriendLineCellCommentItemModel *model = self.commentItemsArray[tap.view.tag];
                self.didClick1CommentLabelBlock(model.firstUserId,model.firstUserName,model.parentId,model.headImage,model.mid,model.commentString, rect);
                return ;
            }
        }
    }
}
-(void)longPress:(UILongPressGestureRecognizer *) longPress{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    CGRect rect = [longPress.view.superview convertRect:longPress.view.frame toView:window];
    if (longPress.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"111");
        return;
    }else if (longPress.state == UIGestureRecognizerStateBegan){
//        NSLog(@"222");
        [self becomeFirstResponder];
        if (self.didClick1CopyBlock) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CGRect rect = [longPress.view.superview convertRect:longPress.view.frame toView:window];
            TRZXFriendLineCellCommentItemModel *model = self.commentItemsArray[longPress.view.tag];
            self.didClick1CopyBlock(model.commentString, rect);
            return ;
        }
        
//        TRZXFriendLineCellCommentItemModel *model = _commentItemsArray[longPress.view.tag];
//        _copStr = model.commentString;
//        self.backgroundColor = backColor;
//        _itemIT = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(newFunc:)];
//        [[UIMenuController sharedMenuController] setTargetRect:rect inView:self.superview];
//        [UIMenuController sharedMenuController].menuItems = @[_itemIT];
//        [UIMenuController sharedMenuController].menuVisible = YES;
        
        
    }
//    if ([longPress state] == UIGestureRecognizerStateBegan) {
//        TRZXFriendLineCellCommentItemModel *model = self.commentItemsArray[longPress.view.tag];
//        NSLog(@"%@",model.commentString);
//        
//    }
}
//头像的点击事件
- (void)commentIconImageTapped:(UITapGestureRecognizer *)tap
{
//            if (self.didClickCommentIconImageBlock) {
//                TRZXFriendLineCellCommentItemModel *model = self.commentItemsArray[tap.view.tag-20161112];
//                self.didClickCommentIconImageBlock(model.firstUserId);
//                return ;
//            }
    if (self.didClick1CommentLabelBlock) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [tap.view.superview convertRect:tap.view.frame toView:window];
        TRZXFriendLineCellCommentItemModel *model = self.commentItemsArray[tap.view.tag-20161112];
        self.didClick1CommentLabelBlock(model.firstUserId,model.firstUserName,model.parentId,model.headImage,model.mid,model.commentString, rect);
        return ;
    }

}


//点赞头像点击事件
- (void)likeImageTapped:(UITapGestureRecognizer *)tap{
    NSInteger integer;
    integer = tap.view.tag-20161109;
    NSLog(@"点击的第----%ld----个",(long)integer);
    TRZXFriendLineCellLikeItemModel *model = self.likeItemsArray[integer];
    if (self.trzx1PresentBlock) {
        self.trzx1PresentBlock(model.mid);
    }
}
#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    
    if (self.trzx1PresentBlock) {
        self.trzx1PresentBlock(link.linkValue);
    }
}



@end

