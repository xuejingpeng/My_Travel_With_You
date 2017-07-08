//
//  DataServers.m
//  NetWorkDriveData
//
//  Created by Administrator on 15/8/20.
//  Copyright (c) 2015年 Administrator. All rights reserved.
//

#import "DataServers.h"

@implementation DataServers

//查火车
- (void)gainTrainInfo:(NSMutableDictionary *)dic andBlock:(void(^)(NSDictionary * resultDic))returnDic
{
    NSString *apiPath = @"http://apis.juhe.cn/train/ticket.cc.php";
    NSString *key = @"2e6b5b32ea73feb500622dfd5b1ef5f9";
    NSString *from = [[dic valueForKey:@"from"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *to = [[dic valueForKey:@"to"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@?key=%@&from=%@&to=%@&date=%@",apiPath,key,from,to,[dic valueForKey:@"date"]];
    //初始化URL
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //初始化请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    //设置请求方法
    [request setHTTPMethod:@"GET"];
    
    //发请求并处理数据
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data!=nil) {
//        NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        returnDic(dic1);
//        }
//    }];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
     returnDic(dic1);
}
//异步
-(void)gainData:(NSString *)urlStr andBlock:(void (^)(NSDictionary *))returnDic{
    NSString *key = @"d86107e14a844c810b8036fb8b7bb14a";
    //初始化URL
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //初始化请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    //设置请求方法
    [request setHTTPMethod:@"GET"];
    [request addValue:key forHTTPHeaderField:@"apikey"];
    //发请求并处理数据
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data!=nil) {
            NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            returnDic(dic1);
        }
    }];
}
//同步
- (void)gainSynchronizationData:(NSString *)urlStr andBlock:(void(^)(NSDictionary * resultDic))returnDic{
    NSString *key = @"d86107e14a844c810b8036fb8b7bb14a";
    //初始化URL
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //初始化请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    //设置请求方法
    [request setHTTPMethod:@"GET"];
    [request addValue:key forHTTPHeaderField:@"apikey"];
    //发请求并处理数据
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    returnDic(dic1);
}
- (void)gainTrainDeInfo:(NSString *)urlStr andBlock:(void(^)(NSDictionary * resultDic))returnDic{
    //初始化URL
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //初始化请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    //设置请求方法
    [request setHTTPMethod:@"GET"];
    
    //发请求并处理数据（异步）
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data!=nil) {
//            NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            returnDic(dic1);
//        }
//    }];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    returnDic(dic1);
}
@end
