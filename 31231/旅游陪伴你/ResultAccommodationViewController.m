//
//  ResultAccommodationViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ResultAccommodationViewController.h"
#import "accommodationTableViewCell.h"
#import "Accommodation.h"
#import <BmobSDK/Bmob.h>
#import "AccommodationDeViewController.h"

typedef NSComparisonResult (^NSComparator)(id obj1,id obj2);

@interface ResultAccommodationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *priceView;//价格下拉
@property (weak, nonatomic) IBOutlet UIView *scoreView;//评分下拉
@property (weak, nonatomic) IBOutlet UIButton *sortResult;//价格排序结果
@property (weak, nonatomic) IBOutlet UIButton *scoreResult;//评分排序结果
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (strong,nonatomic)NSMutableArray *result;
@property (strong,nonatomic)NSArray *lowPriceScore;//低价评分排序结果
@property (strong,nonatomic)NSArray *highPriceScore;//高价评分排序结果
@property (strong,nonatomic)NSArray *priceHighScore;//价格高评分排序结果
@property (strong,nonatomic)NSArray *lowPriceHighScore;//低价高评分排序结果
@property (strong,nonatomic)NSArray *highPriceHighScore;//高价高评分排序结果

//评分排序事件
- (IBAction)scoreResult:(UIButton *)sender;
- (IBAction)scoreSort:(UIButton *)sender;

//价格排序事件
- (IBAction)sortResult:(UIButton *)sender;

- (IBAction)priceSort:(UIButton *)sender;

@end

@implementation ResultAccommodationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.result = [NSMutableArray array];
    self.result = self.resultArray;
    self.lowPriceScore = [NSArray array];
    self.highPriceScore = [NSArray array];
    self.priceHighScore = [NSArray array];
    self.lowPriceHighScore = [NSArray array];
    self.highPriceHighScore = [NSArray array];
    
    self.lowPriceScore =[self.resultArray sortedArrayUsingComparator:^NSComparisonResult(Accommodation  *obj1, Accommodation *obj2) {
        return [[NSNumber numberWithInt:[obj1.price intValue]] compare:[NSNumber numberWithInt:[obj2.price intValue]]];
    }];
    self.highPriceScore =[self.resultArray sortedArrayUsingComparator:^NSComparisonResult(Accommodation  *obj1, Accommodation *obj2) {
        return [[NSNumber numberWithInt:[obj2.price intValue]] compare:[NSNumber numberWithInt:[obj1.price intValue]]];;
    }];
    self.priceHighScore =[self.resultArray sortedArrayUsingComparator:^NSComparisonResult(Accommodation  *obj1, Accommodation *obj2) {
        return [obj2.score compare:obj1.score];
    }];
    self.lowPriceHighScore =[self.lowPriceScore sortedArrayUsingComparator:^NSComparisonResult(Accommodation  *obj1, Accommodation *obj2) {
        return [obj2.score  compare:obj1.score];
    }];
    self.highPriceHighScore =[self.highPriceScore sortedArrayUsingComparator:^NSComparisonResult(Accommodation  *obj1, Accommodation *obj2) {
        return [obj2.score compare:obj1.score];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"搜索结果";
    if (self.basic) {
        self.cityNameLabel.text = self.basic.cityName;
    }
    else{
        self.cityNameLabel.text = self.cityName;
    }
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Accommodation *data = self.resultArray[indexPath.row];
    static NSString *CellIdentifier = @"tableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"accommodationTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    accommodationTableViewCell *cell = (accommodationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accommodation = data;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccommodationDeViewController *vc=[[AccommodationDeViewController alloc]init];
    vc.accommodation = [[Accommodation alloc]init];
    vc.accommodation = self.resultArray[indexPath.row];
    vc.cityName = self.cityNameLabel.text;
    if (self.basic) {
        vc.basic = [[WhereBasic alloc]init];
        vc.basic = self.basic;
        vc.datas = [NSMutableArray array];
        vc.datas = self.datas;
    }
    vc.isViewContrller = @"住宿";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)priceSort:(UIButton *)sender {
    isSelectPrice++;
    [UIView animateWithDuration:0.5 animations:^{
        self.priceView.alpha = 0;
    }];
    [self.sortResult setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    [sender setTitle:self.sortResult.titleLabel.text forState:UIControlStateNormal];
    if ([sender.titleLabel.text isEqualToString:@"低价优先"]) {
        if ([self.scoreResult.titleLabel.text isEqualToString:@"评分排序"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceScore];
            [self.tableView reloadData];
        }
        else{
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceHighScore];
            [self.tableView reloadData];
 
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"高价优先"]) {
        if ([self.scoreResult.titleLabel.text isEqualToString:@"评分排序"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceScore];
            [self.tableView reloadData];
        }
        else{
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceHighScore];
            [self.tableView reloadData];
            
        }
    }
    
    else if ([sender.titleLabel.text isEqualToString:@"价格排序"]) {
        if ([self.scoreResult.titleLabel.text isEqualToString:@"评分排序"]) {
            self.resultArray = self.result;
            [self.tableView reloadData];
        }
        else{
            self.resultArray = [NSMutableArray arrayWithArray:self.priceHighScore];
            [self.tableView reloadData];
        }
    }
}

static int isSelectPrice;
- (IBAction)sortResult:(UIButton *)sender{
    if (isSelectPrice%2==0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.priceView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            self.priceView.alpha = 0;
        }];
    }
    isSelectPrice++;
}
static int isSelectScore;
- (IBAction)scoreResult:(UIButton *)sender {
    if (isSelectScore%2==0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.scoreView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            self.scoreView.alpha = 0;
        }];
    }
    isSelectScore++;
}

- (IBAction)scoreSort:(UIButton *)sender {
    isSelectScore++;
    [UIView animateWithDuration:0.5 animations:^{
        self.scoreView.alpha = 0;
    }];
    [self.scoreResult setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    [sender setTitle:self.sortResult.titleLabel.text forState:UIControlStateNormal];
    if ([sender.titleLabel.text isEqualToString:@"评分排序"]) {
        if ([self.sortResult.titleLabel.text isEqualToString:@"价格排序"]) {
            self.resultArray = self.result;
            [self.tableView reloadData];
        }
        else if ([self.sortResult.titleLabel.text isEqualToString:@"低价优先"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceScore];
            [self.tableView reloadData];
        }
        else {
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceScore];
            [self.tableView reloadData];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"高评分优先"]) {
        if ([self.sortResult.titleLabel.text isEqualToString:@"价格排序"]) {
           self.resultArray = [NSMutableArray arrayWithArray:self.priceHighScore];
            [self.tableView reloadData];
        }
        else if ([self.sortResult.titleLabel.text isEqualToString:@"低价优先"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceHighScore];
            [self.tableView reloadData];
        }
        else {
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceHighScore];
            [self.tableView reloadData];
        }
    }

}
@end
