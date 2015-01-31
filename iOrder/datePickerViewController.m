//
//  datePickerViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "datePickerViewController.h"

@interface datePickerViewController (){
    
    IBOutlet UIDatePicker *datePicker;
}

@end

@implementation datePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)canceled:(UIButton *)sender {
    [self.delegate datePickerDidCanceled:self];
}
- (IBAction)okPressed:(UIButton *)sender {
    
    NSDate* date = datePicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日HH點mm分"];
    
    NSString* dateString = [formatter stringFromDate:date];
    
    [self.delegate datePicker:self didEndWithDateString:dateString];
}



@end
