//
//  LocationManager.m
//  Chater
//
//  Created by 郑建文 on 15/10/22.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "LocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager * cllocationManager;

@end

@implementation LocationManager

+ (instancetype)defaultManager{
    static LocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LocationManager new];
        manager.cllocationManager = [[CLLocationManager alloc] init];
        [manager.cllocationManager requestAlwaysAuthorization];
        [manager.cllocationManager requestWhenInUseAuthorization];
        manager.cllocationManager.delegate = manager;
        manager.cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.cllocationManager.distanceFilter = 1000.f;
        [manager.cllocationManager startUpdatingLocation];
    });
    return manager;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [[AVUser currentUser] setLocation:[locations lastObject]];
    //定位成功后一次就停止定位
    [self.cllocationManager stopUpdatingLocation];
    self.cllocationManager.delegate = nil;
    self.cllocationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}




@end
