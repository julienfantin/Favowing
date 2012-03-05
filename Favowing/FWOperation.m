//
//  FWOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWOperation.h"

@implementation FWOperation

@synthesize delegate;
@synthesize page;
@synthesize fetchAll;

- (id)copyWithZone:(NSZone *)zone
{
    NSAssert(NO, @"Abstract Method");
    return nil;
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
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
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

- (void)perform
{
    NSAssert(NO, @"AbstractMethod");
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
        operation.page = self.page + 1;
        operation.delegate = self;
        NSOperationQueue *q = [NSOperationQueue currentQueue];
        [q addOperation:operation];
        [self addDependency:operation];
    }
    else {        
        [self finish];
    }
}

- (void)apiRequestDidFailWithError:(NSError *)error
{
    [self requestDidFailWithError:error];
    
    [self fail];
}

- (void)finish
{
    if ([self.delegate respondsToSelector:@selector(operationDidFinish:)]) {
        [self.delegate operationDidFinish:self];
    }
    
    finished = YES;
}

- (void)fail
{
    if ([self.delegate respondsToSelector:@selector(operationDidFail:)]) {
        [self.delegate operationDidFail:self];
    }
    
    finished = YES;
}

- (void)requestDidFinishWithData:(NSData *)data
{
    NSAssert(NO, @"Abstract method: override and mark as finished");
}

- (void)requestDidFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    NSAssert(NO, @"Abstract method: override and mark as finished");    
}

- (void)operationDidFail:(FWOperation *)operation
{
    [self removeDependency:operation];
    
    if (! [self.dependencies count]) {
        [self fail];
    }
}

- (void)operationDidFinish:(FWOperation *)operation
{
    [self removeDependency:operation];

    if (! [self.dependencies count]) {
        [self finish];
    }
}

- (NSArray *)parseObjects:(NSData *)data
{
    NSAssert(NO, @"Abstract method");    
    return nil;
}

@end
