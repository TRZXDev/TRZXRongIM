
//
//  TRZXFriendDetailsCell.m
//  TRZX
//
//  Created by 张江威 on 2016/11/9.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXFriendDetailsCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"


#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define HEIGTH(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width



const CGFloat content2LabelFontSize = 15;
CGFloat max2ContentLabelHeight = 0; // 根据具体font而定

NSString *const kTRZXFriendDetailsCellOperationButtonClickedNotification = @"TRZXFriendDetailsCellOperationButtonClickedNotification";

@implementation TRZXFriendDetailsCell




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
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showClick:)];
    [self addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive2OperationButtonClickedNotification:) name:kTRZXFriendDetailsCellOperationButtonClickedNotification object:nil];
    
    _iconView = [UIImageView new];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 4.0;
    //    _iconView.layer.borderWidth = 2;
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = TimeLineCellHighlightedColor;
    
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:content2LabelFontSize];
    _contentLabel.textColor = heizideColor;
    _contentLabel.numberOfLines = 0;
    if (max2ContentLabelHeight == 0) {
        max2ContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    //点赞与评论按钮
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [TRZXFriendPhotoContainerView new];
    
    __weak typeof(self) weakSelf = self;
    
//    _commentView = [TRZXNewCommentsView new];
//    [_commentView setDidClick1CommentLabelBlock:^(NSString *commentId,NSString *commentName,NSString *parentId,NSString *headImage,NSString *mid,NSString *comment, CGRect rectInWindow) {
//        if (weakSelf.didClick2CommentLabelBlock) {
//            weakSelf.didClick2CommentLabelBlock(commentId,commentName,parentId,headImage,mid,comment, rectInWindow, weakSelf.indexPath);
//        }
//    }];

    
    //名字跳转
//    [_commentView setTrzx1PresentBlock:^(NSString *commentId) {
//        if (weakSelf.trzxPresent2Block) {
//            weakSelf.trzxPresent2Block(commentId);
//        }
//    }];
    //头像跳转
//    [_commentView setDidClickCommentIconImageBlock:^(NSString *mid) {
//        if (weakSelf.didClickCommentIconImageBlock) {
//            weakSelf.didClickCommentIconImageBlock(mid);
//        }
//    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    //删除的按钮
    _deleteButton = [UIButton new];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _operationMenu = [TRZXFriendLineCellOperationMenu new];
    
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClick2LikeButtonInCell:)]) {
            [weakSelf.delegate didClick2LikeButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClick2cCommentButtonInCell:)]) {
            [weakSelf.delegate didClick2cCommentButtonInCell:weakSelf];
        }
    }];
    
    _shareCellView = [UIView new];
    _shareCellView.backgroundColor = backColor;
    
    _shareIconView = [UIImageView new];
    _shareIconView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _shareIconView = YES;
    //    _shareIconView = 6.0;
    //    _shareIconView = 2;
    [_shareCellView addSubview:_shareIconView];
    
    _shareTitleLabel = [UILabel new];
    _shareTitleLabel.numberOfLines = 2;
    _shareTitleLabel.textColor = heizideColor;
    _shareTitleLabel.textAlignment = NSTextAlignmentLeft;
    _shareTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_shareCellView addSubview:_shareTitleLabel];
    _shareCellView.hidden = YES;
    _shareTitleLabel.hidden = YES;
    
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _picContainerView, _timeLabel,_deleteButton,_shareCellView ,_operationButton, _operationMenu];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(margin + 5);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_top).offset(0);
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.equalTo(@(18));
    }];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _shareCellView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, margin);
    //    .topSpaceToView(_picContainerView, 0);
    //    .heightIs(0);
    
    _shareIconView.sd_layout
    .leftSpaceToView(_shareCellView, 8)
    .centerYEqualToView(_shareCellView)
    .widthIs(40)
    .heightIs(40);
    
    [_shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shareCellView.mas_top).offset(8);
        make.left.equalTo(_shareIconView.mas_right).offset(8);
        make.right.equalTo(_shareCellView.mas_right).offset(-8);
    }];
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_shareCellView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:WIDTH(self.contentView)-(160)];
    
    _deleteButton.sd_layout
    .leftSpaceToView(_timeLabel,0)
    .topSpaceToView(_shareCellView, margin)
    .widthIs(50)
    .heightIs(15);
    
    _operationButton.sd_layout
    .rightSpaceToView(contentView, margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
//    _commentView.sd_layout
//    .leftSpaceToView(self.contentView, margin)
//    .rightSpaceToView(self.contentView, margin)
//    .topSpaceToView(_timeLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 0)
    .heightIs(36)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(TRZXFriendLineCellModel *)model
{
    _model = model;
    [_commentView removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    
    _commentView = [TRZXNewCommentsView new];
    [_commentView setDidClick1CommentLabelBlock:^(NSString *commentId,NSString *commentName,NSString *parentId,NSString *headImage,NSString *mid,NSString *comment, CGRect rectInWindow) {
        if (weakSelf.didClick2CommentLabelBlock) {
            weakSelf.didClick2CommentLabelBlock(commentId,commentName,parentId,headImage,mid,comment, rectInWindow, weakSelf.indexPath);
        }
    }];
    [_commentView setDidClick1CopyBlock:^(NSString *comment, CGRect rectInWindow) {
        if (weakSelf.didClick1CopyBlock) {
            weakSelf.didClick1CopyBlock(comment, rectInWindow);
        }
    }];
    
    [self.contentView addSubview:_commentView];
    
    _commentView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(_timeLabel, 10); // 已经在内部实现高度自适应所以不需要再设置高度
    
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    [_shareIconView sd_setImageWithURL:[NSURL URLWithString:model.shareImg] placeholderImage:[UIImage imageNamed:@"首页头像"]];
    _shareTitleLabel.text = model.shareTitle;
    
    _operationMenu.model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconName] placeholderImage:[UIImage imageNamed:@"首页头像"]];
    _nameLable.text = model.name;
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    _contentLabel.text = model.msgContent;
    
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    _iconView.tag = 20161029 + _indexPath.row;
    _deleteButton.tag = 20161101 + _indexPath.row;
    _shareCellView.tag = 20161111+ _indexPath.row;
    _contentLabel.tag = 20161129 + _indexPath.row;
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    if ([model.type isEqualToString:@"photo"]) {
        _shareCellView.sd_layout
        .topSpaceToView(_picContainerView, 0)
        .heightIs(0);
        _shareCellView.hidden = YES;
        _shareIconView.hidden = YES;
        _shareTitleLabel.hidden = YES;
        
    }else{
        _shareCellView.sd_layout
        .topSpaceToView(_picContainerView, 10)
        .heightIs(52);
        _shareCellView.hidden = NO;
        _shareIconView.hidden = NO;
        _shareTitleLabel.hidden = NO;
    }
    if ([model.userId isEqualToString:@""]) {//自己默认的ID
        _deleteButton.hidden = NO;
    }else{
        _deleteButton.hidden = YES;
    }
    UIView *bottomView;
    
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        _commentView.fixedWidth = @0; // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        _commentView.fixedHeight = @0; // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        _commentView.sd_layout.topSpaceToView(_timeLabel, 0);
        bottomView = _timeLabel;
    } else {
        _commentView.fixedHeight = nil; // 取消固定宽度约束
        _commentView.fixedWidth = nil; // 取消固定高度约束
        _commentView.sd_layout.topSpaceToView(_timeLabel, 10);
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = model.date;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.more2ButtonClickedBlock) {
        self.more2ButtonClickedBlock(self.indexPath);
    }
}
- (void)deleteButtonClicked
{
    if (self.delete2ButtonClickedBlock) {
        self.delete2ButtonClickedBlock(self.indexPath);
    }
}
- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)receive2OperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}
//弹出框消失
- (void)showClick:(UITapGestureRecognizer *)tap{
    _operationMenu.show = NO;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTRZXFriendDetailsCellOperationButtonClickedNotification object:_operationButton];
}

@end

