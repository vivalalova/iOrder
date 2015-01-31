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

	[self setNavigationItemColor];

	return YES;
}

- (void)parseWithOptions:(NSDictionary *)launchOptions {
	[ParseCrashReporting enable];

	[Parse setApplicationId:parseAPPID
	              clientKey:parseAPPKey];

	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
//    }];
}

- (void)regsignPushNotification {
	// ios8
	[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
	[[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)setNavigationItemColor {
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		// Uncomment to change the background color of navigation bar
		[UINavigationBar appearance].barTintColor = defaultBlue;

		// Uncomment to change the color of back button
		[UINavigationBar appearance].TintColor = [UIColor whiteColor];

		// Uncomment to assign a custom backgroung image
		// [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationItem.png"] forBarMetrics:UIBarMetricsDefault];

		// Uncomment to change the back indicator image

		//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back.png"]];
		//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_hightLight.png"]];
	}
	else {
		[UINavigationBar appearance].tintColor = defaultBlue;
	}

	// Uncomment to change the font style of the title

	NSShadow *shadow = [[NSShadow alloc] init];
	shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	shadow.shadowOffset = CGSizeMake(0, 0);
	[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
	                                                      [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0], NSForegroundColorAttributeName,
	                                                      shadow, NSShadowAttributeName,
	                                                      [UIFont fontWithName:@"HelveticaNeue" size:21.0], NSFontAttributeName, nil]];
	//                                                     [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
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
	NSLog(@"%@", userInfo);
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
