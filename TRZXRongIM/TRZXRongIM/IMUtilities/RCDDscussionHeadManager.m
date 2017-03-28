//
//  RCDDscussionHeadManager.m
//  TRZX
//
//  Created by 移动微 on 16/9/8.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDDscussionHeadManager.h"
#import <RongIMKit/RCConversationModel.h>
#import "RCDUIImageView.h"
#import "RCDHttpTool.h"
#import "RCDGroupInfo.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"
#import <RongIMKit/RongIMKit.h>

#define discusstionMargin 2

@interface RCDDscussionHeadManager()

@property(nonatomic, strong)UIImageView *tempGroupImage;

@end

@implementation RCDDscussionHeadManager

///  设置聊天组头像
///  @param headerImage cell objectForKey:headerIamge
///  @param model 会话模型
-(void)kipo_settingHeader:(UIImageView *)headerImage titleLabel:(UILabel *)titleLabel model:(RCConversationModel *)model{
    
    headerImage.image = nil;
    //头像
    if([[RCDataBaseManager shareInstance] getGroupByGroupId:model.targetId].groupHeadData){
        NSData *data = [[RCDataBaseManager shareInstance] getGroupByGroupId:model.targetId].groupHeadData;
        headerImage.image = [UIImage imageWithData:data];
        if ([[RCDataBaseManager shareInstance] getGroupByGroupId:model.targetId].name.length) {
            RCDGroupInfo *group = [[RCDataBaseManager shareInstance] getGroupByGroupId:model.targetId];
            titleLabel.text = group.name;
            model.extend = group;
        }else{
            [[RCDHttpTool shareInstance] getGroupByID:model.targetId successCompletion:^(RCDGroupInfo *group) {
                titleLabel.text = group.name;
                [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                model.extend = group;
            }];
        }
    }else{
        [[RCDHttpTool shareInstance] getGroupByID:model.targetId successCompletion:^(RCDGroupInfo *group) {
            titleLabel.text = group.name;

            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
            NSMutableArray *images = [NSMutableArray array];
            for (RCDUserInfo *userInfo in group.users) {
                [images addObject:userInfo.portraitUri];
            }
            [self setDiscusstionHead:headerImage LayoutWithimages:images targetId:model.targetId isSave:YES];
        }];
    }
}

//设置群聊的群头像
-(void)kipo_setGroupListHeader:(UIImageView *)headerImage groupInfo:(RCDGroupInfo *)groupInfo isSave:(BOOL)isSave{
    [[RCDataBaseManager shareInstance] insertGroupToDB:groupInfo];
    UIImageView *header;
    if (headerImage) {
        header = headerImage;
    }else{
        header = self.tempGroupImage;
    }
    header.image = nil;
    if(groupInfo.groupHeadData && !isSave){
        NSData *data = groupInfo.groupHeadData;
        header.image = [UIImage imageWithData:data];
    }else{
        [[RCDataBaseManager shareInstance] insertGroupToDB:groupInfo];
        NSMutableArray *images = [NSMutableArray array];
        for (RCDUserInfo *userInfo in groupInfo.users) {
            [images addObject:userInfo.portraitUri];
        }
        [self setDiscusstionHead:header LayoutWithimages:images targetId:groupInfo.mid isSave:isSave];
    }
}

/**
 更新群组信息
 
 @param groupId 群组id
 */
-(void)kipo_updateGroupInfoWithGroupId:(NSString *)groupId backGroupInfo:(void(^)(RCDGroupInfo *group))groupInfo{
    [[RCDHttpTool shareInstance] getGroupByID:groupId successCompletion:^(RCDGroupInfo *group) {
        [self kipo_setGroupListHeader:self.tempGroupImage groupInfo:group isSave:YES];
        groupInfo(group);
    }];
}

#pragma mark - Helper
/**
 *  添加讨论组头像
 *
 *  @param headView 头像view(UIImageView)
 *  @param photos   头像URL
 */
-(void)setDiscusstionHead:(UIImageView *)headView LayoutWithimages:(NSArray *)photos targetId:(NSString *)targetId isSave:(BOOL)isSave{
    
    headView.backgroundColor = [UIColor trzx_BackGroundColor];
    
    __block CGFloat DiscusstionWidth;
    switch (photos.count) {
        case 1:{
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[0] andFrame:CGRectMake(0, 0, headView.width, headView.height) targetId:targetId isSave:isSave];
        }
            break;
        case 2:{
            DiscusstionWidth = (headView.width - discusstionMargin * 3) / 2;
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[0] andFrame:CGRectMake(discusstionMargin, (headView.height - DiscusstionWidth) * 0.5, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[1] andFrame:CGRectMake(discusstionMargin * 2 + DiscusstionWidth, (headView.height - DiscusstionWidth) * 0.5, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
        }
            break;
        case 3:{
            DiscusstionWidth = (headView.width - discusstionMargin * 3) / 2;
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[0] andFrame:CGRectMake((headView.width - DiscusstionWidth) * 0.5, discusstionMargin, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[1] andFrame:CGRectMake(discusstionMargin, DiscusstionWidth + discusstionMargin * 2, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[2] andFrame:CGRectMake(discusstionMargin * 2 + DiscusstionWidth, DiscusstionWidth + discusstionMargin * 2, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
        }
            break;
        case 4:{
            DiscusstionWidth = (headView.width - discusstionMargin * 3) / 2;
            for (int i = 0; i < 4; i++) {
                int row = i / 2;
                int loc = i % 2;
                CGFloat x = (DiscusstionWidth + discusstionMargin)* loc + discusstionMargin;
                CGFloat y = (DiscusstionWidth + discusstionMargin)* row + discusstionMargin;
                [self addDiscusstionImageWithHeadView:headView photoUrl:photos[i] andFrame:CGRectMake(x, y, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            }
        }
            break;
        case 5:{
            DiscusstionWidth = (headView.width - discusstionMargin * 4) / 3;
            CGFloat fitstY = headView.height / 4 - 5;
            CGFloat fitstX = ((headView.height - DiscusstionWidth * 2) - discusstionMargin) / 2;
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[0] andFrame:CGRectMake(fitstX, fitstY, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[1] andFrame:CGRectMake(fitstX + discusstionMargin + DiscusstionWidth, fitstY, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[2] andFrame:CGRectMake(discusstionMargin, discusstionMargin + DiscusstionWidth + fitstY, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[3] andFrame:CGRectMake((discusstionMargin  * 2 + DiscusstionWidth ), discusstionMargin + DiscusstionWidth +  fitstY, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[4] andFrame:CGRectMake((discusstionMargin + DiscusstionWidth ) * 2 + discusstionMargin, discusstionMargin + DiscusstionWidth + fitstY, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
        }
            break;
        case 6:{
            DiscusstionWidth = (headView.width - discusstionMargin * 4) / 3;
            CGFloat marginY = headView.height / 4 - 5;
            for (int i = 0; i < 6; i++) {
                
                int row = i / 3;
                int loc = i % 3;
                CGFloat x = loc * (DiscusstionWidth + discusstionMargin )+ discusstionMargin;
                CGFloat y = row * (DiscusstionWidth + discusstionMargin )+ discusstionMargin +marginY;
                
                [self addDiscusstionImageWithHeadView:headView photoUrl:photos[i] andFrame:CGRectMake(x, y, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            }
        }
            break;
        case 7:{
            DiscusstionWidth = (headView.width - discusstionMargin * 4) / 3;
            
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[0] andFrame:CGRectMake((headView.width - DiscusstionWidth) * 0.5, discusstionMargin, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            
            CGFloat marginY = discusstionMargin + DiscusstionWidth;
            for (int i = 0; i < 6; i++) {
                
                int row = i / 3;
                int loc = i % 3;
                CGFloat x = loc * (DiscusstionWidth + discusstionMargin )+ discusstionMargin;
                CGFloat y = row * (DiscusstionWidth + discusstionMargin )+ discusstionMargin +marginY;
                
                [self addDiscusstionImageWithHeadView:headView photoUrl:photos[i + 1] andFrame:CGRectMake(x, y, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            }
        }
            break;
        case 8:{
            DiscusstionWidth = (headView.width - discusstionMargin * 4) / 3;
            
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[0] andFrame:CGRectMake(discusstionMargin, discusstionMargin, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            [self addDiscusstionImageWithHeadView:headView photoUrl:photos[1] andFrame:CGRectMake(discusstionMargin * 2 + DiscusstionWidth, discusstionMargin, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            
            CGFloat marginY = discusstionMargin + DiscusstionWidth;
            for (int i = 0; i < 6; i++) {
                
                int row = i / 3;
                int loc = i % 3;
                CGFloat x = loc * (DiscusstionWidth + discusstionMargin )+ discusstionMargin;
                CGFloat y = row * (DiscusstionWidth + discusstionMargin )+ discusstionMargin +marginY;
                
                [self addDiscusstionImageWithHeadView:headView photoUrl:photos[i + 1] andFrame:CGRectMake(x, y, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            }
        }
            break;
        default:{
            DiscusstionWidth = (headView.width - discusstionMargin * 4) / 3;
            NSUInteger count = photos.count > 9?9:photos.count;
            for (int i = 0; i < count; i++) {
                int row = i / 3;
                int loc = i % 3;
                CGFloat x = loc * (DiscusstionWidth + discusstionMargin )+ discusstionMargin;
                CGFloat y = row * (DiscusstionWidth + discusstionMargin )+ discusstionMargin;
                [self addDiscusstionImageWithHeadView:headView photoUrl:photos[i] andFrame:CGRectMake(x, y, DiscusstionWidth, DiscusstionWidth) targetId:targetId isSave:isSave];
            }
        }
            break;
    }
}

-(void)addDiscusstionImageWithHeadView:(UIImageView *)headView photoUrl:(NSString *)photoUrl andFrame:(CGRect)frame targetId:(NSString *)targetId isSave:(BOOL)isSave{
    
    RCDUIImageView *imageView = [[RCDUIImageView alloc]initWithFrame:frame];
    [headView addSubview:imageView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image != nil && isSave){
            
            [[RCDataBaseManager shareInstance] insertGroupHeaderIconToDB:targetId data:[[headView RC_convertViewToImage] RC_dataCompress]];
            headView.image = [UIImage imageWithData:[[RCDataBaseManager shareInstance] getGroupByGroupId:targetId].groupHeadData];
        }else{
            headView.image = [headView RC_convertViewToImage];
//            [UIImage imageWithData:[[RCDataBaseManager shareInstance] getGroupByGroupId:targetId].groupHeadData];
        }
    }];
}

-(UIImageView *)tempGroupImage{
    return [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [RCIM sharedRCIM].globalMessagePortraitSize.width, [RCIM sharedRCIM].globalMessagePortraitSize.height)];
}

@end
