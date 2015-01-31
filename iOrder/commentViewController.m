//
//  commentViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "commentViewController.h"
#import "commentCollectionViewCell.h"
@interface commentViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{

    IBOutlet UICollectionView *collectionview;
    IBOutlet UITextField *textField;
    IBOutlet NSLayoutConstraint *textFieldConstant;
    
    NSMutableArray* comments;
}

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KBAppear) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KBDisapper) name:UIKeyboardWillHideNotification object:nil];
    
    [self load];
    
}

-(void)load{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    PFQuery* query = [[PFQuery alloc]initWithClassName:@"comment"];
    [query includeKey:@"user"];
    [query whereKey:@"store" equalTo:self.storeObj];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        comments = objects;
        NSLog(@"%d",objects.count);
        [collectionview reloadData];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

-(void)KBAppear{
    [UIView animateWithDuration:0.3 animations:^{
        textFieldConstant.constant = 256;
        [self.view layoutIfNeeded];
    }];
}

-(void)KBDisapper{
    [UIView animateWithDuration:0.3 animations:^{
        textFieldConstant.constant = 8;
        [self.view layoutIfNeeded];
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (comments.count) {
        return comments.count;
    }else{
        return 1;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    commentCollectionViewCell* cell = [collectionview dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSLog(@"%d",comments.count);
    
    if (comments.count) {
        PFObject* comment = comments[indexPath.row];
        cell.userImageView.image = nil;
        cell.userCommentLabel.text = comment[@"comment"];
        
        return cell;
        
    }else{
        cell.userImageView.image = nil;
        cell.userCommentLabel.text = @"尚未有人發表評論";
        
        return cell;
    }
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self hideKB:nil];
}

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate commentViewControllerDidDissmiss:self];
}

- (IBAction)hideKB:(UIButton *)sender {
    [textField resignFirstResponder];

}

- (IBAction)sendBtnPreesed:(UIButton *)sender {
    if (textField.text.length > 0) {
        PFObject *obj = [[PFObject alloc]initWithClassName:@"comment"];
        obj[@"user"] = [PFUser currentUser];
        obj[@"store"] = self.storeObj;
        obj[@"comment"] = textField.text;
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            textField.text = @"";
            
            if (error) {
                [RMUniversalAlert showAlertInViewController:self withTitle:@"error" message:error.localizedDescription cancelButtonTitle:@"ok" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                    
                }];
                
            }else{
                [self load];
            }
            [self hideKB:nil];
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        }];
        
    }
}



@end
