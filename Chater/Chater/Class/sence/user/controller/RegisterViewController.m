//
//  RegisterViewController.m
//  Chater
//
//  Created by 郑建文 on 15/10/8.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "RegisterViewController.h"
#import "AVUser.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt4UserName;
@property (weak, nonatomic) IBOutlet UITextField *txt4PassWord;
@property (weak, nonatomic) IBOutlet UIButton *btn4register;
@property (weak, nonatomic) IBOutlet UIButton *btn4login;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view bringSubviewToFront:self.txt4UserName];
    [self.view bringSubviewToFront:self.txt4PassWord];

    [self.view bringSubviewToFront:self.btn4login];
    [self.view bringSubviewToFront:self.btn4register];
    
    [self buildUI];
}

- (void)buildUI{
    //用户名输入框
    [self.txt4UserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.7);
    }];
    
    //密码输入框
    [self.txt4PassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txt4UserName.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.txt4UserName);
    }];
    
    //注册按钮
    [self.btn4register mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txt4PassWord.mas_bottom).offset(80);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.txt4PassWord);
    }];
    
    //登陆按钮
    [self.btn4login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn4register.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)registerAction:(id)sender {
    
    AVUser *user = [AVUser new];
    user.username = self.txt4UserName.text;
    user.password = self.txt4PassWord.text;
    
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


@end
