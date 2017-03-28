//
//  PersonalZhiBoViewController.h
//  tourongzhuanjia
//
//  Created by Rhino on 16/6/7.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoDelegate <NSObject>
- (void)pushAllSetting;
@end

/**
 *  查看更多直播
 */
@interface PersonalZhiBoViewController : UIViewController

@property (nonatomic, weak) id<VideoDelegate>delegate;

@property (nonatomic,assign)BOOL isSelf;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic,copy)NSString *beVistedId;

@property (nonatomic,copy)NSString *otherStr;


@end
