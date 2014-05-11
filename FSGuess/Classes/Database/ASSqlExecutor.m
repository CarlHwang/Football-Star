//
//  ASSqlExecutor.m
//  FSGuess
//
//  Created by CarlHwang on 13-10-6.
//  Copyright (c) 2013年 AfroStudio. All rights reserved.
//

#import "ASSqlExecutor.h"
#import "sqlite3.h"
#import "ASDatabaseMacros.h"

@interface ASSqlExecutor()
@property (nonatomic,assign) sqlite3 *database;
@property (nonatomic,copy) NSString *dbPath;
@end

@implementation ASSqlExecutor

static ASSqlExecutor *g_sqlExecutor = nil;
+(ASSqlExecutor *)getInstance{
    if (nil == g_sqlExecutor) {
        g_sqlExecutor = [[ASSqlExecutor alloc] init];
    }
    return g_sqlExecutor;
}

-(id)init{
    self = [super init];
    if (self) {
        [self initializeDBPath];
    }
    return self;
}

-(void)initializeDBPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sPath = [paths objectAtIndex:0];
    self.dbPath = [sPath stringByAppendingPathComponent:DB_NAME];
}

-(NSString *)databasePath{
    return _dbPath;
}

-(BOOL)openDatabase{
    if (sqlite3_open([[self databasePath] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        ASLogDB(@"数据库打开失败",nil);
        return NO;
    }
    return YES;
}

-(void)closeDatabase{
    sqlite3_close(_database);
}

#pragma mark 增、删、改
/*************
 sql:sql语句0
 param:sql语句中?对应的值组成的数组
 *************/
-(BOOL)execute:(NSString *)sql paramArray:(NSArray *)param{
    BOOL success = YES;
    if ([self openDatabase]) {
        sqlite3_stmt *statement = nil;
        int errorCode = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
        if (errorCode == SQLITE_OK) {
            id temp;
            for (int i = 0; i < [param count]; i++) {
                temp = [param objectAtIndex:i];
                if ([temp isKindOfClass:[NSNumber class]]) {
                    sqlite3_bind_int(statement, i+1, [temp intValue]);
                }else if ([temp isKindOfClass:[NSData class]]){
                    sqlite3_bind_blob(statement, i+1, [temp bytes], [temp length], SQLITE_TRANSIENT);
                }else{
                    sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
                }
            }
            ASLogDB(@"execute sqlite3_step start %f", [[NSDate date] timeIntervalSince1970]);
            errorCode = sqlite3_step(statement);
            ASLogDB(@"execute sqlite3_step end %f", [[NSDate date] timeIntervalSince1970]);
            if (errorCode == SQLITE_ERROR) {
                ASLogDB(@"Error: failed to execute sql:%@", sql);
                success = NO;
            }
        }else{
            ASLogDB(@"ERROR-failed to prepare, error-code:%d, sql%@",errorCode, sql);
            success = NO;
        }
        sqlite3_finalize(statement);
        [self closeDatabase];
    }else{
        success = NO;
    }
    ASLogDB(@"operation success? = %d",success);
    return success;
}

#pragma mark 插入多条
-(BOOL)multiInsert:(NSString *)sql paramArrays:(NSArray *)arrays{
    BOOL success = YES;
    if ([self openDatabase]) {
        sqlite3_stmt *statement = nil;
        int errorCode = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
        if (errorCode == SQLITE_OK) {
            sqlite3_exec(_database, "BEGIN;", 0, 0, NULL);
            id temp;
            NSArray *param;
            for (int iPos = 0; iPos < [arrays count]; iPos++) {
                param = [arrays objectAtIndex:iPos];
                for (int i = 0; i < [param count]; i++) {
                    temp = [param objectAtIndex:i];
                    if ([temp isKindOfClass:[NSNumber class]]) {
                        sqlite3_bind_int(statement, i+1, [temp intValue]);
                    }else if ([temp isKindOfClass:[NSData class]]){
                        sqlite3_bind_blob(statement, i+1, [temp bytes], [temp length], SQLITE_TRANSIENT);
                    }else{
                        sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
                    }
                }
                ASLogDB(@"multiInsert sqlite3_step start %f", [[NSDate date] timeIntervalSince1970]);
                errorCode = sqlite3_step(statement);
                ASLogDB(@"multiInsert sqlite3_step stop %f", [[NSDate date] timeIntervalSince1970]);
                if (success == SQLITE_ERROR) {
                    ASLogDB(@"Error: failed to execute sql:%@", sql);
                    success = NO;
                }
                sqlite3_reset(statement);
            }
            sqlite3_exec(_database, "COMMIT;", 0, 0, NULL);
        }else{
            ASLogDB(@"ERROR-failed to prepare, error-code:%d, sql%@",errorCode, sql);
            success = NO;
        }
        sqlite3_finalize(statement);
        [self closeDatabase];
    }else{
        success = NO;
    }
    return success;
}

#pragma mark 查询
/**************
 sql:sql语句
 col:sql语句需要操作的表的所有字段
 **************/
-(NSMutableArray *)select:(NSString *)sql columns:(NSArray *)cols{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    BOOL success = YES;
    if ([self openDatabase]) {
        sqlite3_stmt *statement = nil;
        int errorCode = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
        if (errorCode == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableArray *row = [[NSMutableArray alloc] init]; //一条记录
                NSNumber *value;
                for (int i = 0; i < [cols count]; i++) {
                    value = [cols objectAtIndex:i];
                    if ([value intValue] == DB_COLUMN_TYPE_INTEGER) {
                        [row addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, i)]];
                    }else if ([value intValue] == DB_COLUMN_TYPE_BLOB) {
                        NSUInteger blobLength = sqlite3_column_bytes(statement, i);
                        [row addObject:[NSData dataWithBytes:sqlite3_column_blob(statement, i) length:blobLength]];
                    }else{
                        [row addObject:[NSString stringWithFormat:@"%@", [NSString stringWithCString:(char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding]]];
                    }
                }
                [result addObject:row];
                [row release];
            }
        }else{
            ASLogDB(@"ERROR-failed to prepare, error-code:%d, sql%@",errorCode, sql);
            success = NO;
        }
        sqlite3_finalize(statement);
        [self closeDatabase];
    }else{
        success = NO;
    }
    
    if (!success) {
        [result release];
        return nil;
    }
    return [result autorelease];
}

@end
