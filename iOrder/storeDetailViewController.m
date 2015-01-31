//
//  storeDetailViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "storeDetailViewController.h"
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MapKit/MapKit.h>

@interface storeDetailViewController () {
	IBOutlet UIImageView *streetImageView;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *addressLabel;
	IBOutlet LOButton *telBtn;
	IBOutlet UILabel *sumScoreLabel;
	PFObject *voteObj;
	IBOutlet UIButton *upVoteBtnn;
	IBOutlet UIButton *downVoteBtn;
	int sumScore;

	IBOutlet UIView *fakeAlertView;
}

@end

@implementation storeDetailViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	PFQuery *query = [[PFQuery alloc]initWithClassName:@"vote"];
//    [query whereKey:@"user" equalTo:[PFUser currentUser]];
	[query whereKey:@"store" equalTo:self.storeObj];
	[query includeKey:@"user"];
	[query includeKey:@"store"];

	[query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
	    NSLog(@"%lu", (unsigned long)objects.count);


	    NSMutableArray *selfVote = [[NSMutableArray alloc]init];

	    sumScore = 0;

	    for (PFObject *vote in objects) {
	        if ([vote[@"upVote"] isEqualToString:@"1"]) {
	            sumScore++;
			}
	        else {
	            sumScore--;
			}
	        [self sumScoreLabelCheck];


	        //挑出自己的
	        if ([((PFUser *)vote[@"user"]).objectId isEqualToString:[PFUser currentUser].objectId]) {
	            [selfVote addObject:vote];
			}
		}

	    NSLog(@"%lu", (unsigned long)selfVote.count);
	    //自己投的
	    if (selfVote.count) {
	        int i = 0;
	        for (PFObject *vote in selfVote) {
	            if ([((PFObject *)vote[@"store"])[@"name"] isEqualToString:self.storeObj[@"name"]]) {
	                voteObj = selfVote[i];
	                [self voteCheck];
	                break;
				}
	            i++;
			}
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	PFGeoPoint *point = self.storeObj[@"geo"];

	NSString *apiKey = @"AIzaSyA99Of_4SfJ2R_6-agylHm45XWiAEFgEmo";
	NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/streetview?size=400x400&location=%g,%g&sensor=false&key=%@", point.latitude, point.longitude, apiKey];
	[streetImageView setImageWithURL:[NSURL URLWithString:url] completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
	}];
	NSLog(@"%@", url);

	nameLabel.text = self.storeObj[@"name"];
	addressLabel.text = self.storeObj[@"address"];


	[self telBtnCheck];

	[storeDetailViewController setShadow:fakeAlertView withRange:CGSizeMake(1, 1)];
}

- (IBAction)back:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion: ^{
	}];
}

- (IBAction)routeBtnPressed:(UIButton *)sender {
	NSString *stringURLScheme = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressLabel.text];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[stringURLScheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)orderBtnPressed:(LOButton *)sender {
}

- (IBAction)groupBtnPressed:(LOButton *)sender {
}

- (IBAction)voteUp:(UIButton *)sender {
	if (!voteObj) {
		voteObj = [[PFObject alloc]initWithClassName:@"vote"];
	}

	voteObj[@"downVote"] = @"";
	voteObj[@"upVote"] = @"1";
	sumScore++;

	[self voteEnd];
}

- (IBAction)voteDown:(UIButton *)sender {
	if (!voteObj) {
		voteObj = [[PFObject alloc]initWithClassName:@"vote"];
	}

	voteObj[@"downVote"] = @"1";
	voteObj[@"upVote"] = @"";
	sumScore--;

	[self voteEnd];
}

- (void)voteEnd {
	voteObj[@"store"] = self.storeObj;
	voteObj[@"user"] = [PFUser currentUser];
	[voteObj saveInBackground];
	[self sumScoreLabelCheck];

	[self voteCheck];
}

- (void)voteCheck {
	upVoteBtnn.enabled = ![voteObj[@"upVote"] isEqualToString:@"1"];
	downVoteBtn.enabled = ![voteObj[@"downVote"] isEqualToString:@"1"];
}

- (void)sumScoreLabelCheck {
	sumScoreLabel.text = [NSString stringWithFormat:@"%d", sumScore];
}

- (void)telBtnCheck {
	if (((NSString *)self.storeObj[@"tel"]).length == 0) {
		[telBtn setTitle:@"尚無電話號碼" forState:UIControlStateNormal];
		telBtn.enabled = NO;
	}
	else {
		[telBtn setTitle:[NSString stringWithFormat:@"撥打電話:%@", self.storeObj[@"tel"]]
		        forState:UIControlStateNormal];
	}

	{//檢查enable
		NSString *phNo = @"+919876543210";
		NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phNo]];

		if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
		}
		else {
			telBtn.enabled = NO;
		}
	}
}

- (IBAction)telBtnPressed:(LOButton *)sender {
	NSString *telString = [[NSString alloc]initWithString:telBtn.titleLabel.text];

	telString = [telString stringByReplacingOccurrencesOfString:@"撥打電話:" withString:@""];
	telString = [telString stringByReplacingOccurrencesOfString:@"-" withString:@""];

	[RMUniversalAlert showAlertInViewController:self withTitle:@"準備撥出電話" message:[NSString stringWithFormat:@"%@", telString] cancelButtonTitle:@"取消" destructiveButtonTitle:@"撥打" otherButtonTitles:nil tapBlock: ^(RMUniversalAlert *alert, NSInteger buttonIndex) {
	    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", telString]];

	    [[UIApplication sharedApplication] openURL:phoneUrl];
	}];
}

#pragma mark - shadow
+ (void)setShadow:(id)sender withRange:(CGSize)size {
	UIView *view = (UIView *)sender;

	view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;

	view.clipsToBounds = NO;
	view.layer.masksToBounds = NO;
	view.layer.shadowRadius = 10;
	view.layer.shadowColor = [UIColor blackColor].CGColor;
	view.layer.shadowOpacity = 0.15;
	view.layer.shadowOffset = size;
}

@end
