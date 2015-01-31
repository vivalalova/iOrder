//
//  networkHelper.m
//  comic
//
//  Created by ShihKuo-Hsun on 2015/1/25.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import "networkHelper.h"
#import "Reachability.h"

networkHelper *networkingInstance;


@interface networkHelper () {
	NSOperationQueue *queue;
	UIAlertView *errAlert;
	UIAlertView *connectAlertView;
	NSMutableURLRequest *request;

	Reachability *interReach;
}

@end

@implementation networkHelper

+ (instancetype)shareInstance {
	if (networkingInstance == nil) {
		networkingInstance = [[networkHelper alloc]init];
	}

	return networkingInstance;
}

#pragma mark - private

- (void)connectWithKeysAndObjects:(NSDictionary *)dict appendURL:(NSString *)url HTTPMethod:(NetworkingCRUD)HTTPMethod Completion:(void (^)(NSDictionary *dict))completion {
	if (![self isConnected]) {
		return;
	}

	NSString *theCommandForBody = @"";

	//just for POST
	if (dict.count) {
		for (NSString *key in dict) {
			NSString *methodAndValue = [NSString stringWithFormat:@"%@=%@&", key, dict[key]];
			theCommandForBody = [theCommandForBody stringByAppendingString:methodAndValue];
		}
		theCommandForBody = [theCommandForBody substringToIndex:theCommandForBody.length - 1];   //拿掉最後的   ＆
	}


	if (request == nil) {
		request = [[NSMutableURLRequest alloc] init];
	}

	[request setTimeoutInterval:30];

	//轉換成UTF8 不然有中文就失效
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	[request setURL:[[NSURL alloc] initWithString:url]];

	NSMutableString *httpBodyString = [[NSMutableString alloc] initWithString:theCommandForBody];

	NSData *encodedData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPBody:encodedData];

	switch (HTTPMethod) {
		case NetworkingCRUDRead:
			[request setHTTPMethod:@"GET"];
			break;

		case NetworkingCRUDCreate:
			[request setHTTPMethod:@"POST"];
			break;

		case NetworkingCRUDUpdate:
			[request setHTTPMethod:@"PATCH"];
			break;

		case NetworkingCRUDDelete:
			[request setHTTPMethod:@"DELETE"];
			break;

		default:
			break;
	}

	if (queue == nil) {
		queue = [[NSOperationQueue alloc]init];
	}

	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
	    if (data.length > 0 && connectionError == nil) {
	        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
	                                                             options:NSJSONReadingAllowFragments
	                                                               error:nil];

	        dispatch_async(dispatch_get_main_queue(), ^{
				completion(dict);
			});
		}
	    else if (data.length == 0 && connectionError == nil) {
	        dispatch_async(dispatch_get_main_queue(), ^{
				[self showAlertWithMessage:@"Something wrong with unknow reasons"];
			});
		}
	    else if (connectionError != nil) {
	        dispatch_async(dispatch_get_main_queue(), ^{
				[self showAlertWithMessage:connectionError.localizedDescription];
			});
		}
	}];
}

#pragma mark - reach

- (void)internetReach {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kJPReachabilityChangedNotification object:nil];
	interReach = [Reachability reachabilityForInternetConnection];
	[interReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note {
	Reachability *currentReach = [note object];

	NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);

	[self updateInterfaceWithReachability:currentReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach {
	bool m_bReachableViaWWAN;
	bool m_bReachableViaWifi;
	bool m_bReachable;

	NetworkStatus curStatus;

	//  According to curReach, modify current internal flags

	//  Internet reachability
	//  Need network status to know real reachability method
	curStatus = [curReach currentReachabilityStatus];

	//  Modify current network status flags
	if (curStatus == ReachableViaWWAN) {
		m_bReachableViaWWAN = true;
	}
	else {
		m_bReachableViaWWAN = false;
	}

	if (curStatus == ReachableViaWiFi) {
		m_bReachableViaWifi = true;
	}
	else {
		m_bReachableViaWifi = false;
	}

	//  Reachable is the OR result of two internal connection flags
	m_bReachable = (m_bReachableViaWifi || m_bReachableViaWWAN);

	NSDictionary *userInfo = @{ @"reachable": m_bReachable ? @"YES" : @"NO" };
	[[NSNotificationCenter defaultCenter]postNotificationName:@"networkStatusChanged" object:nil userInfo:userInfo];
}

- (BOOL)isConnected {
	Reachability *reachability = [Reachability reachabilityWithHostName:@"www.joyphotos.com.tw"];
	NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];

	BOOL internetStatus = NO;

	if (remoteHostStatus == NotReachable) {
		internetStatus = NO;
		[[NSNotificationCenter defaultCenter]postNotificationName:@"appDelegateConnectedFail" object:nil userInfo:nil];
	}
	else if (remoteHostStatus == ReachableViaWWAN) {
		internetStatus = TRUE;
	}
	else if (remoteHostStatus == ReachableViaWiFi) {
		internetStatus = TRUE;
	}

	if (!internetStatus) {
		if (connectAlertView == nil) {
			connectAlertView = [[UIAlertView alloc]initWithTitle:nil
			                                             message:@"網路為離線狀態"
			                                            delegate:nil
			                                   cancelButtonTitle:nil
			                                   otherButtonTitles:@"確定", nil];
			[connectAlertView show];
		}
		else {
			[connectAlertView show];
		}
	}

	return internetStatus;
}

- (void)showAlertWithMessage:(NSString *)message {
	if (!errAlert) {
		errAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
	}
	if (!errAlert.visible) {
		errAlert.message = message;

		[errAlert show];
	}
}

@end
