//
//  accommodation.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "Accommodation.h"

@implementation Accommodation
-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.hotelName = [dic valueForKey:@"hotelName"];
        self.address = [dic valueForKey:@"address"];
        self.price = [dic valueForKey:@"price"];
        self.imageName = [dic valueForKey:@"imageName"];
        self.score = [dic valueForKey:@"score"];
        self.URL = [dic valueForKey:@"URL"];
    }
    return self;
}

@end
