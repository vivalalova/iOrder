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

@interface storeDetailViewController (){
    
    IBOutlet UIImageView *streetImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet LOButton *telBtn;
    
    PFObject* voteObj;
}

@end

@implementation storeDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"vote"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%d",objects.count);
        if (objects.count) {
            voteObj = objects[0];
        }
    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PFGeoPoint *point = self.obj[@"geo"];

    NSString* apiKey = @"AIzaSyA99Of_4SfJ2R_6-agylHm45XWiAEFgEmo";
    NSString* url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/streetview?size=400x400&location=%g,%g&sensor=false&key=%@",point.latitude,point.longitude,apiKey];
    NSLog(@"%@",url);
    [streetImageView setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    NSLog(@"%@",url);
    
    nameLabel.text = self.obj[@"name"];
    addressLabel.text = self.obj[@"address"];
    
    if (((NSString*)self.obj[@"tel"]).length == 0) {
        [telBtn setTitle:@"尚無電話號碼" forState:UIControlStateNormal];
        telBtn.enabled = NO;
    }else{
        [telBtn setTitle:[NSString stringWithFormat:@"撥打電話:%@",self.obj[@"tel"]]
                forState:UIControlStateNormal];
    }
    
}
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)routeBtnPressed:(UIButton *)sender {
   NSString*  stringURLScheme=[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",addressLabel.text];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[stringURLScheme stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
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
}

- (IBAction)voteDown:(UIButton *)sender {
    if (!voteObj) {
        voteObj = [[PFObject alloc]initWithClassName:@"vote"];
    }
}



@end
