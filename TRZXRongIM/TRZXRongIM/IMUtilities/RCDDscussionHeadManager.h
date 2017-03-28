//
//  RCDDscussionHeadManager.h
//  TRZX
//
//  Created by 移动微 on 16/9/8.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCConversationModel,RCDGroupInfo;

///  私信列表讨论组头像 管理 -> 改为群组头像管理
@interface RCDDscussionHeadManager : NSObject

///  设置聊天组头像
///  @param headerImage cell objectForKey:headerIamge
///  @param model 会话模型
-(void)kipo_settingHeader:(UIImageView *)headerImage titleLabel:(UILabel *)titleLabel model:(RCConversationModel *)model;

-(void)kipo_setGroupListHeader:(UIImageView *)headerImage groupInfo:(RCDGroupInfo *)groupInfo isSave:(BOOL)isSave;


/**
 更新群组信息

 @param groupId 群组id 
 */
-(void)kipo_updateGroupInfoWithGroupId:(NSString *)groupId backGroupInfo:(void(^)(RCDGroupInfo *group))groupInfo;

@end
