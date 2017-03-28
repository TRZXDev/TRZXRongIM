//
//  TRZXFriendLineCellOperationMenu.h


#import <UIKit/UIKit.h>
#import "TRZXFriendLineCellModel.h"


@interface TRZXFriendLineCellOperationMenu : UIView

@property (nonatomic, strong) TRZXFriendLineCellModel *model;

@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();

@property (nonatomic, strong) UIButton * likeButton;
@property (nonatomic, strong) UIButton * commentButton;


@end
