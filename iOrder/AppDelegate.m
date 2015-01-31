//
//  AppDelegate.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/30.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import <PFFacebookUtils.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [self regsignPushNotification];
    
    [self parseWithOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    
    return YES;
}

-(void)parseWithOptions:(NSDictionary*)launchOptions{
    [ParseCrashReporting enable];
    
    [Parse setApplicationId:parseAPPID
                  clientKey:parseAPPKey];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
//    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
//    }];
}


-(void)regsignPushNotification{
    // ios8
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //prase
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"DefaultGroup"
                                  forKey:@"channels"];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"failed to get device token \n%@", error);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PFFacebookUtils session] close];
}

@end
