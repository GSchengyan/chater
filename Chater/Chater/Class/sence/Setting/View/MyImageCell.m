//
//  MyImageCell.m
//  Chater
//
//  Created by 郑建文 on 15/11/17.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "MyImageCell.h"

@interface MyImageCell ()

@property (weak, nonatomic) IBOutlet UILabel *lab4UserName;

@end

@implementation MyImageCell

- (void)awakeFromNib {
    _img4Photo.layer.cornerRadius = self.img4Photo.frame.size.width * 0.5;
    _img4Photo.layer.masksToBounds = YES;
    if (!_isLoadImage) {
        
        AVUser *user = [AVUser currentUser];
        _lab4UserName.text = user.username;
        
        [[AVUser currentUser] getPhotoBlack:^(UIImage * image) {
            self.img4Photo.image = image;
            _isLoadImage = YES;
        }];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
