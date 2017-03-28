//
//  TRZXFriendLineCell.m


#import "TRZXFriendLineCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"



#define HEIGTH(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width
#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]


const CGFloat content1LabelFontSize = 15;
CGFloat max1ContentLabelHeight = 0; // 根据具体font而定

NSString *const kTRZXFriendLineCellOperationButtonClickedNotification = @"TRZXFriendLineCellOperationButtonClickedNotification";

@implementation TRZXFriendLineCell




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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive1OperationButtonClickedNotification:) name:kTRZXFriendLineCellOperationButtonClickedNotification object:nil];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshiClick:)];
    [self addGestureRecognizer:singleTap];
    _should1OpenContentLabel = NO;
    
    _iconView = [UIImageView new];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 4.0;
//    _iconView.layer.borderWidth = 2;
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = TimeLineCellHighlightedColor;
    
    _lineLab = [UILabel new];
    _lineLab.backgroundColor = backColor;
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:content1LabelFontSize];
    
    _contentLabel.textColor = heizideColor;
    _contentLabel.numberOfLines = 0;
    if (max1ContentLabelHeight == 0) {
        max1ContentLabelHeight = _contentLabel.font.lineHeight * 5;
    }
    //展示全文的按钮
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //点赞与评论按钮
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [TRZXFriendPhotoContainerView new];
    
    __weak typeof(self) weakSelf = self;
    
    _commentView = [TRZXFriendLineCellCommentView new];
    [_commentView setDidClick1CommentLabelBlock:^(NSString *commentId,NSString *commentName,NSString *parentId,NSString *mid,NSString *comment, CGRect rectInWindow) {
        if (weakSelf.didClick1CommentLabelBlock) {
            weakSelf.didClick1CommentLabelBlock(commentId,commentName,parentId,mid,comment, rectInWindow, weakSelf.indexPath);
        }
    }];
    [_commentView setTrzxPresentBlock:^(NSString *commentId) {
        if (weakSelf.trzxPresentBlock) {
            weakSelf.trzxPresentBlock(commentId);
        }
    }];
    
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
        if ([weakSelf.delegate respondsToSelector:@selector(didClick1LikeButtonInCell:)]) {
            [weakSelf.delegate didClick1LikeButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClick1cCommentButtonInCell:)]) {
            [weakSelf.delegate didClick1cCommentButtonInCell:weakSelf];
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
    
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel,_deleteButton,_shareCellView ,_operationButton, _operationMenu, _commentView,_lineLab];
    
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
    [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(0);
        make.left.equalTo(contentView.mas_left).offset(0);
        make.right.equalTo(contentView.mas_right).offset(0);
        make.height.equalTo(@(1));
    }];
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置

    _shareCellView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, margin);
//    .topSpaceToView(_picContainerView, 0)
//    .heightIs(52);
    
    _shareIconView.sd_layout
    .leftSpaceToView(_shareCellView, 8)
    .bottomSpaceToView(_shareCellView, 6)
    .topSpaceToView(_shareCellView, 6)
    .widthIs(40);
    
    _shareTitleLabel.sd_layout
    .leftSpaceToView(_shareIconView, 8)
    .rightSpaceToView(_shareCellView, 8)
    .topSpaceToView(_shareCellView, 6)
    .bottomSpaceToView(_shareCellView, 6);
//    .autoHeightRatio(0);
    
//    [_shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_shareCellView.mas_top).offset(8);
//        make.left.equalTo(_shareIconView.mas_right).offset(8);
//        make.right.equalTo(_shareCellView.mas_right).offset(-8);
//    }];
    
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
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
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

//    if (_model!=model) {
        _model = model;

        _commentView.frame = CGRectZero;
        [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];

        _should1OpenContentLabel = NO;
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
        __weak typeof(self) weakSelf = self;
        [_commentView setDidClickCopyBlock:^(NSString *comment, CGRect rectInWindow) {
            if (weakSelf.didClickCopyBlock) {
                weakSelf.didClickCopyBlock(comment, rectInWindow);
            }
        }];

        if (model.should1ShowMoreButton) { // 如果文字高度超过60
            _moreButton.sd_layout.heightIs(20);
            _moreButton.hidden = NO;
            if (model.issOpening) { // 如果需要展开
                _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
                [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
            } else {
                _contentLabel.sd_layout.maxHeightIs(max1ContentLabelHeight);
                [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
            }
        } else {
            _moreButton.sd_layout.heightIs(0);
            _moreButton.hidden = YES;
        }

        CGFloat picContainerTopMargin = 0;
        if (model.picNamesArray.count) {
            picContainerTopMargin = 10;
        }
        _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
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
        if ([model.userId isEqualToString:@""]) {//默认自己的ID
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


//    }


}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark - private actions

- (void)moreButtonClicked:(UIButton *)button
{
    if (self.more1ButtonClickedBlock) {
        self.more1ButtonClickedBlock(self.indexPath);
    }
}
- (void)deleteButtonClicked
{
    if (self.delete1ButtonClickedBlock) {
        self.delete1ButtonClickedBlock(self.indexPath);
    }
}
- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)receive1OperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}
//弹出框消失
- (void)xiaoshiClick:(UITapGestureRecognizer *)tap{
    _operationMenu.show = NO;
}
- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTRZXFriendLineCellOperationButtonClickedNotification object:_operationButton];
}

@end
