//
//  PriceList.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PriceList.h"

@implementation PriceList
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ticketTitle = [dic valueForKey:@"ticketTitle"];
        self.price = [dic valueForKey:@"price"];
        self.normalPrice = [dic valueForKey:@"normalPrice"];
        self.bookUrl = [dic valueForKey:@"bookUrl"];
    }
    return self;
}

@end
