//
//  FWFavoritersOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFavoritersOperation.h"
#import "FWUser.h"

@implementation FWFavoritersOperation

@synthesize track;

- (id)initWithTrack:(FWTrack *)aTrack
{
    self = [super init];
    if (self) {
        self.track = aTrack;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FWFavoritersOperation *copy = [[FWFavoritersOperation allocWithZone:zone] initWithTrack:self.track];
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
    return [NSString stringWithFormat:@"/tracks/%@/favoriters", self.track.uid];
}

- (void)requestDidFinishWithData:(NSData *)data
{    
    NSArray *favoriters = [self parseObjects:data];
    
    if (self.track.favoriters != nil) {
        favoriters = [self.track.favoriters arrayByAddingObjectsFromArray:favoriters];
    }

    self.track.favoriters = favoriters;
}

- (NSArray *)parseObjects:(NSData *)data
{
    return [FWUser objectsWithData:data];
}

@end
