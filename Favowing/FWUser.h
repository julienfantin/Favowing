//
//  FWUser.h
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWObject.h"

@interface FWUser : FWObject

@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) NSArray *followings;
@property (strong, nonatomic) NSArray *recommendations;
@property (readonly, nonatomic) NSString *name;
- (NSNumber *)similarityScoreWithOtherUser:(FWUser *)other;
- (NSArray *)favoritesDifferentFromUser:(FWUser *)other;

@end
