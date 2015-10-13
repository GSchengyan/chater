//
//  LoginViewController.m
//  Chater
//
//  Created by 郑建文 on 15/10/8.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "LoginViewController.h"
#import "AVUser.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "AVGeoPoint.h"

@interface LoginViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt4UserName;

@property (weak, nonatomic) IBOutlet UITextField *txt4PassWord;
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImg;
@property (weak, nonatomic) IBOutlet UIButton *btn4login;
@property (weak, nonatomic) IBOutlet UIButton *btn4register;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;


@property (nonatomic,strong)  CLLocationManager * locationManager;

@property (nonatomic,strong) AVGeoPoint *point;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    if (self.locationManager.location) {

        self.point = [AVGeoPoint geoPointWithLocation:self.locationManager.location];
    }

    
    [self buildUI];

}

- (void)buildUI{
    
    //隐藏状态栏
    [self.navigationController setNavigationBarHidden:YES];
    
    //设置导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroup"] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    //背景图片
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    //欢迎图片
    [self.welcomeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView).offset(120);
        make.centerX.equalTo(self.backImageView);
        make.height.equalTo(@40);
    }];
    
    //用户名输入框
    [self.txt4UserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(self.welcomeImg.mas_bottom).offset(50);
        make.width.equalTo(self.backImageView).multipliedBy(0.7);
    }];
    
    //密码输入框
    [self.txt4PassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(self.txt4UserName.mas_bottom).offset(20);
        make.width.equalTo(self.txt4UserName);
    }];
    
    //登陆按钮
    [self.btn4login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(self.txt4PassWord.mas_bottom).offset(20);
        make.width.equalTo(self.txt4UserName);
    }];
    
    
    //注册按钮
    [self.btn4register mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(self.btn4login.mas_bottom).offset(10);
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAction:(id)sender {
    [AVUser logInWithUsernameInBackground:self.txt4UserName.text password:self.txt4PassWord.text block:^(AVUser *user, NSError *error) {
        if (user) {
            NSLog(@"登陆成功");
            
            [user setObject:self.point forKey:@"location"];
            
            [user save];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *nav = [sb instantiateInitialViewController];
            
            AppDelegate *mydelegate = [UIApplication sharedApplication].delegate;
            mydelegate.window.rootViewController = nav;
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
}

#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray *)locations{
    CLLocation *location = [locations lastObject];
    self.point = [AVGeoPoint geoPointWithLocation:location];
}


-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

@end
