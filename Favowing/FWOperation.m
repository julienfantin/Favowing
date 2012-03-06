//
//  FWOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWOperation.h"

@interface FWOperation ()
@property (strong, atomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableArray *nextOperations;
@end

@implementation FWOperation

@synthesize delegate;
@synthesize page;
@synthesize fetchAll;
@synthesize queue;
@synthesize nextOperations;

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

    // Internal state
    self.queue = [NSOperationQueue currentQueue];
    self.nextOperations = [NSMutableArray array];
    
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

    [self requestDidFinishWithData:data];

    if (self.fetchAll && [objects count] == kFWRequestLimit) {
        
        FWOperation *operation = [self copy];
//        operation.delegate = self.delegate;
        operation.page = self.page + 1;
        [self.queue addOperation:operation];
    }
//    else {        
    
    if ([self.delegate respondsToSelector:@selector(operationDidFinish:)]) {
        [self.delegate operationDidFinish:self];
    }

        [self finish];
//    }
}

- (void)apiRequestDidFailWithError:(NSError *)error
{
    [self requestDidFailWithError:error];
    
    [self fail];
}

- (void)finish
{    
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)fail
{
    if ([self.delegate respondsToSelector:@selector(operationDidFail:)]) {
        [self.delegate operationDidFail:self];
    }
    
    [self finish];
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
