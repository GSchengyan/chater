//
//  AVUser+Action.h
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "AVUser.h"
#import <CoreLocation/CoreLocation.h>

@protocol AVUserAddFileDelegate <NSObject>

- (void)avuserAddFil:(AVUser *)user Progress:(NSInteger)progress;

@end

typedef void(^ImageBlack)(UIImage *);

@interface AVUser (Action)

@property (nonatomic,weak) id<AVUserAddFileDelegate> fileDelegate;

- (void)setLocation:(CLLocation *)location;

- (void)setPhoto:(UIImage *)image;

- (void)getPhotoBlack:(ImageBlack)block;

@end
