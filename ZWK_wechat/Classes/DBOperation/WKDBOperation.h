//
//  WKDBOperation.h
//  ZWK_wechat
//
//  Created by 周维康 on 16/3/30.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface WKDBOperation : NSObject

@property (strong, nonatomic)NSMutableArray *friendNameArray;
@property (strong, nonatomic)NSMutableDictionary *messageDic;
@property (strong, nonatomic)NSMutableDictionary *capitalDic;
@property (strong, nonatomic)NSMutableArray *capitalArray;
@property (strong, nonatomic)NSMutableDictionary *mineDic;

- (void)databaseOperation;
//- (instancetype)WKinit;

@end
