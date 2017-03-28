//
//  RCDCollectionMessage.m
//  TRZX
//
//  Created by 移动微 on 16/11/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDCollectionMessage.h"
#import "RCDUserInfo.h"
#import <objc/runtime.h>
#import "RCDCommonDefine.h"

@implementation RCDCollectionMessage

+(instancetype)messageWithTitle:(NSString *)title content:(NSString *)content picture:(NSString *)picture collectionType:(NSString *)collectionType mid:(NSString *)mid{
    RCDCollectionMessage *message = [[RCDCollectionMessage alloc] init];
    if (message) {
        message.collectionTitle = title;
        message.collectionPicture = picture;
        message.collectionContent = content;
        message.collectionType = collectionType;
        message.collectionId = mid;
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
    if (self.collectionTitle) {
        [dataDict setObject:self.collectionTitle forKey:@"collectionTitle"];
    }
    if (self.collectionContent) {
        [dataDict setObject:self.collectionContent forKey:@"collectionContent"];
    }
    if (self.collectionId) {
        [dataDict setObject:self.collectionId forKey:@"collectionId"];
    }
    if (self.collectionType) {
        [dataDict setObject:self.collectionType forKey:@"collectionType"];
    }
    if (self.collectionPicture) {
        [dataDict setObject:self.collectionPicture forKey:@"collectionPicture"];
    }
    
    if ([Login curLoginUser].userId) {
    
    NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];
    if([Login curLoginUser].name){
        [__dic setObject:[Login curLoginUser].name forKey:@"name"];
    }
        // 用户头像
//    if([KPOUserDefaults head_img]){
//        [__dic setObject:[KPOUserDefaults head_img] forKey:@"icon"];
//    }
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
    if (json[@"collectionContent"]) {
        self.collectionContent = json[@"collectionContent"];
    }
    if (json[@"collectionTitle"]) {
        self.collectionTitle = json[@"collectionTitle"];
    }
    if (json[@"collectionPicture"]) {
        self.collectionPicture = json[@"collectionPicture"];
    }
    if (json[@"collectionType"]) {
        self.collectionType = json[@"collectionType"];
    }
    if (json[@"collectionId"]) {
        self.collectionId = json[@"collectionId"];
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
    
//    NSString *collectionType = self.collectionType;
//    if ([collectionType isEqualToString:@"online"] ||
//        [collectionType isEqualToString:@"course"]) {
//        self.collectionTitle.length ? [NSString stringWithFormat:@"%@",self.collectionTitle]:@"";
//    } else if ([collectionType isEqualToString:@"otoSchool"]) {
//        
//    } else if ([collectionType isEqualToString:@"video"]||
//               [collectionType isEqualToString:@"live"]) {//直播
//        
//        
//    }else if ([collectionType isEqualToString:@"project"]) {
//        self.collectionTitle.length ? [NSString stringWithFormat:@"项目%@",self.collectionTitle]:@"";
//    }else if ([collectionType isEqualToString:@"investor"]||
//              [collectionType isEqualToString:@"investorHome"]) {
//    }else if([collectionType isEqualToString:@"userHome"]){
//        
//    }else if([collectionType isEqualToString:@"bp"]){
//        
//    }else{
        NSString *string = self.collectionTitle.length ? [NSString stringWithFormat:@"%@",self.collectionTitle]:@"";
//    }
    return [NSString stringWithFormat:@"[链接]%@",string];
}

+(NSString *)getObjectName{
    return RCCollectionMessageTypeIdentifier;
}

#if ! __has_feature(objc_arc)
-(void)dealloc{
    [super dealloc];
}

#endif //__has_feature(objc_arc)


@end
