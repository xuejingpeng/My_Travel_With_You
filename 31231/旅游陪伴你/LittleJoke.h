//
//  LittleJoke.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LittleJoke : NSObject
@property(strong,nonatomic) NSString *updatetime;
@property(strong,nonatomic) NSString *content;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
