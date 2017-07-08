//
//  ScenicDetailedViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ScenicDetailedViewController.h"
#import "PriceList.h"
#import "PriceTableViewCell.h"
#import "WhereWebViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"
#import "CustomWhereViewController.h"
#import "CustomGroup.h"

@interface ScenicDetailedViewController ()<UITableViewDataSource,UITableViewDelegate,clickScenicDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageScenic;
@property (weak, nonatomic) IBOutlet UILabel *spotName;
@property (weak, nonatomic) IBOutlet UILabel *alias;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITableView *priceTableView;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property(strong,nonatomic) NSString *objectId;

- (IBAction)saveBtn:(UIButton *)sender;

@end

@implementation ScenicDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.scenicDt.imageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageScenic.image = [UIImage imageWithData:data];
        });
    });
    self.spotName.text = self.scenicDt.spotName;
    if(self.scenicDt.alias == nil){
        self.alias.text = @"无";
    }
    else{
        self.alias.text = self.scenicDt.alias;
    }
    self.descriptionText.text = self.scenicDt.descriptionText;
    self.address.text = self.scenicDt.address;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"景点详细";
    if (self.basic) {
        self.save.hidden = NO;
    }
    else{
        self.save.hidden = YES;
    }
    //设置导航栏右边的
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_star_gray_48"] style:UIBarButtonItemStylePlain  target:self action:@selector(saveMessage:)];
    i=0;
}
#pragma mark - UITableView的相关操作
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.priceList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PriceList *data = self.priceList[indexPath.row];
    static NSString *CellIdentifier = @"priceCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"PriceTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    PriceTableViewCell *cell = (PriceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.priceList = data;
    cell.delegate = self;
    return cell;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)leaveToWeb:(UIButton *)sender{
    PriceList *data = self.priceList[0];
    NSArray *array = [data.bookUrl componentsSeparatedByString:@"&"];
    WhereWebViewController *vc = [[WhereWebViewController alloc]init];
    vc.URL = array[0];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)saveBtn:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在保存中..."];
    BmobObject *objDetailed = [BmobObject objectWithClassName:@"ScencDetail"];
    [objDetailed setObject:self.scenicDt.spotName forKey:@"spotName"];
    [objDetailed setObject:self.scenicDt.descriptionText forKey:@"descriptionText"];
    [objDetailed setObject:self.scenicDt.imageUrl forKey:@"imageUrl"];
    [objDetailed setObject:self.scenicDt.productId forKey:@"productId"];
    [objDetailed saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Scenc"];
            [bquery getObjectInBackgroundWithId:self.scenicId block:^(BmobObject *object, NSError *error) {
                [object setObject:objDetailed forKey:@"scencDetail"];
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        BmobObject *post  = [BmobObject objectWithClassName:@"CustomWhere"];
                        [post setObject:self.basic.objectId forKey:@"objectUserID"];
                        [post setObject:@"景点" forKey:@"isType"];
                        [post setObject:object forKey:@"scenc"];
                        [post setObject:self.basic.day forKey:@"day"];
                        [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                [MBProgressHUD hideHUD];
                                [MBProgressHUD showSuccess:@"添加成功"];
                                int day = self.basic.day.intValue;
                                CustomGroup *customGroup = self.datas[day];
                                if (customGroup.settingItems == nil) {
                                    customGroup.settingItems  = [NSMutableArray array];
                                    [customGroup.settingItems addObject:self.scenicDt];
                                }
                                else{
                                    [customGroup.settingItems insertObject:self.scenicDt atIndex:customGroup.settingItems.count];
                                }
                                [self.delegate returnData:self.datas];
                                NSArray *temArray = self.navigationController.viewControllers;
                                for (UIViewController *temVC in temArray) {
                                    if ([temVC isKindOfClass:[CustomWhereViewController class]]) {
                                        [self.navigationController popToViewController:temVC animated:YES];
                                        break;
                                    }
                                }
                            }
                        }];

                    }
                }];
            }];
        }
    }];
}
static int i;
-(void)saveMessage:(UIButton *)sender{

    if(i%2 == 0){
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
        BmobUser *bUser = [BmobUser getCurrentUser];
        
        BmobObject *obj = [BmobObject objectWithClassName:@"ScencCollection"];
        [obj setObject:bUser.username forKey:@"userID"];
        [obj setObject:self.scenicSpot.productId forKey:@"productId"];
        [obj setObject:self.scenicSpot.spotName forKey:@"spotName"];
        [obj setObject:self.scenicSpot.address forKey:@"address"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            self.objectId = [obj objectId];
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"收藏成功"];
            }
            else{
                [MBProgressHUD showSuccess:@"已经收藏过了"];
            }
        }];
    }
    else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ScencCollection" objectId:self.objectId];
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"取消收藏"];
            }
        }];
    }
    i++;
}

@end
