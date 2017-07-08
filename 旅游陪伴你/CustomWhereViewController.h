//
//  CustomWhereViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/24.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhereBasic.h"
@interface CustomWhereViewController : UIViewController

@property(strong,nonatomic)WhereBasic *basic;
@property(strong,nonatomic)NSMutableArray *datas;//最终结果

@end
