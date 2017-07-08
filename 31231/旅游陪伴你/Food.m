//
//  Food.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/26.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "Food.h"

@implementation Food
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.deal_id = [[dic valueForKey:@"viewCount"]longValue];
        self.tiny_image = [dic valueForKey:@"tiny_image"];
        self.description_text = [dic valueForKey:@"description"];
        self.market_price = [[dic valueForKey:@"market_price"]longValue];
        self.current_price = [[dic valueForKey:@"current_price"]longValue];
        self.sale_num = [[dic valueForKey:@"sale_num"]longValue];
        self.score = [[dic valueForKey:@"score"] longValue];
        self.comment_num = [[dic valueForKey:@"comment_num"]longValue];
        self.deal_murl = [dic valueForKey:@"deal_murl"];
    }
    return self;
}
@end
