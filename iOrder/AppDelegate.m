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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [self regsignPushNotification];
    
    [self parseWithOptions:launchOptions];
    
    
    return YES;
}

-(void)parseWithOptions:(NSDictionary*)launchOptions{
    [ParseCrashReporting enable];
    
    [Parse setApplicationId:parseAPPID
                  clientKey:parseAPPKey];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
    }];
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

@end
