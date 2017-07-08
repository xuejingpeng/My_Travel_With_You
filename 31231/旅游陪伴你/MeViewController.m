//
//  MeViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/8.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "MeItem.h"
#import "MeItemGroup.h"
#import "PersonViewController.h"
#import "ChangePasswordViewController.h"
#import "HelpViewController.h"
#import "ProductCollectionViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    int isGender;
}
@property (nonatomic,strong) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMe;
@property (nonatomic,strong)  NSMutableArray *settingData; 
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (strong,nonatomic) NSString *userID;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tableViewMe.dataSource = self;
    self.tableViewMe.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = YES;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"我的";
    self.tabBarController.tabBar.hidden = NO;
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        self.userID = bUser.username;
    }
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"userMessage"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:_userID]) {
                if ([[obj objectForKey:@"headImage"] isEqualToString:@"无"]) {
                    [self.headIcon setImage:[UIImage imageNamed:@"icon_picture"]];
                }
                else{
                    NSString *imagePath = [obj objectForKey:@"headImage"];
//                    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imagePath atomically:YES];
                    UIImage *portrait = [UIImage imageWithContentsOfFile:imagePath];
                    [self.headIcon setImage:portrait];
                    self.headIcon.layer.masksToBounds = YES;
                    self.headIcon.layer.cornerRadius = 50;
                }
                if ([[obj objectForKey:@"gender"] isEqualToString:@"无"]) {
                    [self.gender setImage:[UIImage imageNamed:@"iconfont-icon"]];
                }
                else if ([[obj objectForKey:@"gender"] isEqualToString:@"男"]){
                    [self.gender setImage:[UIImage imageNamed:@"iconfont-nan"]];
                }
                else if ([[obj objectForKey:@"gender"] isEqualToString:@"女"]){
                    [self.gender setImage:[UIImage imageNamed:@"iconfont-nv"]];
                }
                self.userName.text = [obj objectForKey:@"userName"];
                break;
            }
        }
    }];
    [bquery clearCachedResult];
    [self.tableViewMe reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//懒加载机制（lazy loading）
-(NSArray *)settingData{
    if (_settingData == nil) {
        self.settingData = [NSMutableArray array];
        //构建第一个菜单条目组
        MeItemGroup *grp0 = [[MeItemGroup alloc] init];
        grp0.headerStr = @"第一组标题";
        MeItem *item1 =  [MeItem itemWithIcon:@"photo"  title:@"修改信息"];
        MeItem *item2 =  [MeItem itemWithIcon:@"passWord"  title:@"修改密码"];
        grp0.settingItems = @[item1,item2];
        [self.settingData addObject:grp0];
        //构建第二个菜单条目组
        MeItemGroup *grp1 = [[MeItemGroup alloc] init];
        grp1.headerStr = @"第二组标题";
        MeItem *item4 =  [MeItem itemWithIcon:@"phone"  title:@"拨打客服"];
        MeItem *item5 =  [MeItem itemWithIcon:@"iconfont-bangzhu"  title:@"帮助"];
        MeItem *item6 =  [MeItem itemWithIcon:@"iconfont-tuijian"  title:@"产品推荐"];
        MeItem *item7 =  [MeItem itemWithIcon:@"iconfont-wodedingdan"  title:@"关于"];
        MeItem *item8 =  [MeItem itemWithIcon:@"iconfont-tuichu" title:@"退出登录"];
        grp1.settingItems = @[item4,item5,item6,item7,item8];
        [self.settingData addObject:grp1];
    }
    return _settingData;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MeItemGroup *grp = self.settingData[section];
    return grp.settingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeItemGroup *grp = self.settingData[indexPath.section];
    MeItem *item = grp.settingItems[indexPath.row];
    
    static NSString *CellIdentifier = @"setting-cell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MeTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.item = item;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        //修改信息
        if (indexPath.row == 0) {
            PersonViewController *personVC = [[PersonViewController alloc]init];
            personVC.gender = @"男";
            NSData *data = UIImagePNGRepresentation(self.headIcon.image);
            personVC.headImage = data;
            personVC.userNameText = self.userName.text;
            personVC.userID = self.userID;
            [self.navigationController pushViewController:personVC animated:YES];
        }
        //修改密码
        else if (indexPath.row == 1){
            ChangePasswordViewController *changePWVC = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:changePWVC animated:YES];
        }
    }
    else if (indexPath.section == 1){
        //拨打客服
        if (indexPath.row == 0) {
            NSString *phoneNumber = @"13045914551";
            NSString *cleanedString =[[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
            UIWebView *mCallWebview = [[UIWebView alloc] init] ;
            [self.view addSubview:mCallWebview];
            [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        }
        //帮助
        else if (indexPath.row == 1){
            HelpViewController *helpVC = [[HelpViewController alloc]init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        //产品推荐
        else if (indexPath.row == 2){
            ProductCollectionViewController *productVC= [[ProductCollectionViewController alloc]init];
            [self.navigationController pushViewController:productVC animated:YES];
        }
        //关于
        else if (indexPath.row == 3){
            AboutViewController *aboutVC = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        //退出登录
        else if (indexPath.row == 4){
            NSString *title = NSLocalizedString(@"退出登录", nil);
            NSString *message = NSLocalizedString(@"是否退出登录？", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            // 取消按钮
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        }];
            //确定按钮
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *loginVC = [storyboard instantiateInitialViewController];
                self.view.window.rootViewController = loginVC;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}


//设置某个组的头部信息
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MeItemGroup *grp = self.settingData[section];
    return grp.headerStr;
}




@end
