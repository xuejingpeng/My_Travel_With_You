//
//  LoopView.m
//  Test_LoopScrollView
//
//  Created by 薛静鹏 on 16/1/3.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "LoopView.h"

@implementation LoopView

static int imageCount;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initArray];
        [self setupScrollView];
        [self setupPageControl];
    }
    return self;
}
//存放图片的数组
-(void)initArray
{
    _imageArray=[NSArray arrayWithObjects: [UIImage imageNamed:@"catalog_head_bg1"],[UIImage imageNamed:@"catalog_head_bg2"],[UIImage imageNamed:@"catalog_head_bg3"],[UIImage imageNamed:@"catalog_head_bg4"],[UIImage imageNamed:@"catalog_head_bg5"],nil];
    imageCount = (int)_imageArray.count;
}

//scrollView的设置（添加图片，scrollView的属性设置）
- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 120)];
    _scrollView.tag = 200;
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * (imageCount+1),120);
    [_scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width,0) animated:NO];
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;//隐藏垂直和水平显示条
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    for (int i = 0; i <= imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width,120)];
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"catalog_head_bg1"];
        } else if (i == imageCount) {
            imageView.image = [UIImage imageNamed:@"catalog_head_bg1"];
        } else {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"catalog_head_bg%d",i+1]];
        }
        [_scrollView addSubview:imageView];
    }
}

- (void)setupPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(15, 100, 300, 20)];
    _pageControl.tag = 100;
    _pageControl.numberOfPages = imageCount;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:_pageControl];
}


@end
