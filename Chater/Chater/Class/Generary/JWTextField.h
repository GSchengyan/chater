//
//  JWTextField.h
//  Chater
//
//  Created by 郑建文 on 15/10/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    JWTextFieldCommon,
    JWTextFieldPassword,
} JWTextFieldType;


@protocol JWTextFieldDelegate <NSObject>

- (void)endWrite:(UITextField *)textField;

@end

/**
 *  自定义输入框
 */
@interface JWTextField : UIView

@property (nonatomic,strong) NSString * content;
@property (nonatomic,assign) id<JWTextFieldDelegate>  delegate;


- (instancetype)initWithStyle:(JWTextFieldType)style placeholder:(NSString *)placeholder;

@end
