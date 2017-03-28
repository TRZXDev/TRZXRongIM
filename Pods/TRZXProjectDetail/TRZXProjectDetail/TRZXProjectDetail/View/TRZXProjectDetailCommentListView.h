//
//  TRZXProjectDetailCommentListView.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/9.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRZXProjectDetailCommentModel;

@interface TRZXProjectDetailCommentListView : UIView

+ (TRZXProjectDetailCommentListView *)sharedCommentList;

- (TRZXProjectDetailCommentListView *)showCommentList:(NSArray <TRZXProjectDetailCommentModel *> *)commentList;

- (void)dissMiss;
@end
