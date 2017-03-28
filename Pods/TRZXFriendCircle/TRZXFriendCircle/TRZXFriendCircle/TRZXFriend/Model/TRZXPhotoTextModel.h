//
//  TRZXPhotoTextModel.h
//  TRZX
//
//  Created by 张江威 on 2016/11/10.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRZXFriendLikeModel,TRZXFriendCommentModel;


@interface TRZXPhotoTextModel : NSObject

@property (nonatomic, copy) NSString *describe;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString * isGood;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *objId;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString * shareImg;


@property (nonatomic, strong) NSArray<NSString *> *pics;

@property (nonatomic, strong) NSArray<TRZXFriendLikeModel *> *goods;
@property (nonatomic, strong) NSArray<TRZXFriendCommentModel *> *comments;

@end


@interface TRZXFriendLikeModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *circleId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;



@end

@interface TRZXFriendCommentModel : NSObject

@property (nonatomic, copy) NSString *beCommentId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentUser;
@property (nonatomic, copy) NSString *parentUserName;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *type;



@end
