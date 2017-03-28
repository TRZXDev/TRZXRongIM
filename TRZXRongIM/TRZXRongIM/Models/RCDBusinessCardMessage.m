//
//  RCDBusinessCardMessage.m
//  TRZX
//
//  Created by 移动微 on 16/10/31.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDBusinessCardMessage.h"
#import <RongIMLib/RCUtilities.h>
#import <objc/runtime.h>
#import "RCDUserInfo.h"
#import "RCDCommonDefine.h"

#pragma mark – NSCoding protocol methods

@implementation RCDBusinessCardMessage

+(instancetype)messageWithContent:(NSString *)content andName:(NSString *)name portrait:(NSString *)portrait userId:(NSString *)userId{
    
    RCDBusinessCardMessage *message = [[RCDBusinessCardMessage alloc] init];
    if (message) {
        message.businessName = name;
        message.portrait = portrait;
        message.businessContent = content;
        message.userId = userId;
    }
    return message;
}
+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
            Ivar const ivar = *p;
            
            //获取变量名
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (const Ivar *p = ivars; p < ivars + outCount; ++p) {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}


#pragma mark - RCMessageCoding delegate methods
-(NSData *)encode{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.businessContent) {
        [dataDict setObject:self.businessContent forKey:@"businessContent"];
    }
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.businessName) {
        [dataDict setObject:self.businessName forKey:@"businessName"];
    }
    if (self.userId) {
        [dataDict setObject:self.userId forKey:@"userId"];
    }
    if (self.portrait) {
        [dataDict setObject:self.portrait forKey:@"portrait"];
    }
    
    if ([Login curLoginUser].userId) {
        NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];

        if([[Login curLoginUser] name]){
                [__dic setObject:[[Login curLoginUser] name] forKey:@"name"];
        }
        // 用户头像
//        if([[Login curLoginUser] head_img]){
//            [__dic setObject:[[Login curLoginUser] head_img] forKey:@"icon"];
//        }
        if([Login curLoginUser].userId){
            [__dic setObject:[Login curLoginUser].userId forKey:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data{
    __autoreleasing NSError *__error = nil;
    if (!data)return;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&__error];
    if (json[@"businessContent"]) {
        self.businessContent = json[@"businessContent"];
    }
    if (json[@"extra"]) {
        self.extra = json[@"extra"];
    }
    if (json[@"businessName"]) {
        self.businessName = json[@"businessName"];
    }
    if (json[@"userId"]) {
        self.userId = json[@"userId"];
    }
    if (json[@"portrait"]) {
        self.portrait = json[@"portrait"];
    }
    if (json[@"user"]) {
        RCDUserInfo *senderUser = [[RCDUserInfo alloc] init];
        NSDictionary *__dic = [json[@"user"] isKindOfClass:[NSDictionary class]]?json[@"user"]:[NSDictionary dictionary];
        if (__dic[@"name"]) {
            senderUser.name = __dic[@"name"];
        }
        if (__dic[@"icon"]) {
            senderUser.portraitUri = __dic[@"icon"];
        }
        if (__dic[@"id"]) {
            senderUser.userId = __dic[@"id"];
        }
        self.senderUserInfo = senderUser;
    }
}

-(NSString *)conversationDigest{
    NSString *string;
    string = self.businessName.length ? [NSString stringWithFormat:@"%@",self.businessName]:@"";
    

    if ([self.senderUserInfo.userId isEqualToString:[Login curLoginUser].userId]) {
        string = [NSString stringWithFormat:@"你推荐了%@",string];
    }else{
        string = [NSString stringWithFormat:@"向你推荐了%@",string];
    }
    return string;
}

+(NSString *)getObjectName{
    return RCBusinessCardMessageTypeIdentifier;
}

#if ! __has_feature(objc_arc)
-(void)dealloc{
    [super dealloc];
}

#endif //__has_feature(objc_arc)


@end
