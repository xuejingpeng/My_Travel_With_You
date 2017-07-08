//
//  Product.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *customUrl;

+(instancetype) productWithDict:(NSDictionary *)dict;
-(instancetype) initWithDict:(NSDictionary *)dict;

@end
