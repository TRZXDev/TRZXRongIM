//
//  TRZXFriendDetailsCell.h
//  TRZX
//
//  Created by 张江威 on 2016/11/9.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRZXFriendLineCellModel.h"
#import "UIView+SDAutoLayout.h"

#import "TRZXNewCommentsView.h"

#import "TRZXFriendPhotoContainerView.h"

#import "TRZXFriendLineCellOperationMenu.h"

@protocol TRZXFriendDetailsCellDelegate <NSObject>


- (void)didClick2LikeButtonInCell:(UITableViewCell *)cell;
- (void)didClick2cCommentButtonInCell:(UITableViewCell *)cell;

@end

@class TRZXFriendLineCellModel;

@interface TRZXFriendDetailsCell : UITableViewCell


@property (nonatomic, strong) TRZXFriendPhotoContainerView *picContainerView;
@property (nonatomic, strong) TRZXNewCommentsView *commentView;
@property (nonatomic, strong) TRZXFriendLineCellOperationMenu *operationMenu;


@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *operationButton;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIView *shareCellView;
@property (nonatomic, strong) UIImageView *shareIconView;
@property (nonatomic, strong) UILabel *shareTitleLabel;



@property (nonatomic, weak) id<TRZXFriendDetailsCellDelegate> delegate;

@property (nonatomic, strong) TRZXFriendLineCellModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^more2ButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^delete2ButtonClickedBlock)(NSIndexPath *indexPath);


@property (nonatomic, copy) void (^didClick2CommentLabelBlock)(NSString *commentId,NSString *commentName,NSString *parentId,NSString *headImage,NSString *mid,NSString *comment, CGRect rectInWindow, NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCommentIconImageBlock)(NSString *mid);

@property (nonatomic, copy) void (^didClick1CopyBlock)(NSString *comment,CGRect rectInWindow);

@property (nonatomic, copy) void (^trzxPresent2Block)(NSString *commentId);

@end
