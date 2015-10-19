//
//  JWTextField.m
//  Chater
//
//  Created by 郑建文 on 15/10/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "JWTextField.h"

@interface JWTextField ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField * mainTextField;
@property (nonatomic,strong) UIImageView * backImage;
@property (nonatomic,assign) BOOL  isPassword;
@property (nonatomic,strong) NSString * placeholder;
@end


@implementation JWTextField


- (instancetype)initWithStyle:(JWTextFieldType)style placeholder:(NSString *)placeholder{
    JWTextField *tf = [JWTextField new];
    tf.placeholder = placeholder;
    [tf buildUIWithStyle:style];
    return tf;
}

//自定义UI
- (void)buildUIWithStyle:(JWTextFieldType)style{
    
    if (style == JWTextFieldPassword) {
        self.isPassword = YES;
    }
    [self addSubview:self.backImage];
    [self addSubview:self.mainTextField];
    
    
    //添加背景约束
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //添加输入框约束
    [self.mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backImage).insets(UIEdgeInsetsMake(2, 10, 2, 10));
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endWrite:)]) {
        [self.delegate endWrite:textField];
    }
    return YES;
}

#pragma mark - getter
-(UITextField *)mainTextField{
    if (!_mainTextField) {
        _mainTextField = [UITextField new];
        if (_isPassword) {
            [_mainTextField setSecureTextEntry:YES];
        }
        _mainTextField.textColor = [UIColor whiteColor];
        _mainTextField.placeholder = _placeholder;
        _mainTextField.delegate = self;
    }
    return _mainTextField;
}
-(UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textbackgroundimage"]];
    }
    return _backImage;
}

-(NSString *)content{
    return self.mainTextField.text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
