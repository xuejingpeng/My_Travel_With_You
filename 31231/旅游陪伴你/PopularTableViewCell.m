//
//  PopularTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PopularTableViewCell.h"
#import "PopularBlog.h"

@interface PopularTableViewCell (){
    UIView *seperator;
}

@end

@implementation PopularTableViewCell

- (void)awakeFromNib {
    seperator = [[UIView alloc] init];
    seperator.backgroundColor = [UIColor colorWithRed:236/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    
    [self.contentView addSubview:seperator];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat x = 5;
    CGFloat y = self.frame.size.height-1;
    CGFloat width = self.frame.size.width-10;
    CGFloat height = 1;
    seperator.frame = CGRectMake(x, y, width, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPopularBlog:(PopularBlog *)popularBlog{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![popularBlog.headImage isEqual:  [NSNull null]]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:popularBlog.headImage]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headImage.image = [UIImage imageWithData:data];
            });
        }
        else{
            self.headImage.image = [UIImage imageNamed:@"icon_picture"];
        }
    });
    self.title.text = popularBlog.title;
    self.userName.text = popularBlog.userName;
    self.viewCount.text = [NSString stringWithFormat:@"%ld",popularBlog.viewCount];
    self.likeCount.text = [NSString stringWithFormat:@"%ld",popularBlog.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%ld",popularBlog.commentCount];
}
@end
