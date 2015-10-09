//
//  SignChatViewController.h
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "AVUser.h"

@class SignChatViewController;

@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoController:(SignChatViewController*)vc;

@end


@interface SignChatViewController : JSQMessagesViewController<JSQMessagesComposerTextViewPasteDelegate>

@property (nonatomic,strong) AVUser * chater;
@property (nonatomic,weak) id<JSQDemoViewControllerDelegate> delegateModel;




@end
