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

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
