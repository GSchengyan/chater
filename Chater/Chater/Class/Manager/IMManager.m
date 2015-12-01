//
//  IMManager.m
//  Chater
//
//  Created by 郑建文 on 15/10/12.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "IMManager.h"

@implementation IMManager


static IMManager *manager = nil;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [IMManager new];
        manager.client = [AVIMClient new];
        [manager.client openWithClientId:[[AVUser currentUser] username] callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"客户端打开成功");
            }
        }];
    });
    return manager;
}




@end
