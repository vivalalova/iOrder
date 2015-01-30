//
//  networkHelper.h
//  comic
//
//  Created by ShihKuo-Hsun on 2015/1/25.
//  Copyright (c) 2015年 LO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    NetworkingCRUDRead,
    NetworkingCRUDCreate,
    NetworkingCRUDUpdate,
    NetworkingCRUDDelete
} NetworkingCRUD;


@interface networkHelper : NSObject
+ (instancetype)shareInstance;

- (void)connectWithKeysAndObjects:(NSDictionary *)dict appendURL:(NSString *)url HTTPMethod:(NetworkingCRUD)HTTPMethod Completion:(void (^)(NSDictionary *dict))completion;

@end
