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

@property (nonatomic,strong)  CLLocationManager * locationManager;

@property (nonatomic,strong) AVGeoPoint *point;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.point = self.locationManager.location;

    // Do any additional setup after loading the view.
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
