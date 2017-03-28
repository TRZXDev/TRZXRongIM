//
//  TRZXFriendLineCellCommentView.h




#import <UIKit/UIKit.h>


@interface TRZXFriendLineCellCommentView : UIView


@property (nonatomic, copy) void (^trzxPresentBlock)(NSString *commentId);

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClick1CommentLabelBlock)(NSString *commentId,NSString *commentName,NSString *parentId,NSString *mid,NSString *comment, CGRect rectInWindow);

@property (nonatomic, copy) void (^didClickCopyBlock)(NSString *comment,CGRect rectInWindow);

@end
