//
//  commentViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "commentViewController.h"

@interface commentViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{

    IBOutlet UICollectionView *collectionview;
}

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return nil;
}

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate commentViewControllerDidDissmiss:self];
}

@end
