//
//  TrainDetailed.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "TrainDetailed.h"

@implementation TrainDetailed
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
