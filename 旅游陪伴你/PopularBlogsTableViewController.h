//
//  PopularBlogsTableViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularBlog.h"

@interface PopularBlogsTableViewController : UITableViewController

@property(strong,nonatomic) NSString *placeName;
@property (strong,nonatomic) NSMutableArray *datas;

@property(strong,nonatomic)NSString *isRefresh;

@end
