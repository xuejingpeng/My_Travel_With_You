//
//  LoopView.h
//  Test_LoopScrollView
//
//  Created by 薛静鹏 on 16/1/3.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopView : UIView
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic,strong)NSArray *imageArray;
@end
