
//
//  FWTrack.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWTrack.h"
#import "FWAppDelegate+API.h"

@implementation FWTrack

@synthesize favoriters;
@synthesize user = _user;
@synthesize audioStream = _audioStream;

- (FWUser *)user
{
    if (_user != nil) {
        return _user;
    }
    
    NSDictionary *userDict = [self valueForKey:@"user"];
    _user = [[FWUser alloc] initWithDictionary:userDict];
    return _user;
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

- (SCAudioStream *)audioStream
{
    if (_audioStream != nil) {
        return _audioStream;
    }
    NSString *stringURL = [self valueForKeyPath:@"stream_url"];
    NSURL *URL = [NSURL URLWithString:stringURL];    
    _audioStream = [[FWAppDelegate api] audioStreamWithURL:URL];    
    return _audioStream;
}

@end
