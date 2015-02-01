//
//  ViewController.m
//  iOrder
//
//  Created by ShihKuo-Hsun on 2015/1/30.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "ViewController.h"
#import "networkHelper.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "storeDetailViewController.h"
#import <UIAlertController+Blocks.h>
#import <UIAlertView+Blocks.h>
#import <MapKit/MapKit.h>

#import "orderListViewController.h"


@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate> {
	IBOutlet MKMapView *map;

	NSMutableArray *stores;

	BOOL isLocated;

	IBOutlet UILabel *centreAddress;
	IBOutlet UIImageView *centreImageView;

	NSMutableArray *objs;

	CLLocationCoordinate2D centre;
	//增加商店
	IBOutlet UIBarButtonItem *addStoreBtn;
	UIBarButtonItem *cancelBtn;
	IBOutlet UIBarButtonItem *okBtn;
	BOOL isAdding;
}
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

#define classNameOfStores @"stores"

- (void)viewDidLoad {
	[super viewDidLoad];


	PFQuery *query = [[PFQuery alloc]initWithClassName:@"stores"];
	query.limit = 1000;

	[query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
	    objs = [[NSMutableArray alloc]initWithArray:objects];
	    for (PFObject *obj in objects) {
	        [self addAnnoWithLocation:obj];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.locationManager = [[CLLocationManager alloc]init];
	_locationManager.delegate = self;
	_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	_locationManager.distanceFilter = 100;
	[_locationManager requestWhenInUseAuthorization];
	[_locationManager startUpdatingLocation];


	PFUser *user = [PFUser currentUser];
	NSLog(@"%@", user[@"id"]);

	[self addingCheck];
}

- (void)addAnnoWithLocation:(PFObject *)obj {
	PFGeoPoint *point = obj[@"geo"];

	CLLocationCoordinate2D location;
	location.latitude = point.latitude;
	location.longitude = point.longitude;

	//放插針
	MyAnnotation *annoTrainStation = [[MyAnnotation alloc] initWithTitle:obj[@"name"] andSubTitle:obj[@"address"] andCoordinate:location];

	[map addAnnotation:annoTrainStation];
}

#pragma mark - ib action

- (IBAction)addStoreBtnPressed:(UIBarButtonItem *)sender {
	isAdding = YES;
	[self addingCheck];
}

- (void)cancelBtnPressed {
	isAdding = NO;
	[self addingCheck];
}

- (void)addingCheck {
	if (isAdding) {
		if (!cancelBtn) {
			cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
			                                                         target:self
			                                                         action:@selector(cancelBtnPressed)];
		}
		self.navigationItem.rightBarButtonItem = cancelBtn;
	}
	else {
		self.navigationItem.rightBarButtonItem = addStoreBtn;
	}

    [okBtn setImage:(isAdding ? [UIImage imageNamed : @"yes-44"] :[UIImage imageNamed:@"Bitmap"])];

	centreAddress.hidden = !isAdding;
	centreImageView.hidden = !isAdding;
}

- (IBAction)okBtnPressed:(UIBarButtonItem *)sender {
	if (isAdding) {
		NSLog(@"__ %lu", (unsigned long)[centreAddress.text rangeOfString:@"(null)"].location);

		if ([centreAddress.text rangeOfString:@"(null)"].location != NSNotFound) {
			[RMUniversalAlert showAlertInViewController:self withTitle:@"地址錯誤" message:@"請移至其他位置" cancelButtonTitle:@"確認" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock: ^(RMUniversalAlert *alert, NSInteger buttonIndex) {
			}];

			return;
		}

		isAdding = NO;
		[self addingCheck];

		PFObject *newStore = [[PFObject alloc]initWithClassName:@"stores"];
		newStore[@"address"] = centreAddress.text;
		newStore[@"location"] = [centreAddress.text substringToIndex:3];

		PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:centre.latitude longitude:centre.longitude];
		newStore[@"geo"] = point;

		NSLog(@"%@", newStore);

		UIAlertController *alert = [UIAlertController showAlertInViewController:self withTitle:@"新增餐廳" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"確定"] tapBlock: ^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
		    if (buttonIndex) {
		        UITextField *textfield = controller.textFields[0];
		        newStore[@"name"] = textfield.text;

		        [newStore saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
		            if (succeeded) {
		                [objs addObject:newStore];
		                [self addAnnoWithLocation:newStore];
					}
		            else {
		                [RMUniversalAlert showAlertInViewController:self withTitle:@"err" message:error.localizedDescription cancelButtonTitle:@"ok" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
					}
				}];
			}
		}];

		[alert addTextFieldWithConfigurationHandler: ^(UITextField *textField) {
		    textField.placeholder = @"餐廳名稱";
		}];
	}
	else {//看訂單
        NSLog(@"= = ");
        [self performSegueWithIdentifier:@"goList" sender:nil];
//        orderListViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"orderListViewController"];
//        [self.navigationController pushViewController:controller animated:YES];
	}
}

- (IBAction)locationToUser:(UIButton *)sender {
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		[RMUniversalAlert showAlertInViewController:self withTitle:@"本應用需要取得使用者位置" message:@"請至 設定->隱私權->定位-> 當中開啟" cancelButtonTitle:@"取消" destructiveButtonTitle:@"確定" otherButtonTitles:nil tapBlock: ^(RMUniversalAlert *alert, NSInteger buttonIndex) {
		    if (buttonIndex) {
		        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			}
		}];
	}

	CLLocationCoordinate2D currentLocation = map.userLocation.location.coordinate;

	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation, 1000, 1000);
	[map setRegion:viewRegion animated:YES];
}

#pragma mark - map kit

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	if (!isLocated) {
		[self locationToUser:nil];
		isLocated = YES;
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation> )annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}

	static NSString *identifier = @"AnnoID";

	MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (annoView) {
		annoView.annotation = annotation;
	}
	else {
		UIImage *image = [self makeImageofColor:[UIColor redColor]];
		annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		annoView.canShowCallout = YES;
		annoView.image = image;

		UIButton *rightBtn =  [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		annoView.rightCalloutAccessoryView = rightBtn;
//        annoView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ice cream 1 thumb.jpg"]];
	}


	return annoView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	NSLog(@"you touched the disclosure indicator");
	//launch a new view upon touching the disclosure indicator

	NSString *title = view.annotation.title;


	int index = 0;
	for (PFObject *obj in objs) {
		if ([obj[@"name"] isEqualToString:title]) {
			NSLog(@"%@", title);

			storeDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"storeDetailViewController"];
			controller.storeObj = obj;
			[self.navigationController pushViewController:controller animated:YES];
			return;
		}
		index++;
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	centre = [map centerCoordinate];
	NSLog(@"%f , %f", centre.latitude, centre.longitude);

	[self getAddressFromLocation:[[CLLocation alloc]initWithLatitude:centre.latitude longitude:centre.longitude]];
}

- (void)getAddressFromLocation:(CLLocation *)location {
	CLGeocoder *geoCoder = [[CLGeocoder alloc]init];

	//NSLog(@"will get");
	[geoCoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks, NSError *error) {
	    if (placemarks && placemarks.count > 0) {
	        CLPlacemark *placemark = placemarks[0];
	        centreAddress.text = [NSString stringWithFormat:@"%@%@%@%@號", placemark.administrativeArea, placemark.locality, placemark.locality, placemark.subThoroughfare];
		}
	}];
}

- (UIImage *)makeImageofColor:(UIColor *)color {
	UIGraphicsBeginImageContext(CGSizeMake(16, 16));

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color.CGColor);

	//// Oval Drawing
	UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 16, 16)];
	[color setFill];
	[ovalPath fill];


	//// Oval 2 Drawing
	UIBezierPath *oval2Path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(3, 3, 10, 10)];
	[UIColor.whiteColor setFill];
	[oval2Path fill];


	UIImage *bezierImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return bezierImage;
}

@end
