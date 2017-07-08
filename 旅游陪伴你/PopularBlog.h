//
//  PopularBlog.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopularBlog : NSObject
@property(strong,nonatomic)NSString *bookUrl;//网站
@property(strong,nonatomic)NSString *title;//标题
@property(strong,nonatomic)NSString *headImage;//图片
@property(strong,nonatomic)NSString *userName;//发布者名字
@property(assign,nonatomic)long viewCount;//浏览人数
@property(assign,nonatomic)long likeCount;//赞的人数
@property(assign,nonatomic)long commentCount;//评价条数

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
