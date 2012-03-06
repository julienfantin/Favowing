//
//  FWOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWOperation.h"

@interface FWOperation ()
@property (strong, nonatomic) NSThread *callingThread;
- (void)markFinished;
@end

@implementation FWOperation

@synthesize delegate;
@synthesize page;
@synthesize parent;
@synthesize fetchedAll;
@synthesize callingThread;

- (id)init
{
    self = [super init];
    if (self) {
        self.callingThread = [NSThread currentThread];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSAssert(NO, @"Abstract Method");
    return nil;
}

- (void)start
{
    // KVO
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    // Detach
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
}

- (void)main
{
    @autoreleasepool {
        
        @try {
            
            [self perform];
            
            while (![self isCancelled] && !finished && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
                /**
                 Hustle
                 */
            }
        }
        @catch (NSException *exception) {
            
        }
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting 
{
    return executing;
}

- (BOOL)isFinished 
{
    return finished;
}

- (NSString *)resourcePath
{
    NSAssert(NO, @"Abstract Method");
    return nil;
}

- (void)perform
{
    NSAssert(NO, @"Abstract Method");
}

- (NSDictionary *)requestParams
{
    NSUInteger limit = kFWRequestLimit;
    NSUInteger offset = self.page * kFWRequestLimit;    

    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%i", limit], @"limit",
            [NSString stringWithFormat:@"%i", offset], @"offset",
            nil];
}

- (void)apiRequestDidFinishWithData:(NSData *)data
{
    NSArray *objects = [self parseObjects:data];

    self.fetchedAll = [objects count] < kFWRequestLimit;
    
    [self requestDidFinishWithData:data];

    [self finish];
}

- (void)apiRequestDidFailWithError:(NSError *)error
{
    [self requestDidFailWithError:error];
    
    [self fail];
}

- (void)finish
{   
    SEL callback = @selector(operationDidFinish:);
    
    if ([self.delegate respondsToSelector:callback]) {
        [(id)self.delegate performSelector:callback onThread:self.callingThread withObject:self waitUntilDone:NO];
    }

    [self markFinished];
}

- (void)fail
{
    SEL callback = @selector(operationDidFail:);
    
    if ([self.delegate respondsToSelector:callback]) {
        [(id)self.delegate performSelector:callback onThread:self.callingThread withObject:self waitUntilDone:NO];
    }

    [self markFinished];
}

- (void)markFinished
{
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)requestDidFinishWithData:(NSData *)data
{
    NSAssert(NO, @"Abstract Method: override and mark as finished");
}

- (void)requestDidFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    NSAssert(NO, @"Abstract Method: override and mark as finished");    
}

- (NSArray *)parseObjects:(NSData *)data
{
    NSAssert(NO, @"Abstract Method");
    return nil;
}

@end
