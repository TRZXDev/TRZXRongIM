//
//  TRZXFriendLineCell.h


#import <UIKit/UIKit.h>
#import "TRZXFriendLineCellModel.h"
#import "UIView+SDAutoLayout.h"

#import "TRZXFriendLineCellCommentView.h"

#import "TRZXFriendPhotoContainerView.h"

#import "TRZXFriendLineCellOperationMenu.h"

@protocol TRZXFriendLineCellDelegate <NSObject>


- (void)didClick1LikeButtonInCell:(UITableViewCell *)cell;
- (void)didClick1cCommentButtonInCell:(UITableViewCell *)cell;

@end

@class TRZXFriendLineCellModel;

@interface TRZXFriendLineCell : UITableViewCell


{
    BOOL _should1OpenContentLabel;
}
@property (nonatomic, strong) TRZXFriendPhotoContainerView *picContainerView;
@property (nonatomic, strong) TRZXFriendLineCellCommentView *commentView;
@property (nonatomic, strong) TRZXFriendLineCellOperationMenu *operationMenu;


@property (nonatomic, strong) UILabel * lineLab;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *operationButton;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIView *shareCellView;
@property (nonatomic, strong) UIImageView *shareIconView;
@property (nonatomic, strong) UILabel *shareTitleLabel;


//@property (nonatomic, strong) NSString * shareeStr;


@property (nonatomic, weak) id<TRZXFriendLineCellDelegate> delegate;

@property (nonatomic, strong) TRZXFriendLineCellModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^more1ButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^delete1ButtonClickedBlock)(NSIndexPath *indexPath);


@property (nonatomic, copy) void (^didClick1CommentLabelBlock)(NSString *commentId,NSString *commentName,NSString *parentId,NSString *mid,NSString *comment, CGRect rectInWindow, NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCopyBlock)(NSString *comment,CGRect rectInWindow);


@property (nonatomic, copy) void (^trzxPresentBlock)(NSString *commentId);

@end
