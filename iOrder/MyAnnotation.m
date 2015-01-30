//
//  MyAnnotation.m
//  MapKit_Image
//
//  Created by Stronger Shen on 2014/1/27.
//  Copyright (c) 2014年 MobileIT. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize title, subtitle, coordinate;

-(id)initWithTitle:(NSString *)theTitle andSubTitle:(NSString *)theSubTitle andCoordinate:(CLLocationCoordinate2D)theCoordinate
{
    self = [super init];
    if (self) {
        title = theTitle;
        subtitle = theSubTitle;
        coordinate = theCoordinate;
    }
    return self;
}

@end
