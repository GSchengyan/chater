//
//  AVUser+Action.m
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "AVUser+Action.h"
#import "AVGeoPoint.h"
#import "AVFile.h"

@implementation AVUser (Action)

@dynamic fileDelegate;

- (void)setLocation:(CLLocation *)location{
    [self setObject:[AVGeoPoint geoPointWithLocation:location] forKey:@"location"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"上传用户信息成功");
        }
    }];
}


- (void)setPhoto:(UIImage *)image{
    NSData *imageData = UIImagePNGRepresentation(image);
    AVFile *imageFile = [AVFile fileWithName:@"logo" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"图片上传成功");
        }else{
            NSLog(@"图片上传失败");
        }
    } progressBlock:^(NSInteger percentDone) {
//        NSLog(@"%d",percentDone);
//        [self.fileDelegate avuserAddFil:self Progress:percentDone];
    }];
    
    [self setObject:imageFile forKey:@"photo"];
    [self saveInBackground];
}

-(void)getPhotoBlack:(ImageBlack)block{
    AVFile *imageFile = [self objectForKey:@"photo"];
    [imageFile getThumbnail:YES width:200 height:200 withBlock:^(UIImage *image, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        block(image);
    }];
}

@end
