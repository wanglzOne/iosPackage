//
//  FMUserInfo.m
//  JASSBijou
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 cdcyi. All rights reserved.
//

#import "FMUserInfo.h"

@implementation FMUserInfo

+(FMUserInfo*)greateTableOfFMWithTableName:(NSString *)tableName{
    FMUserInfo *useInfo = [[FMUserInfo alloc]init];
    //创建数据库对象
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",tableName]];
    //创建数据库
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    //设置缓存提高效率
    [database setShouldCacheStatements:YES];
    if([database open]){
        BOOL result = [database executeUpdate:@"CREATE TABLE IF NOT EXISTS NEW_LIST (ID integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, phone text NOT NULL);"];
        if (result){
            NSLog(@"%@",@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }
    useInfo.dataBase = database;
    [database close];
    return useInfo;
}

-(void)insertOfFMWithDataArray:(NSArray *)dataArr{
    if ([_dataBase open]) {
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger index, BOOL * _Nonnull stop) {
            NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO NEW_LIST(name,phone)VALUES('%@','%@')",dict[@"name"],dict[@"phone"]];
            BOOL res = [_dataBase executeUpdate:insertSql];
            if (res) {
                NSLog(@"插入成功");
            }
        }];
    }
    [_dataBase close];
}

-(void)deleteAllDataOfFMDB{
    if ([_dataBase open]) {
        //NSString *deleteSql = [NSString stringWithFormat:@"delete from t_student"];
        
        //BOOL res = [_dataBase executeUpdate:deleteSql];
        BOOL res = [_dataBase executeUpdate:@"DELETE FROM NEW_LIST"];
        if (!res) {
            NSLog(@"删除失败");
        } else {
            NSLog(@"删除成功");
        }
        [_dataBase close];
    }
    
}


//查询数据
-(NSArray *)queryAllDataOfFMDB{
    NSMutableArray *dataArr = [@[]mutableCopy];
    // 1.执行查询语句
    if ([_dataBase open]) {
        FMResultSet *resultSet = [_dataBase executeQuery:@"SELECT * FROM NEW_LIST"];
        // 2.遍历结果
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *phone =  [resultSet stringForColumn:@"phone"];
            NSDictionary *dict = @{@"name":name,@"phone":phone};
            [dataArr addObject:dict];
        }
    }
    [_dataBase close];
    return [dataArr copy];
}

//查询某一条数据,i为查询到的条数
-(NSDictionary*)queryOfOneData:(NSString*)name phone:(NSString*)phone{
    NSMutableArray *dataArr = [@[]mutableCopy];
    // 1.执行查询语句
    if ([_dataBase open]) {
        FMResultSet *resultSet = [_dataBase executeQuery:@"SELECT * FROM NEW_LIST"];
        // 2.遍历结果
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *phone =  [resultSet stringForColumn:@"phone"];
            NSDictionary *dict = @{@"name":name,@"phone":phone};
            [dataArr addObject:dict];
        }
    }
    int i = 0;
    NSMutableArray *resulet = [@[]mutableCopy];
    for (NSInteger index = 0; index < dataArr.count; index ++) {
        if ([name isEqualToString:dataArr[index][@"name"]] && [phone isEqualToString:dataArr[index][@"phone"]]) {
            i = i + 1;
            [resulet addObject:dataArr[index]];
        }
    }
    [_dataBase close];
    return @{@"item":[NSString stringWithFormat:@"%d",i],@"resulet":[resulet copy]};
    
}

//删除某一条数据

-(void)deleteOfOneData:(NSString *)phone{
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@='%@'",
                               @"NEW_LIST", @"phone", phone];
        BOOL res = [_dataBase executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
            NSLog(@"删除成功一条数据成功");
        }
        [_dataBase close];
    }
}

//修改
-(void)update:(NSString*)name phone:(NSString*)phone
{
    if ([_dataBase open]) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@='%@' where %@='%@'",@"NEW_LIST",@"phone",@"name",phone,name];
        BOOL res = [_dataBase executeUpdate:updateSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [_dataBase close];
    }
    
}


-(BOOL)isDataInTheTable{
    BOOL isHaveData = NO;
    // 1.执行查询语句
    if ([_dataBase open]) {
        FMResultSet *resultSet = [_dataBase executeQuery:@"SELECT * FROM NEW_LIST"];
        while ([resultSet next]) {
            isHaveData = YES;
        }
    }
    [_dataBase close];
    return isHaveData;

}


@end
