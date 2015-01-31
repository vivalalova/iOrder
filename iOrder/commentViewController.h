//
//  commentViewController.h
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol commentViewControllerDelegate;

@interface commentViewController : UIViewController
@property (weak,nonatomic) id<commentViewControllerDelegate> delegate;
@property (weak,nonatomic) PFObject* storeObj;
@end

@protocol commentViewControllerDelegate <NSObject>

-(void)commentViewControllerDidDissmiss:(commentViewController*)controller;

@end