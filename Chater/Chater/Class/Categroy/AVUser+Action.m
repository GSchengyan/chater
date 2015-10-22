//
//  AVUser+Action.m
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "AVUser+Action.h"
#import "AVGeoPoint.h"

@implementation AVUser (Action)


- (void)setLocation:(CLLocation *)location{
    [self setObject:[AVGeoPoint geoPointWithLocation:location] forKey:@"location"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"上传用户信息成功");
        }
    }];
}

@end
