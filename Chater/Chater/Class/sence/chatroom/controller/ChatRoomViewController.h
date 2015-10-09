//
//  ChatRoomViewController.h
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM.h>
#import "AVUser.h"
#import "JSQMessage.h"
#import <JSQMessagesViewController/JSQMessage.h>

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface ChatRoomViewController : UIViewController

@property (nonatomic,strong) AVUser * chater;

@end
