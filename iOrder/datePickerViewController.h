//
//  datePickerViewController.h
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol datePickerVCDelegate;

@interface datePickerViewController : UIViewController
@property (weak, nonatomic) id <datePickerVCDelegate> delegate;
@end

@protocol datePickerVCDelegate <NSObject>

- (void)datePickerDidCanceled:(datePickerViewController *)controller;
- (void)datePicker:(datePickerViewController *)controller didEndWithDateString:(NSString *)dateString;


@end
