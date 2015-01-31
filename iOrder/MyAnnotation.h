//
//  MyAnnotation.h
//  MapKit_Image
//
//  Created by Stronger Shen on 2014/1/27.
//  Copyright (c) 2014年 MobileIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithTitle:(NSString *)theTitle andSubTitle:(NSString *)theSubTitle andCoordinate:(CLLocationCoordinate2D)theCoordinate;

@end
