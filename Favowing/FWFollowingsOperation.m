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
    FWFollowingsOperation *copy = [[FWFollowingsOperation allocWithZone:zone] initWithUser:self.user];
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
    NSString *resourcePath;
    
    if (self.user.uid == nil) {
        resourcePath = @"/me/followings";
    }
    else {
        resourcePath = [NSString stringWithFormat:@"/users/%@/followings", self.user.uid];
    }
    
    return resourcePath;
}

- (void)requestDidFinishWithData:(NSData *)data
{    
    NSArray *users = [self parseObjects:data];
    
    if (self.user.followings != nil) {
        users = [self.user.followings arrayByAddingObjectsFromArray:users];
    }

    self.user.followings = users;
}

- (NSArray *)parseObjects:(NSData *)data
{
    return [FWUser objectsWithData:data];
}

@end
