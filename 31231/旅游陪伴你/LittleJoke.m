//
//  LittleJoke.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "LittleJoke.h"

@implementation LittleJoke

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.content = [dic valueForKey:@"content"];
        self.updatetime = [dic valueForKey:@"updatetime"];
    }
    return self;
}

@end
