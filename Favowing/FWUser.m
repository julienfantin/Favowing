//
//  FWUser.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWUser.h"
#import "FWTrack.h"

@implementation FWUser

@synthesize favorites;
@synthesize followings;
@synthesize recommendations;

- (NSNumber *)similarityScoreWithOtherUser:(FWUser *)other
{
    if ([other isEqual:self]) {
        return nil;
    }
    
    NSMutableSet *mines = [NSMutableSet setWithArray:self.favorites];
    NSMutableSet *hers = [NSMutableSet setWithArray:other.favorites];
    [mines intersectSet:hers];
    return [NSNumber numberWithUnsignedInteger:mines.count];
}

- (NSString *)name  
{
    return [self valueForKey:@"username"];
}

- (NSArray *)favoritesDifferentFromUser:(FWUser *)other
{
    NSMutableSet *mines = [NSMutableSet setWithArray:self.favorites];
    NSMutableSet *hers = [NSMutableSet setWithArray:other.favorites];
    [mines minusSet:hers];
    
    return [mines allObjects];
}

@end
