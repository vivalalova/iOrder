//
//  LOButton.m
//  FPG
//
//  Created by ShihKuo-Hsun on 2015/1/12.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "LOButton.h"

IB_DESIGNABLE
@interface LOButton () {
	IBInspectable CGFloat cornerRadius;
	IBInspectable BOOL masksToBounds;
    
    IBInspectable CGFloat borderWidth;
    IBInspectable UIColor *borderColor;

}

@end

@implementation LOButton

//from code
- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setup];
	}
	return self;
}

//from storyboard
- (void)awakeFromNib {
	[super awakeFromNib];
	[self setup];
}

- (void)setup {
	self.titleLabel.numberOfLines = 20;
	[self drawRect:self.frame];
	self.layer.cornerRadius = cornerRadius;
	self.clipsToBounds = YES;
	self.layer.masksToBounds = masksToBounds;
    
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)prepareForInterfaceBuilder {
	[self setup];
}

@end
