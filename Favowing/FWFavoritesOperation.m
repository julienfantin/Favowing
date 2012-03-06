//
//  FWFavortiesOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFavoritesOperation.h"
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
    FWFavoritesOperation *copy = [[FWFavoritesOperation allocWithZone:zone] initWithUser:self.user];
    copy.delegate = self.delegate;
    return copy;
}

- (void)perform
{
    [[FWAppDelegate api] performMethod:@"GET"
                            onResource:self.resourcePath
                        withParameters:self.requestParams
                               context:self
                              userInfo:nil];
}

- (NSString *)resourcePath
{
    NSString *resourcePath;
    
    if (self.user.uid == nil) {
        resourcePath = @"/me/favorites";
    }
    else {
        resourcePath = [NSString stringWithFormat:@"/users/%@/favorites", self.user.uid];
    }

    return resourcePath;
}

- (void)requestDidFinishWithData:(NSData *)data
{    
    NSArray *tracks = [self parseObjects:data];
    
    if (self.user.favorites != nil) {
        tracks = [self.user.favorites arrayByAddingObjectsFromArray:tracks];
    }

    self.user.favorites = tracks;
}

- (NSArray *)parseObjects:(NSData *)data
{
    return [FWTrack objectsWithData:data];
}


@end
