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

@interface SignChatViewController()<AVIMClientDelegate>

@property (nonatomic,strong) NSMutableArray * messages;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;


@property (nonatomic,strong) AVIMClient * client;

@end


@implementation SignChatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.senderId = [AVUser currentUser].username;
    self.senderDisplayName = [AVUser currentUser].username;
    
    self.client.delegate = self;
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
//    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.showLoadEarlierMessagesHeader = YES;
    
//    UIImage
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:nil];
    
    self.title = self.chater.username;
    
    
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}


-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    NSLog(@"text:%@,senderID:%@,senderDisplayName:%@,data:%@",text,senderId,senderDisplayName,date);
    
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId displayName:senderDisplayName text:text];
    
    
    [self.client createConversationWithName:@"聊天" clientIds:@[self.chater.username] callback:^(AVIMConversation *conversation, NSError *error) {
                AVIMMessage *message = [AVIMMessage messageWithContent:text];
                [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"发送成功");
                    }
                }];
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
    
    JSQMessagesAvatarImage *image = [JSQMessagesAvatarImage avatarWithImage:[UIImage imageNamed:@"image2.jpg"]];
//    JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]
//                                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
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

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    NSLog(@"%@",message.text);
}

-(void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    NSLog(@"%@",message.content);
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
        _client = [AVIMClient defaultClient];
//        _client.delegate = self;
        [_client openWithClientId:[[AVUser currentUser] username] callback:^(BOOL succeeded, NSError *error) {
            NSLog(@"对话打开成功");
        }];
    }
    return _client;
}


@end
