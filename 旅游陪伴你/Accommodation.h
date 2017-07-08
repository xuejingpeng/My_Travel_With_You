//
//  accommodation.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Accommodation : NSObject

@property (strong,nonatomic)NSString *hotelName;
@property (strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *price;
@property(strong,nonatomic)NSString *imageName;
@property(strong,nonatomic)NSString *score;
@property(strong,nonatomic)NSString *URL;
@property(strong,nonatomic)NSString *objectId;
@property(strong,nonatomic)NSString *destination;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
