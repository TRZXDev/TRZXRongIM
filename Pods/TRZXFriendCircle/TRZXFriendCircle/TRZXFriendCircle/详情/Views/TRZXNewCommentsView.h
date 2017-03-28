//
//  TRZXNewCommentsView.h
//  TRZX
//
//  Created by 张江威 on 2016/11/9.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRZXNewCommentsView : UIView


@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLable;
//@property (nonatomic, strong) UIMenuItem * itemIT;

@property (nonatomic, copy) void (^trzx1PresentBlock)(NSString *commentId);

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClick1CommentLabelBlock)(NSString *commentId,NSString *commentName,NSString *parentId,NSString *headImage,NSString *mid,NSString *comment, CGRect rectInWindow);

@property (nonatomic, copy) void (^didClick1CopyBlock)(NSString *comment,CGRect rectInWindow);

@property (nonatomic, copy) void (^didClickCommentIconImageBlock)(NSString *mid);



@end
