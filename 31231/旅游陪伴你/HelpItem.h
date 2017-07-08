//
//  HelpItem.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpItem : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *html;
@property (nonatomic,copy) NSString *id;

+(instancetype) helpItemWithDict:(NSDictionary *)dict;
-(instancetype) initWithDict:(NSDictionary *)dict;

@end
