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

- (void)perform
{
    NSString *resourcePath = [NSString stringWithFormat:@"/tracks/%@/favoriters", self.track.uid];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i", kFWRequestLimit], @"limit", nil];
    [[FWAppDelegate api] performMethod:@"GET" onResource:resourcePath withParameters:params context:self userInfo:nil];
}

- (void)requestDidFinishWithData:(NSData *)data
{
    finished = YES;
    
    NSArray *favoriters = [FWUser objectsWithData:data];
    self.track.favoriters = favoriters;
}

- (void)requestDidFailWithError:(NSError *)error
{
    finished = YES;
}


@end
