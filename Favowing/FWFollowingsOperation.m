//
//  FWFollowingsOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFollowingsOperation.h"

@implementation FWFollowingsOperation

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
    FWFollowingsOperation *copy = [FWFollowingsOperation allocWithZone:zone];
    copy.delegate = self.delegate;
    copy.user = self.user;
    
    return copy;
}

- (void)perform
{
    NSString *resourcePath;
    
    if (self.user.uid == nil) {
        resourcePath = @"/me/followings";
    }
    else {
        resourcePath = [NSString stringWithFormat:@"/users/%@/followings", self.user.uid];
    }
    
    [[FWAppDelegate api] performMethod:@"GET" onResource:resourcePath 
                        withParameters:self.requestParams
                               context:self 
                              userInfo:nil];
}

- (void)requestDidFinishWithData:(NSData *)data
{    
    NSArray *users = [self parseObjects:data];
    
    if (self.user.followings != nil) {
        [self.user.followings arrayByAddingObjectsFromArray:users];
    }
    else {
        self.user.followings = users;
    }
}

- (NSArray *)parseObjects:(NSData *)data
{
    return [FWUser objectsWithData:data];
}
@end
