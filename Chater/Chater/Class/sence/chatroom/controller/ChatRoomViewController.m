//
//  ChatRoomViewController.m
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "ChatRoomViewController.h"

@interface ChatRoomViewController ()<AVIMClientDelegate>

//一个聊天
@property (nonatomic,strong) AVIMClient * client;

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.chater.username;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sentMessageTo:(NSString *)toName{
    
        [self.client createConversationWithName:self.chater.username clientIds:@[self.chater.username] callback:^(AVIMConversation *conversation, NSError *error) {
            
                [conversation sendMessage:[AVIMMessage messageWithContent:@"我来了"] progressBlock:^(NSInteger percentDone) {
                    
                } callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"发送成功");
                    }
                }];
            
        }];
}



#pragma mark - AVIMClientDelegate

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    NSLog(@"%@",message.text);
}


#pragma mark - getter and setter

-(AVIMClient *)client{
    if (!_client) {
        _client = [AVIMClient new];
        _client.delegate = self;
        [self.client openWithClientId:self.chater.username callback:^(BOOL succeeded, NSError *error) {
        }];
    }
    return _client;
}


@end
