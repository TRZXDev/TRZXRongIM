//
//  DBHelper.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/5/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "RCDCommonDefine.h"

@implementation DBHelper

static FMDatabaseQueue *databaseQueue = nil;


+(FMDatabaseQueue *) getDatabaseQueue
{


    if ([Login curLoginUser].userId == nil) {
        return nil;
    }
    if (!databaseQueue) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];

        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"KipoUserData%@",[Login curLoginUser].userId]];
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    
    return databaseQueue;
}

+(void)tearDown{
    databaseQueue = nil;
}

+ (BOOL) isTableOK:(NSString *)tableName withDB:(FMDatabase *)db{
    BOOL isOK = NO;
    
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            isOK =  NO;
        }
        else
        {
            isOK = YES;
        }
    }
    [rs close];
    
    if (isOK && ([tableName isEqualToString:@"USERTABLE"] || [tableName isEqualToString:@"FRIENDTABLE"])) {
        FMResultSet *rs1 = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
        if (rs1.columnCount < 7) {
            [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",tableName]];
            isOK =  NO;
        }
        [rs1 close];
    }
    if (isOK && ([tableName isEqualToString:@"GROUPTABLEV2"])) {
        FMResultSet *rs1 = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
        NSLog(@"%d",rs1.columnCount);
        if (rs1.columnCount < 12) {
            [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",tableName]];
            isOK =  NO;
        }
        [rs1 close];
    }
    
    return isOK;
}

@end
