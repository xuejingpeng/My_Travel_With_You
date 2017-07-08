//
//  FoodTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/26.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "FoodTableViewCell.h"

@implementation FoodTableViewCell{
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

-(void)setFood:(Food *)food{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:food.tiny_image]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tiny_image.image = [UIImage imageWithData:data];
        });
    });
    self.title.text = food.title;
    self.descriptionText.text = food.description_text;
    if (food.score>=0 && food.score<=0.5) {
        self.score1.image = [UIImage imageNamed:@"Star_half"];
    }
    else if (food.score>0.5 && food.score<=1){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
    }
    else if (food.score>1 && food.score<=1.5){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_half"];
    }
    else if (food.score>1.5 && food.score<=2){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
    }
    else if (food.score>2 && food.score<=2.5){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
        self.score3.image = [UIImage imageNamed:@"Star_half"];
    }
    else if (food.score>2.5 && food.score<=3){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
        self.score3.image = [UIImage imageNamed:@"Star_solid"];
    }
    else if (food.score>3 && food.score<=3.5){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
        self.score3.image = [UIImage imageNamed:@"Star_solid"];
        self.score4.image = [UIImage imageNamed:@"Star_half"];
    }
    else if (food.score>3.5 && food.score<=4){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
        self.score3.image = [UIImage imageNamed:@"Star_solid"];
        self.score4.image = [UIImage imageNamed:@"Star_solid"];
    }
    else if (food.score>4 && food.score<=4.5){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
        self.score3.image = [UIImage imageNamed:@"Star_solid"];
        self.score4.image = [UIImage imageNamed:@"Star_solid"];
        self.score5.image = [UIImage imageNamed:@"Star_half"];
    }
    else if (food.score>4.5){
        self.score1.image = [UIImage imageNamed:@"Star_solid"];
        self.score2.image = [UIImage imageNamed:@"Star_solid"];
        self.score3.image = [UIImage imageNamed:@"Star_solid"];
        self.score4.image = [UIImage imageNamed:@"Star_solid"];
        self.score5.image = [UIImage imageNamed:@"Star_solid"];
    }
    long price = food.current_price/100;
    self.current_price.text =[NSString stringWithFormat:@"%ld",price];
    long market =food.market_price/100;
    NSString *str = [NSString stringWithFormat:@"¥ %ld",market];
    NSUInteger length = [str length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(2, length-2)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:223/255.0 green:221/255.0 blue:223/255.0 alpha:1.0] range:NSMakeRange(2,length-2 )];
    [self.market_price setAttributedText:attri];
    NSString *sale;
    if (food.sale_num>10000) {
       float sale1 = food.sale_num/10000.0;
        sale = [NSString stringWithFormat:@"%.2f万",sale1];
    }
    else{
        sale = [NSString stringWithFormat:@"%ld",food.sale_num];
    }
    self.sale_num.text = sale;
    NSString *comment;
    if (food.comment_num>10000) {
        float sale1 = food.comment_num/10000.0;
        comment = [NSString stringWithFormat:@"%.2f万",sale1];
    }
    else{
        comment = [NSString stringWithFormat:@"%ld",food.comment_num];
    }
    self.comment_num.text = comment;
}

@end
