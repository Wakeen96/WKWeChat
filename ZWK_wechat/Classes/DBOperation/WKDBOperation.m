//
//  WKDBOperation.m
//  ZWK_wechat
//
//  Created by 周维康 on 16/3/30.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "WKDBOperation.h"

@interface  WKDBOperation()

@property (strong, nonatomic)FMDatabase *messageDatabase;
@property (strong, nonatomic)FMDatabase *wechatDatabase;
@property (strong, nonatomic)FMResultSet *wechatResult;
@property (strong, nonatomic)FMResultSet *mineResult;

@end

@implementation WKDBOperation

//- (instancetype)init
//{
//    if (![super init])
//    {
//       for (char c = 'A'; c <= 'Z'; c++)
//       {
//           NSString *charString = [NSString stringWithFormat:@"%c",c];
//           NSMutableArray *array = [NSMutableArray array];
//           [self.capitalArray addObject:charString];
//           [self.capitalDic setObject:array forKey:charString];
//       }
//    }
//    return self;
//}

- (void)databaseOperation
{
    self.capitalArray = [NSMutableArray array];
    self.capitalDic = [NSMutableDictionary dictionary];
    for (char c = 'A'; c <= 'Z'; c++)
    {
        NSString *charString = [NSString stringWithFormat:@"%c",c];
        NSMutableArray *array = [NSMutableArray array];
        [self.capitalArray addObject:charString];
        [self.capitalDic setObject:array forKey:charString];
    }
    NSString *messageFilePath = @"/Users/zhouweikang/Documents/oc/ZWK_wechat/ZWK_wechat/Others/message.db";
    NSString *wechatFilePath = @"/Users/zhouweikang/Documents/oc/ZWK_wechat/ZWK_wechat/Others/wechat.db";
    self.messageDatabase = [FMDatabase databaseWithPath:messageFilePath];
    self.wechatDatabase = [FMDatabase databaseWithPath:wechatFilePath];
    [self.wechatDatabase open];
    [self.messageDatabase open];
    if (![self.messageDatabase open] || ![self.wechatDatabase open])
    {
        NSLog(@"数据库打开失败!");
    }
    self.friendNameArray = [NSMutableArray array];
    self.messageDic = [NSMutableDictionary dictionary];
    self.mineDic = [NSMutableDictionary dictionary];
    self.wechatResult = [self.wechatDatabase executeQuery:@"SELECT *FROM addressBook"];
    while ([self.wechatResult next]) {
        NSString *friendNameString = [self.wechatResult stringForColumn:@"friendName"];
        NSString *capitalString = [self.wechatResult stringForColumn:@"capital"];
        [self.capitalDic[capitalString] addObject:friendNameString];
        [self.friendNameArray addObject:friendNameString];
    }
    //    NSLog(@"%@",self.friendNameArray);
    for (int index=0; index<self.friendNameArray.count; index++)
    {
        NSString *messageString = [[NSString alloc] init];
        NSString *nameString = [[NSString alloc] init];
        nameString = [self.friendNameArray objectAtIndex:index];
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM '%@'",nameString];
        FMResultSet *messageResult = [self.messageDatabase executeQuery:sql];
        while ([messageResult next]) {
            messageString = [messageResult stringForColumn:@"message"];
        }
        [self.messageDic setObject:messageString forKey:nameString];
    }
    self.mineResult = [self.wechatDatabase executeQuery:@"SELECT *FROM Mine"];
    while ([self.mineResult next]) {
        NSString *nameString = [self.mineResult stringForColumn:@"name"];
        NSString *numberString = [self.mineResult stringForColumn:@"number"];
        NSString *sexString = [self.mineResult stringForColumn:@"sex"];
        NSString *signString = [self.mineResult stringForColumn:@"sign"];
        NSString *areaString = [self.mineResult stringForColumn:@"area"];
        [self.mineDic setObject:nameString forKey:@"name"];
        [self.mineDic setObject:numberString forKey:@"number"];
        [self.mineDic setObject:sexString forKey:@"sex"];
        [self.mineDic setObject:signString forKey:@"sign"];
        [self.mineDic setObject:areaString forKey:@"area"];
    }
    [self.wechatDatabase close];
    [self.messageDatabase close];
}

@end
