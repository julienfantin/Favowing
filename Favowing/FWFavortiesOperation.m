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
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSString *resourcePath;
    
    if (self.user.uid == nil) {
        resourcePath = @"/me/favorites";
    }
    else {
        resourcePath = [NSString stringWithFormat:@"/users/%@/favorites", self.user.uid];
    }

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"limit", nil];
    [[FWAppDelegate api] performMethod:@"GET" onResource:resourcePath withParameters:params context:self userInfo:nil];
}


- (BOOL)isConcurrent
{
    return NO;
}

- (BOOL)isExecuting 
{
    return executing;
}

- (BOOL)isFinished 
{
    return finished;
}

- (void)main
{
    @autoreleasepool {
 
        @try {
            while (![self isCancelled] && !finished) {
                /**
                 Hustle
                 */
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {

        }
        
    }
}

- (void)requestDidFinishWithData:(NSData *)data
{
    finished = YES;
    
    NSArray *tracks = [FWTrack objectsWithData:data];
    
    for (FWTrack *track in tracks) {
        NSLog(@"%@", track.title);        
    }
    
    FWTrack *t = [tracks objectAtIndex:0];
    
    SCAudioStream *stream = t.audioStream;
    [stream play];
}

- (void)requestDidFailWithError:(NSError *)error
{
    finished = YES;
}

@end
