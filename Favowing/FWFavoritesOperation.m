//
//  FWFavortiesOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFavoritesOperation.h"
#import "FWAppDelegate+API.h"
#import "FWTrack.h"

@implementation FWFavoritesOperation

@synthesize user;

- (id)initWithUser:(FWUser *)aUser
{
    self = [super init];
    
    if (self) {
        self.user = aUser;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FWFavoritesOperation *copy = [FWFavoritesOperation allocWithZone:zone];
    copy.delegate = self.delegate;
    copy.user = self.user;
    copy.fetchAll = self.fetchAll;
    return copy;
}

- (void)perform
{
    NSString *resourcePath;
    
    if (self.user.uid == nil) {
        resourcePath = @"/me/favorites";
    }
    else {
        resourcePath = [NSString stringWithFormat:@"/users/%@/favorites", self.user.uid];
    }

    [[FWAppDelegate api] performMethod:@"GET" onResource:resourcePath withParameters:self.requestParams context:self userInfo:nil];
}

- (void)requestDidFinishWithData:(NSData *)data
{    
    NSArray *tracks = [FWTrack objectsWithData:data];
    
    if (self.user.favorites != nil) {
        [self.user.favorites arrayByAddingObjectsFromArray:tracks];
    }
    else {
        self.user.favorites = tracks;
    }
}

- (NSArray *)parseObjects:(NSData *)data
{
    return [FWTrack objectsWithData:data];
}


@end
