//
//  accommodationTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "accommodationTableViewCell.h"
#import <BmobSDK/BmobProFile.h>

@implementation accommodationTableViewCell{
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
-(void)setAccommodation:(Accommodation *)accommodation{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:accommodation.imageName]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageNmae.image = [UIImage imageWithData:data];
        });
    });
    self.holeNmae.text = accommodation.hotelName;
    self.address.text = accommodation.address;
    self.score.text = accommodation.score;
    self.price.text = accommodation.price; 
}
@end
