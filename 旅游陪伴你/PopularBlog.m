//
//  PopularBlog.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PopularBlog.h"

@implementation PopularBlog

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.bookUrl = [dic valueForKey:@"bookUrl"];
        self.title = [dic valueForKey:@"title"];
        self.headImage = [dic valueForKey:@"headImage"];
        self.userName = [dic valueForKey:@"userName"];
        self.viewCount = [[dic valueForKey:@"viewCount"]longValue];
        self.likeCount = [[dic valueForKey:@"likeCount"]longValue];
        self.commentCount =[[dic valueForKey:@"commentCount"]longValue];
    }
    return self;
}

@end
