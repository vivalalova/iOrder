//
//  orderDetailTableViewController.h
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/2/1.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailTableViewController : UITableViewController
@property (weak,nonatomic) PFObject* order;
@property (weak,nonatomic) PFObject* store;
@end
