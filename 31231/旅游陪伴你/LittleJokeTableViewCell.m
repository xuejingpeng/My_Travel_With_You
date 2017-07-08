//
//  LittleJokeTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "LittleJokeTableViewCell.h"
#import "LittleJoke.h"

@interface LittleJokeTableViewCell(){
    UIView *seperator;
}

@end

@implementation LittleJokeTableViewCell

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
}
-(void)setLittleJoke:(LittleJoke *)littleJoke{
    self.titleLabel.text = littleJoke.updatetime;
    self.dataLabel.text = littleJoke.content;
    self.numb = (int)self.dataLabel.numberOfLines;
}

@end
