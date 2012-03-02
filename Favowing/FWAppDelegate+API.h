//
//  AppDelegate+Authentication.h
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWAppDelegate.h"
#import "SCAPI.h"

@protocol SCRequestContext <NSObject>
- (void)requestDidFinishWithData:(NSData *)data;
- (void)requestDidFailWithError:(NSError *)error;
@end

@interface FWAppDelegate (API) <SCSoundCloudAPIDelegate>
+ (SCSoundCloudAPI *)api;
@end
