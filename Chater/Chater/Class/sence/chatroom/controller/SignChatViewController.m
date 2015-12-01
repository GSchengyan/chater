//
//  SignChatViewController.m
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "SignChatViewController.h"
#import "JSQPhotoMediaItem.h"
#import "JSQMessage.h"
#import "UIImage+JSQMessages.h"
#import "JSQMessagesAvatarImage.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "JSQMessagesBubbleImageFactory.h"
#import <JSQMessagesViewController/JSQMessage.h>
#import "UIColor+JSQMessages.h"
#import "AVIMClient.h"
#import "AVUser.h"
#import "AVIMConversation.h"
#import "AVIMConversationQuery.h"

@interface SignChatViewController()<AVIMClientDelegate>

//用来记录聊天信息
@property (nonatomic,strong) NSMutableArray * messages;

//发送消息的气泡
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

//接收消息的气泡
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

//聊天客户端
@property (nonatomic,strong) AVIMClient * client;

//聊天对话
@property (nonatomic,strong) AVIMConversation * converstaion;

//图片
@property (nonatomic,strong) UIImage * myPhoto;

@end


@implementation SignChatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //发送人
    self.senderId = [AVUser currentUser].username;
    self.senderDisplayName = [AVUser currentUser].username;
    
    __block SignChatViewController *men = self;
    
    
    //创建客户端
    [self.client openWithClientId:[[AVUser currentUser] username] callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            men.client.delegate = self;
            //TODO: 应该先查看是否之前创建了聊天对话
           
            //聊天对话查询对象
            AVIMConversationQuery *query = [self.client conversationQuery];
            //查找对话名字是 两个对话人姓名
            [query whereKey:@"name" equalTo:[self getConversation]];
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                //如果数据库中没有对话就创建一个
                if (objects.count == 0) {
                    //创建回话
                    [self.client createConversationWithName:[self getConversation] clientIds:@[self.chater.username] callback:^(AVIMConversation *conversation, NSError *error) {
                        self.converstaion = conversation;
                    }];
                }else{
                    //取到最后一个对话
                    self.converstaion = objects.lastObject;
                    //查询之前的对话
                    [self.converstaion queryMessagesWithLimit:10 callback:^(NSArray *objects, NSError *error) {
                        for (AVIMMessage *message in objects) {
                            JSQMessage *jsqmessage = [JSQMessage messageWithSenderId:message.clientId displayName:@"test" text:message.content];
                            [self.messages addObject:jsqmessage];
                        }
                        [self finishReceivingMessageAnimated:YES];
                    }];
                    
                }
                
            }];
        }
    }];
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
//    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.showLoadEarlierMessagesHeader = YES;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:nil];
    
    self.title = self.chater.username;
    
    //设置聊天气泡
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    [[AVUser currentUser] getPhotoBlack:^(UIImage * image) {
        self.myPhoto = image;
    }];
}

//根据两个人得用户名来排序来生成一个对话名
- (NSString *)getConversation{
    NSString *myname = [AVUser currentUser].username;
    NSString *chaterName = self.chater.username;
    if ([myname compare:chaterName] == NSOrderedAscending) {
        
        return [NSString stringWithFormat:@"%@%@",chaterName,myname];
    }else{
        return [NSString stringWithFormat:@"%@%@",myname,chaterName];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}


// 发送按钮
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    NSLog(@"text:%@,senderID:%@,senderDisplayName:%@,data:%@",text,senderId,senderDisplayName,date);
    
    //构造jsq 消息,添加到页面
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId displayName:senderDisplayName text:text];
    //构造发送的消息
    AVIMMessage *avmessage = [AVIMMessage messageWithContent:text];
    //发送消息
    [self.converstaion sendMessage:avmessage callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送消息成功");
        }
    }];
    
    [self.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
}


#pragma mark - UICollectionView DataSource 

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.messages.count;
}


- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
   JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
    
}


#pragma mark - JSQMessagesCollectionViewDataSource


//返回数据
-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.messages[indexPath.row];
}

//返回气泡的方法
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    JSQMessage *message = self.messages[indexPath.row];
    if ([message.senderId isEqualToString:[[AVUser currentUser] username]]) {
        return self.outgoingBubbleImageData;
    }else{
        return self.incomingBubbleImageData;
    }
}

//返回人物头像的回调方法
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JSQMessagesAvatarImage *image = [JSQMessagesAvatarImage avatarWithImage:self.myPhoto == nil ? [UIImage imageNamed:@"demo_avatar_cook"] : _myPhoto];
    
    return image;
}


#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}
 

#pragma mark - JSQMessagesCollectionViewDelegateFlowLayout
-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    return 10.0f;
}
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    return 10.0f;
}
#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods


- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {

        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}



#pragma mark - AVIMClientDelegate
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    NSLog(@"%@",message.content);
}
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
//    NSLog(@"%@",message.text);
}
//接受代理方法
-(void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    NSLog(@"_____%d",message.ioType);
    NSLog(@"+++++++%@",message.content);
    
    NSLog(@"%@=========%@",message.clientId,self.chater.className);
    
    JSQMessage *jsqmessage = [JSQMessage messageWithSenderId:message.clientId displayName:@"test" text:message.content];
    [self.messages addObject:jsqmessage];
    [self finishReceivingMessageAnimated:YES];
}

#pragma mark - getting and setting

- (NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray array];
        
    }
    return _messages;
}




-(AVIMClient *)client{
    if (!_client) {
        [AVIMClient resetDefaultClient];
        _client = [AVIMClient defaultClient];
    }
    return _client;
}


@end
