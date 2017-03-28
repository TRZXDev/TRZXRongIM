//
//  RCDRedPacketsMessage.m
//  TRZX
//
//  Created by 移动微 on 16/11/3.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDRedPacketsMessage.h"
#import "RCDUserInfo.h"
#import <objc/runtime.h>

@implementation RCDRedPacketsMessage

+(instancetype)messageWithTitle:(NSString *)title content:(NSString *)content{
    
    RCDRedPacketsMessage *message = [[RCDRedPacketsMessage alloc] init];
    if (message) {
        message.title = title;
        message.content = content;
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
    if (self.title) {
        [dataDict setObject:self.title forKey:@"title"];
    }
    if (self.content) {
        [dataDict setObject:self.content forKey:@"content"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];
        if(self.senderUserInfo.name){
            [__dic setObject:self.senderUserInfo.name forKey:@"name"];
        }
        if(self.senderUserInfo.portraitUri){
            [__dic setObject:self.senderUserInfo.portraitUri forKey:@"icon"];
        }
        if(self.senderUserInfo.userId){
            [__dic setObject:self.senderUserInfo.userId forKey:@"id"];
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
    if (json[@"content"]) {
        self.content = json[@"content"];
    }
    if (json[@"title"]) {
        self.title = json[@"title"];
    }

    if (json[@"user"]) {
        RCDUserInfo *senderUser;
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
    NSString *string = self.title.length ? [NSString stringWithFormat:@"[投融红包]%@",self.title]:@"";
    return string;
}

+(NSString *)getObjectName{
    return RCDRedPacketsMessageTypeIdentifier;
}

#if ! __has_feature(objc_arc)
-(void)dealloc{
    [super dealloc];
}

#endif //__has_feature(objc_arc)

@end
