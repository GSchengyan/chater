//
//  FriendsTableViewController.m
//  Chater
//
//  Created by 郑建文 on 15/10/9.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "AVUser.h"
#import "AVGeoPoint.h"
#import "AVQuery.h"
#import "ChatRoomViewController.h"
#import "SignChatViewController.h"
#import "FriendCell.h"



@interface FriendsTableViewController ()

@property (nonatomic,strong) NSMutableArray * users;

@end

@implementation FriendsTableViewController

static NSString * friendCellIdentifier = @"friendCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:friendCellIdentifier];
    
    [self fetchUsers];
}
- (IBAction)reflash:(id)sender {
    [self fetchUsers];
}

- (void)fetchUsers{
    AVUser *user = [AVUser currentUser];
    AVGeoPoint *point = [user objectForKey:@"locatiom"];
    
    AVQuery *query = [AVUser query];
    
    [query whereKey:@"location" nearGeoPoint:point withinRadians:10000];
    [query whereKey:@"username" notEqualTo:user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (self.users.count > 0) {
            [self.users removeAllObjects];
        }
        
        [self.users addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SignChatViewController *room = [[SignChatViewController alloc] init];
    room.chater = self.users[indexPath.row];
    room.hidesBottomBarWhenPushed = YES;
    [self showViewController:room sender:nil];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier forIndexPath:indexPath];
    
    
    AVUser *user = (AVUser *)self.users[indexPath.row];
    cell.user = user;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - getter and setter
- (NSMutableArray *)users{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *cell = sender;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    SignChatViewController *room = [segue destinationViewController];
    room.chater = self.users[index.row];
    
}

@end
