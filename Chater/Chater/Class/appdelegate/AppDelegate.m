//
//  AppDelegate.m
//  Chater
//
//  Created by 郑建文 on 15/10/8.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "AppDelegate.h"
#import "AVOSCloud.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [self.window makeKeyWindow];
//    [self.window makeKeyAndVisible];
    
    
    [AVOSCloud setApplicationId:@"11jix0qu2yakzdpp6ojyyg66ezvzhhoccav7femwcpd6as79" clientKey:@"1x4a91v6xkvw2y6ltw9lzso7chuje9xyowbupzmiicus0lym"];
    
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    UINavigationController *vc = [loginSB instantiateInitialViewController];
    self.window.rootViewController = vc;

    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
