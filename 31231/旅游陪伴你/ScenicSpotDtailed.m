//
//  ScenicSpotDtailed.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ScenicSpotDtailed.h"

@implementation ScenicSpotDtailed

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.spotName = [dic valueForKey:@"spotName"];
        self.alias = [dic valueForKey:@"alias"];
        self.descriptionText = [dic valueForKey:@"description"];
        self.detailUrl = [dic valueForKey:@"detailUrl"];
        self.address = [dic valueForKey:@"address"];
        self.imageUrl = [dic valueForKey:@"imageUrl"];
    }
    return self;
}

@end
