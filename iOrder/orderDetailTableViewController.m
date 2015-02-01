//
//  orderDetailTableViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/2/1.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "orderDetailTableViewController.h"

@interface orderDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary* details;
}

@end

@implementation orderDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!details) {
        details = [[NSMutableDictionary alloc]init];
    }
    
    PFQuery* query = [[PFQuery alloc]initWithClassName:@"OrderProd"];
    [query includeKey:@"orderID"];
    [query whereKey:@"orderID" equalTo:self.order];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        for (PFObject* detail in objects) {
            NSLog(@"%@",detail[@"Prod"]);
            NSLog(@"%@",detail[@"Qty"]);
            
            if (details[detail[@"Prod"]]) {
                
                int amount = [details[detail[@"prod"]] intValue];
                int addAmount = [detail[@"Qty"] intValue];
                details[detail[@"Prod"]] = [NSString stringWithFormat:@"%d",amount+ addAmount];
            }else{
                details[detail[@"Prod"]] = [NSString stringWithFormat:@"%@",detail[@"Qty"]];
            }
            
        }
        
        [self.tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.store[@"name"];
    
    
    NSString *phNo = @"+919876543210";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
    }
    else if (self.store[@"tel"]){
        
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return details.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = details.allKeys[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"x %@",details.allValues[indexPath.row]];
    
    
    return cell;
}


- (IBAction)phonecallBtnPressed:(UIBarButtonItem *)sender {
    
    NSString *telString = [[NSString alloc]initWithString:self.store[@"tel"]];
    
    telString = [telString stringByReplacingOccurrencesOfString:@"撥打電話:" withString:@""];
    telString = [telString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [RMUniversalAlert showAlertInViewController:self withTitle:@"撥出電話訂購!" message:[NSString stringWithFormat:@"%@", telString] cancelButtonTitle:@"取消" destructiveButtonTitle:@"撥打" otherButtonTitles:nil tapBlock: ^(RMUniversalAlert *alert, NSInteger buttonIndex) {
        if (buttonIndex) {
            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", telString]];
            
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
