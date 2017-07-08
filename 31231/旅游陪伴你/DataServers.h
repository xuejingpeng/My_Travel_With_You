//
//  DataServers.h
//  NetWorkDriveData
//
//  Created by Administrator on 15/8/20.
//  Copyright (c) 2015年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataServers : NSObject

- (void)gainTrainInfo:(NSMutableDictionary *)dic andBlock:(void(^)(NSDictionary * resultDic))returnDic;
//异步请求
- (void)gainData:(NSString *)urlStr andBlock:(void(^)(NSDictionary * resultDic))returnDic;
//同步请求
- (void)gainSynchronizationData:(NSString *)urlStr andBlock:(void(^)(NSDictionary * resultDic))returnDic;
- (void)gainTrainDeInfo:(NSString *)urlStr andBlock:(void(^)(NSDictionary * resultDic))returnDic;
@end
