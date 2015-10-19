//
//  RegisterViewController.m
//  Chater
//
//  Created by 郑建文 on 15/10/8.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "RegisterViewController.h"
#import "AVUser.h"
#import "JWTextField.h"

@interface RegisterViewController ()<JWTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn4register;
@property (weak, nonatomic) IBOutlet UIButton *btn4login;

@property (nonatomic,strong) JWTextField * tf4UserName;
@property (nonatomic,strong) JWTextField * tf4PassWord;
@property (nonatomic,strong) JWTextField * tf4SurePassword;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view bringSubviewToFront:self.btn4login];
    [self.view bringSubviewToFront:self.btn4register];
    
    [self buildUI];
}

- (void)buildUI{
    //用户名输入框
//    [self.txt4UserName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(100);
//        make.centerX.equalTo(self.view);
//        make.width.equalTo(self.view).multipliedBy(0.7);
//    }];
    
    __weak typeof(self) weakself = self;
    
    [self.tf4UserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view).offset(120);
        make.centerX.equalTo(weakself.view);
        make.width.equalTo(weakself.view).multipliedBy(0.7);
    }];
//
//    //密码输入框
    [self.tf4PassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.tf4UserName.mas_bottom).offset(20);
        make.centerX.equalTo(weakself.view);
        make.width.equalTo(weakself.tf4UserName);
    }];
    
    [self.tf4SurePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.tf4PassWord.mas_bottom).offset(20);
        make.centerX.equalTo(weakself.view);
        make.width.equalTo(weakself.tf4UserName);
    }];
    
    //注册按钮
    [self.btn4register mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tf4SurePassword.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.tf4PassWord);
    }];
    
    //登陆按钮
    [self.btn4login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn4register.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)registerAction:(id)sender {
    
    AVUser *user = [AVUser new];
    user.username = self.tf4UserName.content;
    user.password = self.tf4PassWord.content;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
        }else{
            NSLog(@"%@",error);
        }
    }];
}

- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - JWTextFieldDelegate
- (void)endWrite:(UITextField *)textField{
    [textField resignFirstResponder];
}

#pragma mark - getter
- (JWTextField *)tf4UserName{
    if (!_tf4UserName) {
        _tf4UserName = [[JWTextField alloc] initWithStyle:JWTextFieldCommon placeholder:@"用户名"];
        [self.view addSubview:_tf4UserName];
        _tf4UserName.delegate = self;
    }
    return _tf4UserName;
}
-(JWTextField *)tf4PassWord{
    if (!_tf4PassWord) {
        _tf4PassWord = [[JWTextField alloc] initWithStyle:JWTextFieldPassword placeholder:@"密码"];
        [self.view addSubview:_tf4PassWord];
        _tf4PassWord.delegate = self;
    }
    return _tf4PassWord;
}
-(JWTextField *)tf4SurePassword{
    if (!_tf4SurePassword) {
        _tf4SurePassword = [[JWTextField alloc] initWithStyle:JWTextFieldPassword placeholder:@"确认密码"];
        [self.view addSubview:_tf4SurePassword];
        _tf4SurePassword.delegate = self;
    }
    return _tf4SurePassword;
}


@end
