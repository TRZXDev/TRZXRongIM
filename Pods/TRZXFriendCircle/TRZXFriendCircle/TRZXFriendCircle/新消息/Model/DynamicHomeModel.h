//
//  DynamicHomeModel.h
//  TRZX
//
//  Created by 张江威 on 2016/10/27.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicHomeModel : NSObject


@property (nonatomic, copy) NSString *circleId;//对应朋友圈id

@property (nonatomic, copy) NSString *commUserName;//评论人名
@property (nonatomic, copy) NSString *commId;//评论id

@property (nonatomic, copy) NSString *commUserId;//评论人id

@property (nonatomic, strong) NSString *mid;

@property (nonatomic, copy) NSString *commText;//评论内容 ()

@property (nonatomic, copy) NSString *type;//类型 (点赞or文本 good , text)

@property (nonatomic, copy) NSString *delFlag;//评论是否删除

@property (nonatomic, copy) NSString *cirDel;//评论是否删除

@property (nonatomic, copy) NSString *data;//评论时间

@property (nonatomic, copy) NSString *picOrText;//显示图片或者文字 pic // text

@property (nonatomic, copy) NSString *headImg;//评论人头像

@property (nonatomic, copy) NSString *content;


@end
