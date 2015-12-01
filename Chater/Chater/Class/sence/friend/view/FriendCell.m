//
//  FriendCell.m
//  Chater
//
//  Created by 郑建文 on 15/11/29.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img4Photo;

@property (weak, nonatomic) IBOutlet UILabel *lab4UserName;

@property (weak, nonatomic) IBOutlet UILabel *lab4Distance;

@end

@implementation FriendCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(AVUser *)user{
    _lab4UserName.text = user.username;
    [user getPhotoBlack:^(UIImage * image) {
        _img4Photo.image = image;
    }];
}

@end
