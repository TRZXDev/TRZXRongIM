//
//  RCConversationBaseCoverBtn.h
//  tourongzhuanjia
//
//  Created by 移动微 on 16/4/18.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface RCConversationBaseCoverBtn : UIButton

/*!
 会话Cell的数据模型
 */
@property(nonatomic, strong) RCConversationModel *model;

@property(nonatomic, strong)NSIndexPath *indexPath;

@end
