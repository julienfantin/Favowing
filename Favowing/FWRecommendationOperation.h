//
//  FWRecommendationOperation.h
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWOperation.h"
#import "FWTrack.h"

/**
 Given a track will find more tracks like it.
 It will :
 - fetch the list of users who also favorited this track
 - fetch their favorites
 - compute a similarity score for each user
 */
@interface FWRecommendationOperation : FWOperation <FWOperationDelegate>
- (id)initWithTrack:(FWTrack *)aTrack andUser:(FWUser *)aUser;
@property (strong, nonatomic) FWTrack *track;
@property (strong, nonatomic) FWUser *user;
@property (readonly, nonatomic) NSArray *recommendations;
@end
