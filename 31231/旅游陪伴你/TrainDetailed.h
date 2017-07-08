//
//  TrainDetailed.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainDetailed : NSObject

@property(strong,nonatomic)NSString *gr;//高级软卧
@property(strong,nonatomic)NSString *qt;//其他
@property(strong,nonatomic)NSString *rw;//软卧
@property(strong,nonatomic)NSString *rz;//软座
@property(strong,nonatomic)NSString *tz;//特等座
@property(strong,nonatomic)NSString *wz;//无座
@property(strong,nonatomic)NSString *yw;//硬卧
@property(strong,nonatomic)NSString *yz;//硬座
@property(strong,nonatomic)NSString *ze;//二等座
@property(strong,nonatomic)NSString *zy;//一等座
@property(strong,nonatomic)NSString *swz;//商务座
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
