//
//  FWTrack.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWTrack.h"

@implementation FWTrack

@synthesize favoriters;

- (NSString *)artist
{
    return [self valueForKeyPath:@"user.username"];
}

- (NSString *)title
{
    return [self valueForKeyPath:@"title"];
}

- (BOOL)isUserFavorite
{
    return [[self valueForKey:@"user_favorite"] boolValue];
}

- (BOOL)isStreamable
{
    return [[self valueForKey:@"streamable"] boolValue];    
}

@end
