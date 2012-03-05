//
//  FWRecommendationOperation.m
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWRecommendationOperation.h"
#import "FWFavoritersOperation.h"
#import "FWFavoritesOperation.h"

@interface FWRecommendationOperation ()
@property (strong, nonatomic) FWFavoritersOperation *favoriters;
@property (strong, nonatomic) FWFavoritesOperation *favorites;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableDictionary *similarUsers;
@end

@implementation FWRecommendationOperation

@synthesize track;
@synthesize user;
@synthesize queue;
@synthesize similarUsers;
@synthesize favoriters;
@synthesize favorites;


- (id)initWithTrack:(FWTrack *)aTrack andUser:(FWUser *)aUser
{
    self = [super init];
    if (self) {
        self.track = aTrack;
        self.user = aUser;
        self.similarUsers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)start
{
    // Get a reference to the currentQueue before we start the background thread
    self.queue = [NSOperationQueue currentQueue];
    
    [super start];
}

- (void)perform
{
    self.favoriters = [[FWFavoritersOperation alloc] initWithTrack:self.track];
    self.favoriters.delegate = self;
    [self addDependency:self.favoriters];
    [self.queue addOperation:self.favoriters];
}

- (void)operationDidFinish:(FWOperation *)operation
{
    // Retrieved people who favorited the track
    if ([operation isKindOfClass:[FWFavoritersOperation class]]) {
        for (FWUser *userWhoAlsoLikesThis in self.favoriters.track.favoriters) {
            FWFavoritesOperation *operation = [[FWFavoritesOperation alloc] initWithUser:userWhoAlsoLikesThis];
            operation.delegate = self;
            [self addDependency:operation];
            [self.queue addOperation:operation];
        }
    }
    // Retrieved favorites of someone who favortied the track
    else {
        FWFavoritesOperation *_operation = (FWFavoritesOperation *)operation;
        
        NSNumber *score = [self.user similarityScoreWithOtherUser:_operation.user];
        
        if (score) {
            NSMutableArray *tracks = [self.similarUsers objectForKey:score];
            if (tracks == nil) {
                tracks = [NSMutableArray array];
            }
            
            NSArray *newTracks = [_operation.user favoritesDifferentFromUser:self.user];
            [tracks addObjectsFromArray:newTracks];
            
            
            [self.similarUsers setObject:tracks forKey:score];
            NSLog(@"Similarity to %@ is %i", _operation.user.name, [score intValue]);
        }
    }
    
    [self removeDependency:operation];
    
    if (! [self.dependencies count]) {
        [self.delegate operationDidFinish:self];
    }
}

- (void)operationDidFail:(FWOperation *)operation
{
    NSLog(@"%@", operation);
}

- (NSArray *)recommendations
{       
    NSArray *sortedsimilarUsers = [self.similarUsers.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        // Descending order of similarity
        return [obj2 compare:obj1];
    }];
    
    NSMutableArray *recommendations = [NSMutableArray array];
    
    [sortedsimilarUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *score = (NSNumber *)obj;
        NSArray *tracks = [self.similarUsers objectForKey:score];
        
        for (FWTrack *similar in tracks) {
            if ([self.user.followings containsObject:similar.user] == NO) {
                [recommendations addObject:similar];
            }
        }
//        [recommendations addObjectsFromArray:tracks];
    }];
    
    
    return recommendations;
}

@end
