//
//  RCDUserInfo.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDUserInfo.h"

@implementation RCDUserInfo

-(void)setMid:(NSString *)mid{
    self.userId = mid;
}

-(void)setUserId:(NSString *)userId{
    [super setUserId:userId];
    _mid = userId;
}

-(void)setHeadImg:(NSString *)headImg{
    self.portraitUri = headImg;
}

-(void)setPortraitUri:(NSString *)portraitUri{
    [super setPortraitUri:portraitUri];
    _headImg = portraitUri;
}

-(void)setName:(NSString *)name{
    [super setName:name];
    _displayName = name;
}

-(void)setPhoto:(NSString *)photo{
    _photo = photo;
    self.headImg = photo;
}


@end
