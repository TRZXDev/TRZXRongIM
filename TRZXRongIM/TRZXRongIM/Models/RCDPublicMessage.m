//
//  RCDPublicMessage.m
//  TRZX
//
//  Created by 移动微 on 16/11/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicMessage.h"
#import "RCDUserInfo.h"
#import <objc/runtime.h>
#import "RCDCommonDefine.h"

@implementation RCDPublicMessage
+(instancetype)messageWithName:(NSString *)name mid:(NSString *)mid photo:(NSString *)photo introduction:(NSString *)introduction{

    RCDPublicMessage *message = [[RCDPublicMessage alloc] init];
    if (message) {
        message.publicName = name;
        message.photo = photo;
        message.publicId = mid;
        message.introduction = introduction;
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
    if (self.publicName) {
        [dataDict setObject:self.publicName forKey:@"publicName"];
    }
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.publicId) {
        [dataDict setObject:self.publicId forKey:@"publicId"];
    }
    if (self.photo) {
        [dataDict setObject:self.photo forKey:@"photo"];
    }
    if(self.introduction){
        [dataDict setObject:self.introduction forKey:@"introduction"];
    }
    if ([Login curLoginUser].userId) {
        NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];
        
        if([Login curLoginUser].name){
            [__dic setObject:[Login curLoginUser].name forKey:@"name"];
        }
//        if([KPOUserDefaults head_img]){
//            [__dic setObject:[KPOUserDefaults head_img] forKey:@"icon"];
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
    if (json[@"publicName"]) {
        self.publicName = json[@"publicName"];
    }
    if (json[@"publicId"]) {
        self.publicId = json[@"publicId"];
    }
    if (json[@"extra"]) {
        self.extra = json[@"extra"];
    }
    if (json[@"photo"]) {
        self.photo = json[@"photo"];
    }
    if (json[@"introduction"]) {
        self.introduction = json[@"introduction"];
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
    string = self.publicName.length ? [NSString stringWithFormat:@"%@",self.publicName]:@"";

    if ([self.senderUserInfo.userId isEqualToString:[Login curLoginUser].userId]) {
        string = [NSString stringWithFormat:@"你推荐了%@",string];
    }else{
        string = [NSString stringWithFormat:@"向你推荐了%@",string];
    }
    return string;
}

+(NSString *)getObjectName{
    return RCPublicServiceMessageTypeIdentifier;
}

#if ! __has_feature(objc_arc)
-(void)dealloc{
    [super dealloc];
}

#endif //__has_feature(objc_arc)

@end
