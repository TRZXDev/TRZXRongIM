//
//  AJPhotoGroupCell.h
//  AJPhotoPicker
//
//  Created by Alen on 16/4/13.
//  Copyright © 2016年 zwyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;

@interface AJPhotoGroupCell : UITableViewCell

/**
 *  显示相册信息
 *
 *  @param assetsGroup 相册
 */
- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
