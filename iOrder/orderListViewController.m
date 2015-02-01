//
//  orderListViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/2/1.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "orderListViewController.h"
#import "orderDetailTableViewController.h"
@interface orderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray* myOrders;
    IBOutlet UITableView *tableview;
}

@end

@implementation orderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    PFQuery* query = [[PFQuery alloc]initWithClassName:@"OrderMain"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByAscending:@"createAt"];
    [query includeKey:@"store"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            
            myOrders = [[NSMutableArray alloc]initWithArray:objects];
            
            [tableview reloadData];
        }

    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myOrders.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    PFObject* order = myOrders[indexPath.row];
    
    PFObject* store = order[@"store"];
    cell.textLabel.text = store[@"name"];
    
//    NSDate * date = order[@"createAt"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"MMddHHmm"];
//    cell.detailTextLabel.text =@"sub";
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject* order = myOrders[indexPath.row];

    orderDetailTableViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"orderDetailTableViewController"];
    controller.order = order;
    controller.store = order[@"store"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
