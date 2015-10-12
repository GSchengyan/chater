//
//  IMManager.h
//  Chater
//
//  Created by 郑建文 on 15/10/12.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVIMClient.h"

@interface IMManager : NSObject

@property (nonatomic,strong) AVIMClient * client;


+ (instancetype)sharedManager;

@end
