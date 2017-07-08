//
//  CityViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/29.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "SZCalendarPicker.h"
#import "SZCalendarCell.h"

NSString *const SZCalendarCellIdentifier = @"cell";

@interface SZCalendarPicker (){
    NSString *date1;
}
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet UILabel *monthLabel;
@property (nonatomic , weak) IBOutlet UIButton *previousButton;
@property (nonatomic , weak) IBOutlet UIButton *nextButton;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) UIView *mask;
- (IBAction)cancelBtn:(UIButton *)sender;
- (IBAction)sureBtn:(UIButton *)sender;


@end

@implementation SZCalendarPicker


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSwipe];
    [self addTap];
    [self show];
    date1 = [[NSString alloc]init];
}

- (void)awakeFromNib
{
    //到这个xib文件中去获取一个重用标识叫做SZCalendarCellIdentifier的view
    [_collectionView registerClass:[SZCalendarCell class] forCellWithReuseIdentifier:SZCalendarCellIdentifier];
     _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

#pragma mark - 设置 collectionView
- (void)customInterface
{
    CGFloat itemWidth = _collectionView.frame.size.width / 7;
    CGFloat itemHeight = _collectionView.frame.size.height / 7;
    //设置了流布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //每个CELL的尺寸
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //设置CELL的垂直间距
    layout.minimumLineSpacing = 0;
    //设置CELL的水平间距
    layout.minimumInteritemSpacing = 0;
    //设置要的配置加到 _collectionView 里面
    [_collectionView setCollectionViewLayout:layout animated:YES];
    
}

- (void)setDate:(NSDate *)date{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%.2ld-%li",(long)[self month:date],(long)[self year:date]]];
    [_collectionView reloadData];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


#pragma mark - 每个月的第一天所对应的星期
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

#pragma mark - 每个月有几天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

#pragma mark - 上个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - 下个月
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark 设置collectionView的组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

#pragma - mark 设置collectionView每组显示几个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

#pragma -mark 设置collectionView的每一个显示的数据是什么cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SZCalendarCellIdentifier forIndexPath:indexPath];
    //第一组的日期，就是第一行星期的显示
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        [cell.dateLabel setTextColor:[UIColor colorWithRed:152/255.0 green:131/255.0 blue:210/255.0 alpha:1.0]];
    } else {
//        cell.backgroundColor = [UIColor redColor];
        cell.layer.cornerRadius = 10;
        cell.layer.borderWidth = 3.0f;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.clipsToBounds = YES;
        //会自动跳到当前的时间，就是利用了这些方法
        //这一个月有几天
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        //这个月的第一天是星期几
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        //如果比这个月第一天之前的就不显示
        if (i < firstWeekday) {
            [cell.dateLabel setText:@""];
            
        }
        //超过这个月的时间就不显示
        else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateLabel setText:@""];
        }
        //在这个月的范围内
        else{
            //day是日期，数字
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setTextColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]];
            
            //今日过对应的月份
            if ([_today isEqualToDate:_date]) {
                if (day == [self day:_date]) {
                    //在今天的时间之前所有的日期显示的颜色
                    [cell.dateLabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0]];
                }
                //在今天之后的所调用的月份的所有日期显示的颜色
                else if (day >= [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0]];
                }
            }
            //在今日所对应之后的月份显示的颜色
            else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dateLabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0]];
            }
        }
    }
    return cell;
}
#pragma - mark 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
    //这一个月的天数
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        NSInteger i = indexPath.row;
        NSInteger day = 0;
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            if ([_today isEqualToDate:_date]) {
                if (day >= [self day:_date]) {
                    return YES;
                }
        }
        else if ([_today compare:_date] == NSOrderedAscending) {
                return YES;
        }
        }
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    for (int i = 0; i < 42 ; i++) {
        if (row == i) {
            SZCalendarCell *cell = (SZCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:152/255.0 green:131/255.0 blue:210/255.0 alpha:1.0];
        }
        else{
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:1];
            SZCalendarCell *cell = (SZCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath1];
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        }
    }
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    if (self.calendarBlock) {
//        date1 = [NSString stringWithFormat:@"%li年%li月%li日", (long)[comp year],(long)[comp month],(long)day];
        self.calendarBlock(day, [comp month], [comp year]);
    }
}

#pragma - mark 界面的上一个月的事件
- (IBAction)previouseAction:(UIButton *)sender
{
    for (int i = 0; i < 42 ; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
            SZCalendarCell *cell = (SZCalendarCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];
}

#pragma - mark 界面的下一个月的事件
- (IBAction)nexAction:(UIButton *)sender
{
    for (int i = 0; i < 42 ; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        SZCalendarCell *cell = (SZCalendarCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];
}

#pragma - mark 加载界面
+ (instancetype)showOnView:(UIView *)view
{
    SZCalendarPicker *calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:self options:nil] firstObject];
    calendarPicker.mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - calendarPicker.frame.origin.y)];
    calendarPicker.mask.backgroundColor = [UIColor blackColor];
    calendarPicker.mask.alpha = 0.5;
    [view addSubview:calendarPicker.mask];
    [view addSubview:calendarPicker];
    return calendarPicker;
}

#pragma - mark 日期加载的动画
- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self customInterface];
    }];
}

//隐藏界面
- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
        self.mask.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.mask removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - 添加手势
- (void)addSwipe
{
    //左滑手势添加和事件的触发
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    //右滑手势添加和事件的触发
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}
#pragma mark - 点击日历外的地方键盘收起来
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}
#pragma mark - 取消
- (IBAction)cancelBtn:(UIButton *)sender {
    [self hide];
}
#pragma mark - 确定
- (IBAction)sureBtn:(UIButton *)sender {
    [self hide];
    [self.delegate selectSureBtnClick:sender];
}
@end
