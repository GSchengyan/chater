//
//  JWTextField.m
//  Chater
//
//  Created by 郑建文 on 15/10/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "JWTextField.h"

@interface JWTextField ()

@property (nonatomic,strong) UITextField * mainTextField;
@property (nonatomic,strong) UIImageView * backImage;

@end


@implementation JWTextField



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildUI];
    }
    return self;
}


//自定义UI
- (void)buildUI{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
