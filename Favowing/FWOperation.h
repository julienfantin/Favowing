//
//  FWOperation.h
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWAppDelegate+API.h"

#define kFWRequestLimit 50

@class FWOperation;
@protocol  FWOperationDelegate <NSObject>
- (void)operationDidFinish:(FWOperation *)operation;
- (void)operationDidFail:(FWOperation *)operation;
@end

@interface FWOperation : NSOperation <SCRequestContext, FWOperationDelegate>
{
    BOOL executing;
    BOOL finished;
}

@property (weak, nonatomic) id<FWOperationDelegate> delegate;
@property (nonatomic) NSUInteger page;
@property (readonly, nonatomic) NSDictionary *requestParams;
@property (readwrite, nonatomic) BOOL fetchAll;

- (void)perform;
- (void)finish;
- (void)fail;
- (NSArray *)parseObjects:(NSData *)data;

@end
