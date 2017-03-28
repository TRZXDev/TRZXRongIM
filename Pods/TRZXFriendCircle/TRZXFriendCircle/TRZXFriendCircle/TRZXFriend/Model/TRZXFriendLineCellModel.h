

#import <Foundation/Foundation.h>

@class TRZXFriendLineCellLikeItemModel, TRZXFriendLineCellCommentItemModel,TRZXFriendShareItemModel,TRZXFriendHeaderModel;

@interface TRZXFriendLineCellModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *objId;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString * shareImg;

@property (nonatomic, copy) NSString * coverImage;
@property (nonatomic, copy) NSString * messageImage;
@property (nonatomic, copy) NSString * messageLabel;



@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;

//@property (nonatomic, copy) NSString *liked;
@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, assign, getter = isMessage) BOOL newMessage;


@property (nonatomic, strong) NSArray<TRZXFriendShareItemModel *> *shareItemsArray;

@property (nonatomic, strong) NSArray<TRZXFriendHeaderModel *> *headerItemsArray;


@property (nonatomic, strong) NSArray<TRZXFriendLineCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<TRZXFriendLineCellCommentItemModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL issOpening;

@property (nonatomic, assign, readonly) BOOL should1ShowMoreButton;

@property (nonatomic, assign, readonly) BOOL shareShowMoreButton;


@end


@interface TRZXFriendLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *circleId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

@end


@interface TRZXFriendShareItemModel : NSObject

@property (nonatomic, copy) NSString *objId;//课程Id
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImg;



@end

@interface TRZXFriendHeaderModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *coverImage;
@property (nonatomic, copy) NSString *headImage;

@property (nonatomic, assign, getter = isMessage) BOOL newMessage;

@end


@interface TRZXFriendLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *headImage;

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;


@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *type;


@property (nonatomic, copy) NSString *beCommentId;//当前心情的id
@property (nonatomic, copy) NSString *parentId;//回复上条评论的id

@end
