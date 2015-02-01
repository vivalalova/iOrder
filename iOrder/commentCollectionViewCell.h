//
//  commentCollectionViewCell.h
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/31.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profileView;
@property (strong, nonatomic) IBOutlet UILabel *userCommentLabel;

@end
