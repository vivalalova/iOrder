//
//  landingViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "landingViewController.h"
#import <PFFacebookUtils.h>
#define activeColor [UIColor orangeColor]
#define disabledColor [UIColor grayColor]

@interface landingViewController () <UIScrollViewDelegate> {
	IBOutlet LOView *pointLeft;
	IBOutlet LOView *pointCenter;
	IBOutlet LOView *pointRight;
	IBOutlet LOView *pointRightRight;
}
@end


@implementation landingViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSLog(@"%@", [PFUser currentUser]);
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if ([PFUser currentUser]) {
		NSLog(@"__");
		[self performSegueWithIdentifier:@"go" sender:nil];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pointLeft.backgroundColor = disabledColor;
	pointCenter.backgroundColor = disabledColor;
	pointRight.backgroundColor = disabledColor;
	pointRightRight.backgroundColor = disabledColor;

	switch (((int)scrollView.contentOffset.x / 320)) {
		case 0:
			pointLeft.backgroundColor = activeColor;
			break;

		case 1:
			pointCenter.backgroundColor = activeColor;
			break;

		case 2:
			pointRight.backgroundColor = activeColor;
			break;

		case 3:
			pointRightRight.backgroundColor = activeColor;
			break;

		default:
			break;
	}
}

- (IBAction)fbLogin:(id)sender {
	// Set permissions required from the facebook user account
	NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email"];

	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	// Login PFUser using Facebook
	[PFFacebookUtils logInWithPermissions:permissionsArray block: ^(PFUser *user, NSError *error) {
	    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

	    if (!user) {
	        NSString *errorMessage = nil;
	        if (!error) {
	            NSLog(@"Uh oh. The user cancelled the Facebook login.");
	            errorMessage = @"Uh oh. The user cancelled the Facebook login.";
			}
	        else {
	            NSLog(@"Uh oh. An error occurred: %@", error);
	            errorMessage = [error localizedDescription];
			}
	        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
	                                                        message:errorMessage
	                                                       delegate:nil
	                                              cancelButtonTitle:nil
	                                              otherButtonTitles:@"Dismiss", nil];
	        [alert show];
		}
	    else {
	        if (user.isNew) {
	            NSLog(@"User with facebook signed up and logged in!");

	            UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"firstNav"];
	            [self presentViewController:nav animated:NO completion: ^{
				}];
			}
	        else {
	            NSLog(@"User with facebook logged in!");
			}
		}
	}];
}

@end
