//
//  WhereBasicCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/22.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WhereBasicCell.h"

@implementation WhereBasicCell{
    UIView *seperator;
}

- (void)awakeFromNib {
    seperator = [[UIView alloc] init];
    seperator.backgroundColor = [UIColor colorWithRed:236/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    
    [self.contentView addSubview:seperator];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat x = 5;
    CGFloat y = self.frame.size.height-1;
    CGFloat width = self.frame.size.width-10;
    CGFloat height = 1;
    seperator.frame = CGRectMake(x, y, width, height);
}
-(void)setBasic:(WhereBasic *)basic{
    self.title.text = basic.title;
    self.date.text = basic.date;
    self.cityName.text = basic.cityName;
}

- (IBAction)modify:(UIButton *)sender {
    [self.delegate whereBasiceModifyBtnClick:sender];
}
@end
