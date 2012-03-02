//
//  FWFavortiesOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFavortiesOperation.h"
#import "FWAppDelegate+API.h"
#import "FWTrack.h"

@implementation FWFavortiesOperation

@synthesize user;

- (id)initWithUser:(FWUser *)aUser
{
    self = [super init];
    
    if (self) {
        self.user = aUser;
    }
    
    return self;
}

- (void)start
{
    [super start];
    
    NSString *resourcePath;
    
    if (self.user.uid == nil) {
        resourcePath = @"/me/favorites";
    }
    else {
        resourcePath = [NSString stringWithFormat:@"/users/%@/favorites", self.user.uid];
    }

    [[FWAppDelegate api] performMethod:@"GET" onResource:resourcePath withParameters:nil context:self userInfo:nil];
}

- (void)requestDidFinishWithData:(NSData *)data
{
    NSArray *tracks = [FWTrack objectsWithData:data];
    
    NSLog(@"%@", tracks);
}

- (void)requestDidFailWithError:(NSError *)error
{
    
}

@end
