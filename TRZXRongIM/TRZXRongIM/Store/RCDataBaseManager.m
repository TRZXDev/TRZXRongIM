//
//  RCDataBaseManager.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/6/3.
//  Copyright (c) 2015年 dlz. All rights reserved.
//

#import "RCDataBaseManager.h"
#import "RCDLoginInfo.h"
#import "RCDGroupInfo.h"
#import "RCDUserInfo.h"
#import "RCDHttpTool.h"
#import "DBHelper.h"
#import "RCDCommonDefine.h"

@implementation RCDataBaseManager

NSString * const RCDUmengNotification = @"receiveUmengNotification";
NSString * const RCDCommentCircleNotification = @"RCDCommentCircleNotification";
NSString * const RCDFriendCircleNotification = @"RCDFriendCircleNotification";
NSString * const RCDGroupRefreshNotification = @"RCDGroupRefreshNotification";
NSString * const RCDDeleteFriendNotification = @"RCDDeleteFriendNotification";
NSString * const RCDRefreshAuthKey = @"refreshAuth";
NSString * const RCDAddFriendKey = @"addFriend";
NSString * const RCDCommentCircleKey = @"commentCircle";
NSString * const RCDFriendCircleKey = @"firendCircle";
NSString * const RCDGroupNameChangeKey = @"groupNameChange";
NSString * const RCDDeleteFriendKey = @"deleteFriend";


static NSString * const userTableName = @"USERTABLE";
static NSString * const groupTableName = @"GROUPTABLEV2";
static NSString * const friendTableName = @"FRIENDTABLE";
static NSString * const blackTableName = @"BLACKTABLE";
static NSString * const userToken = @"USERTOKEN";
static NSString * const msgTableFlag = @"MSGFLAG";
static NSString * const voiceTableMessageId = @"VOICETABLE";
static NSString * const questionVoice = @"QUESTIONVOICETABLE";
static NSString * const addFriendMessage = @"ADDFRIENDMESSAGE";
//static NSString * const groupInfo = @"GROUPINFO";

static RCDataBaseManager* instance = nil;
static dispatch_once_t predicate;
+ (RCDataBaseManager*)shareInstance
{
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    
    [instance CreateUserTable];
    
    return instance;
}

+(void)tearDown{
    
    instance.isCreate = NO;
    
    instance=nil;
    
    predicate=0;
    
    [DBHelper tearDown];
    
}

//创建用户存储表
-(void)CreateUserTable{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    
    if (self.isCreate) {
        return;
    }
    self.isCreate = YES;
    
    [queue inDatabase:^(FMDatabase *db) {
        if (![DBHelper isTableOK: userTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text, position text, company text, isAlso text, userType text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![DBHelper isTableOK: groupTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE GROUPTABLEV2 (id integer PRIMARY KEY autoincrement, groupId text,name text, portraitUri text,inNumber text,maxNumber text ,introduce text ,creatorId text,creatorTime text, isJoin text, groupHeadData BINARY, inName text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_groupid ON GROUPTABLEV2(groupId);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![DBHelper isTableOK: friendTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE FRIENDTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text, position text, company text, isAlso text, userType text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_friendId ON FRIENDTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![DBHelper isTableOK: blackTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE BLACKTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_blackId ON BLACKTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![DBHelper isTableOK: msgTableFlag withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE MSGTAHLEFLAG (id integer PRIMARY KEY autoincrement, msgTableId text , VVRoadShow text,VVCourse text, Student text, OTOMeet text , Expert text , Topic text , Auth text , Guide text,Strategy text ,Menu text , Wallet text , Message text,y110 text,y109 text,y101 text,y100 text,y122 text,y114 text,y118 text,y117 text,y115 text, y116 text , y124 text , y126 text, MyQA text, y128 text, y129 text , y130 text, y131 text , y132 text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_msgTableId ON MSGTAHLEFLAG(msgTableId);";
            [db executeUpdate:createIndexSQL];
        }
        
        //为了记录 语音消息 2.6.2 暂时怎么写
        if (![DBHelper isTableOK: voiceTableMessageId withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE VOICETABLE (id integer PRIMARY KEY autoincrement, userid text,messageId text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_blackId ON BLACKTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        //问答数据 音频
        if (![DBHelper isTableOK: questionVoice withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE QUESTIONVOICETABLE (id integer PRIMARY KEY autoincrement, questionVoiceId text,questionVoicePath text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_voiceID ON QUESTIONVOICETABLE(questionViceId);";
            [db executeUpdate:createIndexSQL];
        }
        
        //添加的好友列表
        if (![DBHelper isTableOK: addFriendMessage withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE ADDFRIENDMESSAGE (id integer PRIMARY KEY autoincrement, messageId text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_messageId ON ADDFRIENDMESSAGE(messageId);";
            [db executeUpdate:createIndexSQL];
        }
    }];
}

#pragma mark - USERTABLE
//存储用户信息
-(void)insertUserToDB:(RCDUserInfo*)user{
    NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri, position, company, isAlso, userType) VALUES (?, ?, ?, ?, ?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:user.userId name:user.name portrait:user.portraitUri];
//    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userId,user.name,user.portraitUri,user.position,user.company,user.isAlso,user.userType];
    }];
}

//从表中获取用户信息
-(RCDUserInfo*) getUserByUserId:(NSString*)userId{
    __block RCDUserInfo *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return nil;
    }
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?",userId];
        while ([rs next]) {
            model = [[RCDUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.position = [rs stringForColumn:@"position"];
            model.company = [rs stringForColumn:@"company"];
            model.isAlso = [rs stringForColumn:@"isAlso"];
            model.userType = [rs stringForColumn:@"userType"];
        }
        [rs close];
    }];
    return model;
}

//从表中获取所有用户信息
-(NSArray *) getAllUserInfo{
    NSMutableArray *allUsers = [NSMutableArray new];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE"];
        while ([rs next]) {
            RCDUserInfo *model = [[RCDUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.position = [rs stringForColumn:@"position"];
            model.company = [rs stringForColumn:@"company"];
            model.isAlso = [rs stringForColumn:@"isAlso"];
            model.userType = [rs stringForColumn:@"userType"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

//插入添加好友列表消息
-(void)insertAddFriendMessageToDB:(NSString *)message{
    NSString *insertSql = @"REPLACE INTO ADDFRIENDMESSAGE (messageId) VALUES (?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,message];
    }];
}

#pragma mark - GROUPTABLEV2
//删除群组信息
-(void)deleteGroupInfoWithId:(NSString *)groupId{
    NSString *deleteSql =[NSString stringWithFormat: @"DELETE FROM GROUPTABLEV2 WHERE groupId='%@'",groupId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//存储群组信息
-(void)insertGroupToDB:(RCDGroupInfo *)group{
    if(group == nil || [group.groupId length]<1)
        return;
    if (group.groupHeadData == nil) {
        group.groupHeadData = [self getGroupByGroupId:group.groupId].groupHeadData;
    }
    NSString *insertSql = @"REPLACE INTO GROUPTABLEV2 (groupId, name,portraitUri,inNumber,maxNumber,introduce,creatorId,creatorTime,isJoin,groupHeadData,inName) VALUES (?,?,?,?,?,?,?,?,?,?,?)";

    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,group.groupId, group.name,group.portraitUri,group.number,group.maxNumber,group.introduce,group.creatorId,group.creatorTime,[NSString stringWithFormat:@"%d",group.isJoin],group.groupHeadData,group.inName];
    }];
}
////插入群组头像
-(void)insertGroupHeaderIconToDB:(NSString *)groupId data:(NSData *)data{
    
    RCDGroupInfo *group = [self getGroupByGroupId:groupId];
    group.groupHeadData = data;
    
    NSString *insertSql = @"REPLACE INTO GROUPTABLEV2 (groupId, name,portraitUri,inNumber,maxNumber,introduce,creatorId,creatorTime,isJoin,groupHeadData,inName) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,group.groupId, group.name,group.portraitUri,group.number,group.maxNumber,group.introduce,group.creatorId,group.creatorTime,[NSString stringWithFormat:@"%d",group.isJoin],group.groupHeadData,group.inName];
    }];
}


//清空群组缓存数据
-(void)clearGroupsData{
    NSString *deleteSql = @"DELETE FROM GROUPTABLEV2";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//从表中获取群组信息
-(RCDGroupInfo*) getGroupByGroupId:(NSString*)groupId{
    __block RCDGroupInfo *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLEV2 where groupId = ?",groupId];
        while ([rs next]) {
            model = [[RCDGroupInfo alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"name"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.number=[rs stringForColumn:@"inNumber"];
            model.maxNumber=[rs stringForColumn:@"maxNumber"];
            model.introduce=[rs stringForColumn:@"introduce"];
            model.creatorId=[rs stringForColumn:@"creatorId"];
            model.creatorTime=[rs stringForColumn:@"creatorTime"];
            model.isJoin=[rs boolForColumn:@"isJoin"];
            model.groupHeadData = [rs dataForColumn:@"groupHeadData"];
            model.inName = [rs stringForColumn:@"inName"];
        }
        [rs close];
    }];
    return model;
}

//从表中获取所有群组信息
-(NSArray *) getAllGroup{
    NSMutableArray *allUsers = [NSMutableArray new];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLEV2 ORDER BY groupId"];
        while ([rs next]) {
            RCDGroupInfo *model;
            model = [[RCDGroupInfo alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.number=[rs stringForColumn:@"inNumber"];
            model.maxNumber=[rs stringForColumn:@"maxNumber"];
            model.introduce=[rs stringForColumn:@"introduce"];
            model.creatorId=[rs stringForColumn:@"creatorId"];
            model.creatorTime=[rs stringForColumn:@"creatorTime"];
            model.isJoin=[rs boolForColumn:@"isJoin"];
            model.groupHeadData = [rs dataForColumn:@"groupHeadData"];
            model.inName = [rs stringForColumn:@"inName"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

#pragma mark - ADDFRIENDMESSAGE
//获取全部添加好友消息数量
-(NSInteger)getAddFriendMessageCount{
    NSMutableArray *allAddFriendMessage = [NSMutableArray array];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM ADDFRIENDMESSAGE"];
        while ([rs next]) {
            NSString *message = [rs stringForColumn:@"messageId"];
            [allAddFriendMessage addObject:message];
        }
        [rs close];
    }];
    return allAddFriendMessage.count;
}
//删除添加好友列表消息
-(void)deleteAddFriendMessage:(NSString *)message{

    NSString *deleteSql =[NSString stringWithFormat: @"DELETE FROM ADDFRIENDMESSAGE WHERE messageId='%@'",message];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}
//清空添加好友消息数据
-(void)clearAddFriendMessage{
    NSString *deleteSql = @"DELETE FROM ADDFRIENDMESSAGE";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

#pragma mark - BLACKTABLE
//获取黑名单列表
- (NSArray *)getBlackList{
    NSMutableArray *allBlackList = [NSMutableArray new];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM BLACKTABLE"];
        while ([rs next]) {
            RCDUserInfo *model;
            model = [[RCDUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allBlackList addObject:model];
        }
        [rs close];
    }];
    return allBlackList;
}

//移除黑名单
- (void)removeBlackList:(NSString *)userId{
    NSString *deleteSql =[NSString stringWithFormat: @"DELETE FROM BLACKTABLE WHERE userid='%@'",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//清空黑名单缓存数据
-(void)clearBlackListData{
    NSString *deleteSql = @"DELETE FROM BLACKTABLE";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//插入黑名单列表
-(void)insertBlackListToDB:(RCDUserInfo *)user{
    NSString *insertSql = @"REPLACE INTO BLACKTABLE (userid, name, portraitUri, position, company, isAlso, userType) VALUES (?, ?, ?, ?, ?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userId,user.name,user.portraitUri,user.position,user.company,user.isAlso,user.userType];
    }];
}

#pragma mark - FRIENDTABLE
//存储好友信息
-(void)insertFriendToDB:(RCDUserInfo *)friend{
    NSString *insertSql = @"REPLACE INTO FRIENDTABLE (userid, name, portraitUri, position, company, isAlso, userType) VALUES (?, ?, ?, ?, ?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,friend.userId, friend.name, friend.portraitUri, friend.position,friend.company, friend.isAlso, friend.userType];
    }];
}

/**
 获取好友信息
 */
-(RCDUserInfo*) getFriendByUserId:(NSString*)userId{
    __block RCDUserInfo *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return nil;
    }
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM FRIENDTABLE where userid = ?",userId];
        while ([rs next]) {
            model = [[RCDUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.position = [rs stringForColumn:@"position"];
            model.company = [rs stringForColumn:@"company"];
            model.isAlso = [rs stringForColumn:@"isAlso"];
            model.userType = [rs stringForColumn:@"userType"];
        }
        [rs close];
    }];
    return model;
}

//从表中获取所有好友信息 
-(NSArray *) getAllFriends{
    NSMutableArray *allUsers = [NSMutableArray new];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM FRIENDTABLE"];
        while ([rs next]) {
            RCDUserInfo *model = [[RCDUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.position = [rs stringForColumn:@"position"];
            model.company = [rs stringForColumn:@"company"];
            model.isAlso = [rs stringForColumn:@"isAlso"];
            model.userType = [rs stringForColumn:@"userType"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

//清空好友缓存数据
-(void)clearFriendsData{
    NSString *deleteSql = @"DELETE FROM FRIENDTABLE";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

// 删除好友
-(void)deleteFriendFromDB:(NSString *)userId{
    
    NSString *deleteSql =[NSString stringWithFormat: @"DELETE FROM FRIENDTABLE WHERE userid= '%@'",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

#pragma mark - MSGTAHLEFLAG
//存储 msgFlag
-(void)insertMsgFlag:(NSString *)msgFlagStr{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *updataSQL = [NSString stringWithFormat:@"INSERT INTO MSGTAHLEFLAG (%@, msgTableId) VALUES (?,?)",msgFlagStr];
        
        if ([db executeUpdate:updataSQL,@"1",[Login curLoginUser].userId]) {

        }
    }];
}

///  便利存储 Msg Flag
///  @param msgFlagStr msg字符串
-(void)saveMsgFlag:(NSString *)msgFlagStr{
    [self queryMsgFlag:msgFlagStr]?
    [self updateMsgFlag:msgFlagStr]:
    [self insertMsgFlag:msgFlagStr];

    // 身份判断
//    if ([msgFlagStr isEqualToString:@"MyTeam"] && [KPOUserDefaults currentSessionUserTypeIsAllOperator]){
//        [self queryMsgFlag:@"y130"]?
//        [self updateMsgFlag:@"y130"]:
//        [self insertMsgFlag:@"y130"];
//    }else if ([msgFlagStr isEqualToString:@"MyCustomer"] && [KPOUserDefaults currentSessionUserTypeIsAllOperator]){
//        [self queryMsgFlag:@"y129"]?
//        [self updateMsgFlag:@"y129"]:
//        [self insertMsgFlag:@"y129"];
//    }
}

/// 成为合伙人钱包改变
-(void)OperatorWalletChange{
    // 身份判断
//    if ([KPOUserDefaults currentSessionUserTypeIsAllOperator]) {
//        [self queryMsgFlag:@"y131"]?
//        [self updateMsgFlag:@"y131"]:
//        [self insertMsgFlag:@"y131"];
//    }
}

/**
 *  更新 内容
 *
 *  @param msgFlagStr
 */
-(void)updateMsgFlag:(NSString *)msgFlagStr{
    
    NSString *insertSql = [NSString stringWithFormat:@"UPDATE MSGTAHLEFLAG SET %@ = ? WHERE msgTableId = ?",msgFlagStr];
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:insertSql,@"1",[Login curLoginUser].userId];
    }];
}



//删除
-(void)removeMsgFlag:(msgFlagType)msgFlagType{

    NSString *msgFlagStr = nil;
    
    switch (msgFlagType) {
        case msgFlagTypeVVRoadShow:
            msgFlagStr = @"VVRoadShow";
            break;
        case msgFlagTypeVVCourse:
            msgFlagStr = @"VVCourse";
            break;
        case msgFlagTypeStudent:
            msgFlagStr = @"Student";
            break;
        case msgFlagTypeOTOMeet:
            msgFlagStr = @"OTOMeet";
            break;
        case msgFlagTypeExpert:
            msgFlagStr = @"Expert";
            break;
        case msgFlagTypeTopic:
            msgFlagStr = @"Topic";
            break;
        case msgFlagTypeAuth:
            msgFlagStr = @"Auth";
            break;
        case msgFlagTypeMenu:
            msgFlagStr = @"Menu";
            break;
        case msgFlagTypeWallet:
            msgFlagStr = @"Wallet";
            break;
        case msgFlagTypeMessage:
            msgFlagStr = @"Message";
            break;
        case msgFlagTypeGuide:
            msgFlagStr = @"Guide";
            break;
        case msgFlagTypeStrategy:
            msgFlagStr = @"Strategy";
            break;
        case msgFlagTypey110:
            msgFlagStr = @"y110";
            break;
        case msgFlagTypey109:
            msgFlagStr = @"y109";
            break;
        case msgFlagTypey101:
            msgFlagStr = @"y101";
            break;
        case msgFlagTypey100:
            msgFlagStr = @"y100";
            break;
        case msgFlagTypey122:
            msgFlagStr = @"y122";
            break;
        case msgFlagTypey114:
            msgFlagStr = @"y114";
            break;
        case msgFlagTypey118:
            msgFlagStr = @"y118";
            break;
//        case msgFlagTypey117: //个人相册
//            msgFlagStr = @"y117";
//            break;
        case msgFlagTypey115:
            msgFlagStr = @"y115";
            break;
        case msgFlagTypey116:
            msgFlagStr = @"y116";
            break;
        case msgFlagTypey124:
            msgFlagStr = @"y124";
            break;
        case msgFlagTypey126:
            msgFlagStr = @"y126";
            break;
        case msgFlagTypeMyQA:
            msgFlagStr = @"MyQA";
            break;
        case msgFlagTypey128:
            msgFlagStr = @"y128";
            break;
        case msgFlagTypey129:
            msgFlagStr = @"y129";
            break;
        case msgFlagTypey130:
            msgFlagStr = @"y130";
            break;
        case msgFlagTypey131:
            msgFlagStr = @"y131";
            break;
        case msgFlagTypey132:
            msgFlagStr = @"y132";
            break;
        default:
            break;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"UPDATE MSGTAHLEFLAG SET %@ = ? WHERE msgTableId = ?",msgFlagStr];
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {

        [db executeUpdate:insertSql,@"0",[Login curLoginUser].userId];
    }];
}

-(void)saveSpecialMsgFlag:(msgFlagType)msgFlagType{
    
    NSString *msgFlagStr = nil;
    
    switch (msgFlagType) {
        case msgFlagTypeVVRoadShow:
            msgFlagStr = @"VVRoadShow";
            break;
        case msgFlagTypeVVCourse:
            msgFlagStr = @"VVCourse";
            break;
        case msgFlagTypeStudent:
            msgFlagStr = @"Student";
            break;
        case msgFlagTypeOTOMeet:
            msgFlagStr = @"OTOMeet";
            break;
        case msgFlagTypeExpert:
            msgFlagStr = @"Expert";
            break;
        case msgFlagTypeTopic:
            msgFlagStr = @"Topic";
            break;
        case msgFlagTypeAuth:
            msgFlagStr = @"Auth";
            break;
        case msgFlagTypeMenu:
            msgFlagStr = @"Menu";
            break;
        case msgFlagTypeWallet:
            msgFlagStr = @"Wallet";
            break;
        case msgFlagTypeMessage:
            msgFlagStr = @"Message";
            break;
        case msgFlagTypeGuide:
            msgFlagStr = @"Guide";
            break;
        case msgFlagTypeStrategy:
            msgFlagStr = @"Strategy";
            break;
        case msgFlagTypey110:
            msgFlagStr = @"y110";
            break;
        case msgFlagTypey109:
            msgFlagStr = @"y109";
            break;
        case msgFlagTypey101:
            msgFlagStr = @"y101";
            break;
        case msgFlagTypey100:
            msgFlagStr = @"y100";
            break;
        case msgFlagTypey122:
            msgFlagStr = @"y122";
            break;
        case msgFlagTypey114:
            msgFlagStr = @"y114";
            break;
        case msgFlagTypey118:
            msgFlagStr = @"y118";
            break;
        case msgFlagTypey115:
            msgFlagStr = @"y115";
            break;
        case msgFlagTypey116:
            msgFlagStr = @"y116";
            break;
        case msgFlagTypey124:
            msgFlagStr = @"y124";
            break;
        case msgFlagTypey126:
            msgFlagStr = @"y126";
            break;
        case msgFlagTypeMyQA:
            msgFlagStr = @"MyQA";
            break;
        case msgFlagTypey128:
            msgFlagStr = @"y128";
            break;
        case msgFlagTypey129:
            msgFlagStr = @"y129";
            break;
        case msgFlagTypey130:
            msgFlagStr = @"y130";
            break;
        case msgFlagTypey131:
            msgFlagStr = @"y131";
            break;
        case msgFlagTypey132:
            msgFlagStr = @"y132";
            break;
        default:
            break;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"UPDATE MSGTAHLEFLAG SET %@ = ? WHERE msgTableId = ?",msgFlagStr];
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,@"2",[Login curLoginUser].userId];
    }];
}


//获取
-(BOOL)getMsgFlag:(msgFlagType)msgFlagType{
    
    __block NSString *msgFlagStr = nil;
    
    switch (msgFlagType) {
        case msgFlagTypeVVRoadShow:
            msgFlagStr = @"VVRoadShow";
            break;
        case msgFlagTypeVVCourse:
            msgFlagStr = @"VVCourse";
            break;
        case msgFlagTypeStudent:
            msgFlagStr = @"Student";
            break;
        case msgFlagTypeOTOMeet:
            msgFlagStr = @"OTOMeet";
            break;
        case msgFlagTypeExpert:
            msgFlagStr = @"Expert";
            break;
        case msgFlagTypeTopic:
            msgFlagStr = @"Topic";
            break;
        case msgFlagTypeAuth:
            msgFlagStr = @"Auth";
            break;
        case msgFlagTypeMenu:
            msgFlagStr = @"Menu";
            break;
        case msgFlagTypeWallet:
            msgFlagStr = @"Wallet";
            break;
        case msgFlagTypeMessage:
            msgFlagStr = @"Message";
            break;
        case msgFlagTypeGuide:
            msgFlagStr = @"Guide";
            break;
        case msgFlagTypeStrategy:
            msgFlagStr = @"Strategy";
            break;
        case msgFlagTypey110:
            msgFlagStr = @"y110";
            break;
        case msgFlagTypey109:
            msgFlagStr = @"y109";
            break;
        case msgFlagTypey101:
            msgFlagStr = @"y101";
            break;
        case msgFlagTypey100:
            msgFlagStr = @"y100";
            break;
        case msgFlagTypey122:
            msgFlagStr = @"y122";
            break;
        case msgFlagTypey114:
            msgFlagStr = @"y114";
            break;
        case msgFlagTypey118:
            msgFlagStr = @"y118";
            break;
//        case msgFlagTypey117: // 个人相册
//            msgFlagStr = @"y117";
//            break;
        case msgFlagTypey115:
            msgFlagStr = @"y115";
            break;
        case msgFlagTypey116:
            msgFlagStr = @"y116";
            break;
        case msgFlagTypey124:
            msgFlagStr = @"y124";
            break;
        case msgFlagTypey126:
            msgFlagStr = @"y126";
            break;
        case msgFlagTypeMyQA:
            msgFlagStr = @"MyQA";
            break;
        case msgFlagTypey128:
            msgFlagStr = @"y128";
            break;
        case msgFlagTypey129:
            msgFlagStr = @"y129";
            break;
        case msgFlagTypey130:
            msgFlagStr = @"y130";
            break;
        case msgFlagTypey131:
            msgFlagStr = @"y131";
            break;
        case msgFlagTypey132:
            msgFlagStr = @"y132";
            break;
        default:
            break;
    }
    __block BOOL mesFlagBool = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return mesFlagBool;
    }
    [queue inDatabase:^(FMDatabase *db) {

        FMResultSet *rs = [db executeQuery:@"SELECT * FROM MSGTAHLEFLAG where msgTableId = ?",[Login curLoginUser].userId];
        while ([rs next]) {
            NSString *str = [rs stringForColumn:msgFlagStr];
            if (str.intValue) {
                mesFlagBool = YES;
            }
        }
        [rs close];
    }];
    
    return mesFlagBool;
}

///  获取消息数量
///  @return 获取消息数
-(int)getMsgFlagNumber{
    
    NSArray *msgFlags = @[@"VVRoadShow",@"VVCourse",@"Student",@"OTOMeet",@"Expert",@"Topic",@"Auth",@"Wallet",@"Guide",@"Strategy",@"y110",@"y109",@"y101",@"y100",@"y122",@"y114",@"y118",@"y115",@"y116",@"y124",@"y126",@"MyQA",@"y128",@"y129",@"y130",@"y131",@"y132"];
    
    __block int msgFlagCount = 0;
    for (NSString *msgFlagStr in msgFlags) {
        FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
        if (queue==nil) {
            return 0;
        }
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM MSGTAHLEFLAG where msgTableId = ?",[Login curLoginUser].userId];
            while ([rs next]) {
                NSString *str = [rs stringForColumn:msgFlagStr];
                if (str.intValue == 2) {
                    msgFlagCount++;
                }
            }
            [rs close];
        }];
    }
    
    return msgFlagCount;
}

///  删除所有的msgFlag
-(void)removeAllMsgFlag{
    
    NSArray *msgFlags = @[@"VVRoadShow",@"VVCourse",@"Student",@"OTOMeet",@"Expert",@"Topic",@"Auth",@"y110",@"y109",@"y101",@"y100",@"y122",@"y114",@"y118",@"y115",@"y116",@"y124",@"y126",@"MyQA",@"y128",@"y129",@"y130",@"y131",@"y132"];
    
    for (NSString *msgFlagStr in msgFlags) {
        if([self queryMsgFlag:msgFlagStr]){
            NSString *insertSql = [NSString stringWithFormat:@"UPDATE MSGTAHLEFLAG SET %@ = ? WHERE msgTableId = ?",msgFlagStr];
            
            FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
            
            [queue inDatabase:^(FMDatabase *db) {
    
                [db executeUpdate:insertSql,@"0",[Login curLoginUser].userId];
            }];
        }else{
            FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
            
            [queue inDatabase:^(FMDatabase *db) {
                NSString *updataSQL = [NSString stringWithFormat:@"INSERT INTO MSGTAHLEFLAG (%@, msgTableId) VALUES (?,?)",msgFlagStr];

                if ([db executeUpdate:updataSQL,@"0",[Login curLoginUser].userId]) {
                    
                }
            }];
        }
    }
}

//查询
-(BOOL)queryMsgFlag:(NSString *)msgFlag{
    
    __block BOOL mesFlagBool = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return mesFlagBool;
    }
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM MSGTAHLEFLAG where msgTableId = ?",[Login curLoginUser].userId];
        while ([rs next]) {
            mesFlagBool = YES;
        }
        [rs close];
    }];
    
    return mesFlagBool;
}

#pragma mark - VOICETABLE
-(void)insertVoiceRecordMessageId:(NSString *)messageId{
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *updataSQL = [NSString stringWithFormat:@"INSERT INTO VOICETABLE (messageId, userid) VALUES (?,?)"];
    
        if ([db executeUpdate:updataSQL,messageId,[Login curLoginUser].userId]) {
            
        }
    }];
}

-(BOOL)getVoiceRecordMessageId:(NSString *)messageId{

    __block BOOL mesFlagBool = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return mesFlagBool;
    }
    [queue inDatabase:^(FMDatabase *db) {
         
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM VOICETABLE where userid = ?",[Login curLoginUser].userId];
        while ([rs next]) {
            if ([[rs stringForColumn:@"messageId"] isEqualToString:messageId]) {
                mesFlagBool = YES;
            }
        }
        [rs close];
    }];
    
    return mesFlagBool;
}


#pragma mark - QUESTIONVOICETABLE
///  保存问答语音路径
-(void)insertQuestionVoiceId:(NSString *)voiceId voicePath:(NSString *)voicePath{

    
    NSString *insertSql = @"INSERT INTO QUESTIONVOICETABLE (questionVoiceId, questionVoicePath) VALUES (?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:insertSql,voiceId,voicePath]) {
            
        }
    }];
}
///  获取问答语音路径
///  @param VoiceId 问答语音id
///  @return 问答语音语音路径
-(NSString *)getQuestionVoiceId:(NSString *)VoiceId{
    
    __block NSString *voicePath = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return nil;
    }
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM QUESTIONVOICETABLE where questionVoiceId = ?",VoiceId];
        while ([rs next]) {
            NSString *str = [rs stringForColumn:@"questionVoicePath"];
            if (str != nil) {
                voicePath = str;
            }
        }
        [rs close];
    }];
    
    return voicePath;

}

@end
