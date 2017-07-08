//
//  ScenicSpotDtailed.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenicSpotDtailed : NSObject

@property(strong,nonatomic) NSString *spotName;//景点名
@property(strong,nonatomic) NSString *alias;//别名
@property(strong,nonatomic) NSString *descriptionText;//介绍
@property(strong,nonatomic) NSString *detailUrl;//网站
@property(strong,nonatomic) NSString *address;//地址
@property(strong,nonatomic) NSString *imageUrl;
@property(strong,nonatomic) NSString *productId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
