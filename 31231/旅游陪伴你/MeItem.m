//
//  MeItem.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/8.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "MeItem.h"


@implementation MeItem

+ (instancetype) itemWithIcon:(NSString *)icon title:(NSString *)title{
    
    MeItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

@end
