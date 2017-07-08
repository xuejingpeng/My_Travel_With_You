//
//  Food.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/26.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property(assign,nonatomic)long deal_id;
@property(strong,nonatomic)NSString *tiny_image;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *description_text;
@property(assign,nonatomic)long market_price;
@property(assign,nonatomic)long current_price;
@property(assign,nonatomic)long sale_num;
@property(assign,nonatomic)long score;
@property(assign,nonatomic)long comment_num;
@property(strong,nonatomic)NSString *deal_murl;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
