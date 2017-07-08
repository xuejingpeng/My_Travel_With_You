//
//  PriceList.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceList : NSObject

@property(strong,nonatomic)NSString *ticketTitle;//票名
@property(strong,nonatomic)NSString *price;//优惠价格
@property(strong,nonatomic)NSString *normalPrice;//正常价格
@property(strong,nonatomic)NSString *bookUrl;//预定网站

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
