//
//  HelpItem.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "HelpItem.h"

@implementation HelpItem
+(instancetype) helpItemWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
    
}

-(instancetype) initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
    
}
@end
